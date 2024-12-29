#------------------------------------------------------------------------------
# Logger.ps1のテスト
#------------------------------------------------------------------------------
# ドットソースでテスト対象スクリプトの読み込みを行う
Set-Location (Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent)
. (".\Modules\" + (Split-Path -Path $PSCommandPath -Leaf ).replace(".Tests.ps1", ".ps1"))

# テストするスクリプト名
$testScriptName = (Split-Path -Path $PSCommandPath -Leaf).replace(".Tests.ps1", ".ps1")

#------------------------------------------------------------------------------
# テストのセットアップ
#------------------------------------------------------------------------------
BeforeDiscovery {}

#------------------------------------------------------------------------------
# テスト本体
#------------------------------------------------------------------------------
Describe $testScriptName"のユニットテスト" {
  BeforeAll {
    # デバッグ出力を「出力して継続」に変更
    $DebugPreference = "Continue"

    # テスト対象のスクリプトを読み込む
    . (".\Modules\" + (Split-Path -Path $PSCommandPath -Leaf ).replace(".Tests.ps1", ".ps1"))
    $Logger = [Logger]::new()
    $Logger.logFolder = "TestDrive:\"
    $Logger.logFilename = "test.log"
  }
  BeforeEach {}
  AfterEach {}
  AfterAll {}

  Context '正常系' {
    It 'ログレベルに沿ったログ出力がなされること' {
      $message = "test-message"

      $Logger.debug($message)
      Get-Content (Join-Path $Logger.logFolder $Logger.logFilename) -Tail 1 | Should -Match ".*DEBUG.*$message.*" 
      $Logger.info($message)
      Get-Content (Join-Path $Logger.logFolder $Logger.logFilename) -Tail 1 | Should -Match ".*INFO.*$message.*" 

      $Logger.warn($message)
      Get-Content (Join-Path $Logger.logFolder $Logger.logFilename) -Tail 1 | Should -Match ".*WARN.*$message.*" 

      $Logger.error($message)
      Get-Content (Join-Path $Logger.logFolder $Logger.logFilename) -Tail 1 | Should -Match ".*ERROR.*$message.*" 
    }

    It '出力元名が正しいこと' {
      $message = "test-message"
      $Logger.debug($message)
      Get-Content (Join-Path $Logger.logFolder $Logger.logFilename) -Tail 1 | Should -Match ".*$testScriptName.*" 

      $Logger.sourceName = "test-source"
      $Logger.debug($message)
      Get-Content (Join-Path $Logger.logFolder $Logger.logFilename) -Tail 1 | Should -Match ".*test-source.*" 
    }

  }

  Context "異常系" {
    It "例外発生" {
      # Specific Non-Existing Directory
      $Logger.logFolder = (Join-Path $Logger.logFolder "DummyDummyDir")
        
      {
        $Logger.debug($message)
      } | Should -Throw -ExceptionType System.IO.DirectoryNotFoundException
    }
  }
}

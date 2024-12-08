#------------------------------------------------------------------------------
# Logger.ps1のテスト
#------------------------------------------------------------------------------
# ドットソースでテスト対象スクリプトの読み込みを行う
Set-Location (Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent)
. (".\Modules\" + (Split-Path -Path $PSCommandPath -Leaf ).replace(".Tests.ps1", ".ps1"))

# テストするスクリプト名
$testScriptName = (Split-Path -Path $PSCommandPath -Leaf).replace(".Tests.ps1", ".ps1")

# Powershellの $MyInvocation変数の退避
# このスクリプトの $MyInvocation は It セクションでは取得できない
# https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-5.1#myinvocation
$testScriptMyInvocation = $MyInvocation

#------------------------------------------------------------------------------
# テストのセットアップ
#------------------------------------------------------------------------------
BeforeDiscovery {}

#------------------------------------------------------------------------------
# テスト本体
#------------------------------------------------------------------------------
Describe $testScriptName"のユニットテスト" {
  BeforeAll {}
  BeforeEach {}
  AfterEach {}
  AfterAll {}

  Context "正常系" {
    It "Regular-TestCase" {
      $Logger = New-Object Logger($testScriptMyInvocation)
      #$Logger = [Logger]::new($testScriptMyInvocation)
      $message = "test-message"

      $Logger.debug($message)
      Get-Content (Join-Path $Logger.logDir $Logger.logFilename) -Tail 1 | Should -Match ".*DEBUG.*$message.*" 

      $Logger.info($message)
      Get-Content (Join-Path $Logger.logDir $Logger.logFilename) -Tail 1 | Should -Match ".*INFO.*$message.*" 

      $Logger.warn($message)
      Get-Content (Join-Path $Logger.logDir $Logger.logFilename) -Tail 1 | Should -Match ".*WARN.*$message.*" 

      $Logger.error($message)
      Get-Content (Join-Path $Logger.logDir $Logger.logFilename) -Tail 1 | Should -Match ".*ERROR.*$message.*" 
    }
  }

  Context "異常系" {
    It "Exception-TestCase" {

      $Logger = New-Object Logger($testScriptMyInvocation)
      # Specific Non-Existing Directory
      $Logger.logDir = (Join-Path $Logger.logDir "DummyDummyDir")
        
      { $Logger.debug($message) } | Should -Throw -ExceptionType System.IO.DirectoryNotFoundException
    }
  }

}

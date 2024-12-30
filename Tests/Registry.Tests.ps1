#------------------------------------------------------------------------------
# Logger.ps1のテスト
#------------------------------------------------------------------------------
BeforeAll {
  # ドットソースでテスト対象スクリプトの読み込みを行う
  Set-Location (Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent)
  . (".\Modules\" + (Split-Path -Path $PSCommandPath -Leaf ).replace(".Tests.ps1", ".ps1"))

  # デバッグの設定
  $DebugPreference = "continue"
}

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

  Context "Get-RegistryValueのテスト" {
    it "存在しないレジストリキー" {
      # テスト実施
      $ret = Get-RegistryValue -RegKeyPath "TestRegistry:\NotExistKey" -RegEntry "TestName"

      # テスト結果の判定
      $ret.value | Should -Be ""
      $ret.isExist | Should -Be $false
    }

    it "存在しないレジストリエントリの取得" {
      # テスト準備
      New-Item -Path "TestRegistry:\TestKey" -Force

      # テスト実施
      $ret = Get-RegistryValue -RegKeyPath "TestRegistry:\TestKey" -RegEntry "NotExistName"

      # テスト結果の判定
      $ret.value | Should -Be $null
      $ret.isExist | Should -Be $false
    }

    it "存在するレジストリエントリの取得" {
      # モックの設定
      Mock -CommandName Test-Path -MockWith { return $true }
      # テスト準備
      New-Item -Path "TestRegistry:\TestKey" -Force
      New-ItemProperty -Path "TestRegistry:\TestKey" -Name "TestName" -Value "TestValue" -PropertyType "String" -Force

      # テスト実施
      $ret = Get-RegistryValue -RegKeyPath "TestRegistry:\TestKey" -RegEntry "TestName"

      # テスト結果の判定
      $ret.value | Should -Be "TestValue"
      $ret.isExist | Should -Be $true
    }

    it "例外発生" {
      # モックの設定
      Mock -CommandName Test-Path -MockWith { throw "TestException" }

      # テスト実施
      {
        Get-RegistryValue -RegKeyPath "TestRegistry:\TestKey" -RegEntry "TestName"
      } |
      # テスト結果の判定
      Should -Throw "TestException"
    }
  }
 
  Context "New-RegKeyPathのテスト" {
    AfterEach {
      # テスト後処理
      Remove-Item -Path "TestRegistry:\TestKey\TestSubKey" -Force -ErrorAction SilentlyContinue
      Remove-Item -Path "TestRegistry:\TestKey" -Force -ErrorAction SilentlyContinue
    }

    it "正常系（親キーが存在する）" {
      # テスト準備
      New-Item -Path "TestRegistry:\TestKey" -Force

      # テスト実施
      New-RegKeyPath -Path "TestRegistry:\TestKey\TestSubKey"
  
      # テスト結果の判定
      Test-Path -Path "TestRegistry:\TestKey\TestSubKey" | Should -Be $true
    }

    it "正常系（親キーが存在しない）" {
      # テスト実施
      New-RegKeyPath -Path "TestRegistry:\TestKey\TestSubKey"
  
      # テスト結果の判定
      Test-Path -Path "TestRegistry:\TestKey\TestSubKey" | Should -Be $true
    }

    it "例外発生" {
      # モックの設定
      Mock -CommandName Test-Path -MockWith { throw "TestException" }

      # テスト実施
      {
        New-RegKeyPath -Path "TestRegistry:\TestKey\TestSubKey"
      } |
      # テスト結果の判定
      Should -Throw "TestException"
    }
  }
  
  Context "Set-RegistryEntryのテスト" {
    AfterEach {
      # テスト後処理
      Remove-Item -Path "TestRegistry:\TestKey" -Force -ErrorAction SilentlyContinue
    }

    it "正常系(レジストリキーが存在する)" {
      # テスト準備
      New-Item -Path "TestRegistry:\TestKey" -Force

      # テスト実施
      Set-RegistryEntry -RegKeyPath "TestRegistry:\TestKey" -RegEntry "TestName" -Value "TestValue" -RegType "String"
  
      # テスト結果の判定
      Get-ItemPropertyValue -Path "TestRegistry:\TestKey" -Name "TestName" | Should -Be "TestValue"
    }

    it "正常系(レジストリキーが存在しない)" {
      # テスト実施
      Set-RegistryEntry -RegKeyPath "TestRegistry:\TestKey" -RegEntry "TestName" -Value "TestValue" -RegType "String"
  
      # テスト結果の判定
      Get-ItemPropertyValue -Path "TestRegistry:\TestKey" -Name "TestName" | Should -Be "TestValue"
    }

    it "例外発生" {
      # モックの設定
      Mock -CommandName New-ItemProperty -MockWith { throw "TestException" }

      # テスト実施
      {
        Set-RegistryEntry -RegKeyPath "TestRegistry:\TestKey" -RegEntry "TestName" -Value "TestValue" -RegType "String"
      } |
      # テスト結果の判定
      Should -Throw "TestException"
    }
  }

  Context "Remove-RegistryEntryのテスト" {
    BeforeEach {
      # テスト準備
      New-Item -Path "TestRegistry:\TestKey" -Force
      New-ItemProperty -Path "TestRegistry:\TestKey" -Name "TestName" -Value "TestValue" -PropertyType "String" -Force
    }

    it '正常系(レジストリキーが存在しない)' {
      # テスト実施
      $ret = Remove-RegistryEntry -RegKeyPath "TestRegistry:\NotExistKey" -RegEntry "TestName"

      # テスト結果の判定
      $ret.isSuccess | Should -Be $false 
    }

    it '正常系(レジストリエントリが存在しない)' {
      # テスト準備
      Remove-ItemProperty -Path "TestRegistry:\TestKey" -Name "TestName"
      # テスト実施
      $ret = Remove-RegistryEntry -RegKeyPath "TestRegistry:\TestKey" -RegEntry "TestName"

      # テスト結果の判定
      $ret.isSuccess | Should -Be $false 
    }

    it "正常系(レジストリエントリが存在する)" {
      # テスト実施
      $ret = Remove-RegistryEntry -RegKeyPath "TestRegistry:\TestKey" -RegEntry "TestName"
  
      # テスト結果の判定
      $ret.isSuccess | Should -Be $true
      Test-Path -Path "TestRegistry:\TestKey" | Should -Be $true
      Test-Path -Path "TestRegistry:\TestKey\TestName" | Should -Be $false
    }

    it '例外発生' {
      # モックの設定
      Mock -CommandName Remove-ItemProperty -MockWith { throw "TestException" }

      # テスト実施
      {
        Remove-RegistryEntry -RegKeyPath "TestRegistry:\TestKey" -RegEntry "TestName"
      } |
      # テスト結果の判定
      Should -Throw "TestException"
    }
  }
}

#------------------------------------------------------------------------------
# xxxxx.ps1のテスト
#------------------------------------------------------------------------------
# ドットソースでテスト対象スクリプトの読み込みを行う
Set-Location (Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent)
. (".\Modules\" + (Split-Path -Path $PSCommandPath -Leaf ).replace(".Tests.ps1", ".ps1"))

# テストするスクリプト名
$testScriptName = (Split-Path -Path $PSCommandPath -Leaf)

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
    It "Regular-TestCase1" {
    }

    It "Regular-TestCase2" {
    }
  }

  Context "異常系" {
    It "Exception-TestCase1" {
    }

    It "Exception-TestCase2" {
    }
  }
}

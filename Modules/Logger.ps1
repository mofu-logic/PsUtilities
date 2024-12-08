<#
.SYNOPSIS
指定されたフォーマットで指定されたディレクトリにログを書き込むためのLoggerクラス

.DESCRIPTION
Loggerクラスは、各種レベル（デバッグ、情報、警告、エラー）でログを書き込むメソッドを提供します
ログは、logDirフィールドで指定されたディレクトリに、logLayoutフィールドで指定されたフォーマットで書き込まれます

.PARAMETER encoding
ログファイルの文字エンコーディング
デフォルトは "Default"

.PARAMETER logLayout
ログメッセージのレイアウト
デフォルトは "%d %s %p %m"

.PARAMETER datetimeLayout
日時のフォーマット
デフォルトは "yyyyMMddTHHmmssZ"

.METHOD debug
デバッグレベルのログを書き込みます

.METHOD info
情報レベルのログを書き込みます

.METHOD warn
警告レベルのログを書き込みます

.METHOD error
エラーレベルのログを書き込みます

.EXAMPLE
$logger = New-Object Logger($MyInvocation)
$logger.info("これは情報レベルのログメッセージです。")
$logger.error("これはエラーレベルのログメッセージです。")
#>

class Logger {
  # プロパティ（必須）
  # ログエンコーディング
  [string] $encoding = "Default"
  # 出力レイアウト
  [string] $outputLayout = "%d %s %p %m"
  # 日付フォーマット
  [string] $datetimeFormat = "yyyyMMddTHHmmssZ"

  # プロパティ(オプション)
  # デフォルト出力元名
  [string] $sourceName
  #
  [string] $logCreatedDatetime
  # ログ出力先フォルダ
  [string] $logFolder
  # ログファイル名
  [string] $logFilename

  # コンストラクタ
  Logger ($InvokingScriptMyInvocation) {
      # デフォルトは呼び出し元のPowershellファイル名
      $this.sourceName = (Split-Path -Leaf $InvokingScriptMyInvocation.MyCommand.Name).replace(".ps1", "")
      # ロガー作成日時の初期化（フォーマットは、コンストラクタの日付フォーマット）
      $this.logCreatedDatetime = Get-Date -Format $this.datetimeFormat
      # ログ出力先フォルダ名
      $this.logFolder = (Split-Path -Parent $InvokingScriptMyInvocation.MyCommand.Path)
      # ログファイル名
      $this.logFilename = (Split-Path -Leaf $InvokingScriptMyInvocation.MyCommand.Name).replace(".ps1", "-" + $this.logCreatedDatetime + ".log")
  }

  # デバッグログを出力するメソッド
  [void] debug([string]$message) {
      $this.writeLog($message, "DEBUG")
  }

  # 情報ログを出力するメソッド
  [void] info([string]$message) {
      $this.writeLog($message, "INFO")
  }

  # 警告ログを出力するメソッド
  [void] warn([string]$message) {
      $this.writeLog($message, "WARN")
  }

  # エラーログを出力するメソッド
  [void] error([string]$message) {
      $this.writeLog($message, "ERROR")
  }

  # ログレベル毎のログメッセージを出力するメソッド
  hidden [void] writeLog($message, $logLevel) {

      $replacedLayout = $this.logLayout
      $replacedLayout = $replacedLayout.replace("%d", (Get-Date -Format $this.datetimeLayout))
      $replacedLayout = $replacedLayout.replace("%p", $logLevel)
      $replacedLayout = $replacedLayout.replace("%s", $this.scriptName)
      $replacedLayout = $replacedLayout.replace("%m", $message)

      Write-Output $replacedLayout | Out-File -FilePath (Join-Path $this.logDir $this.logFilename) -Append -Encoding $this.encoding
  }
}

Write-Host "loaded."

# <#
# .SYNOPSIS
# 指定されたフォーマットで指定されたディレクトリにログを書き込むためのLoggerクラス

# .DESCRIPTION
# Loggerクラスは、各種レベル（デバッグ、情報、警告、エラー）でログを書き込むメソッドを提供します
# ログは、logDirフィールドで指定されたディレクトリに、logLayoutフィールドで指定されたフォーマットで書き込まれます

# .PARAMETER encoding
# ログファイルの文字エンコーディング
# デフォルトは "Default"

# .PARAMETER logLayout
# ログメッセージのレイアウト
# デフォルトは "%d %s %p %m"
# %d: 日時
# %s: 出力元名
# %p: ログレベル
# %m: ログメッセージ

# .PARAMETER datetimeLayout
# 日時のフォーマット
# デフォルトは "yyyy/MM/dd HH:mm:ss.fff"

# .METHOD debug
# デバッグレベルのログを書き込みます

# .METHOD info
# 情報レベルのログを書き込みます

# .METHOD warn
# 警告レベルのログを書き込みます

# .METHOD error
# エラーレベルのログを書き込みます

# .EXAMPLE
# $logger = New-Object Logger($MyInvocation)
# $logger.info("これは情報レベルのログメッセージです。")
# $logger.error("これはエラーレベルのログメッセージです。")
# #>

class Logger {
  # プロパティ（必須）
  # ログエンコーディング
  [string] $encoding = "Default"
  # 出力レイアウト
  [string] $outputLayout = "%d %s %p %m"
  # 日付フォーマット
  [string] $datetimeFormat = "yyyy/MM/dd HH:mm:ss.fff"
  # ログ出力先フォルダ
  [string] $logFolder
  # ログファイル名
  [string] $logFilename

  # プロパティ(オプション)
  # デフォルト出力元名
  [string] $sourceName
  # ログ作成日時
  [string] $logCreatedDatetime

  # コンストラクタ
  Logger () {
    # デフォルトは呼び出し元のPowershellファイル名
    $this.sourceName = (Split-Path -Leaf $PSCommandPath).replace(".ps1", "")
    # ロガー作成日時の初期化（フォーマットは、コンストラクタの日付フォーマット）
    $this.logCreatedDatetime = Get-Date -Format $this.datetimeFormat
    # ログ出力先フォルダ名
    $this.logFolder = (Split-Path -Parent $PSCommandPath)
    # ログファイル名
    $this.logFilename = (Split-Path -Leaf $PSCommandPath).replace(".ps1", ".log")
  }

  # デバッグログを出力するメソッド
  [void] debug([string]$message) {
    Write-Debug  "called debug: $message"
    $this.writeLog($message, "DEBUG")
  }

  # 情報ログを出力するメソッド
  [void] info([string]$message) {
    Write-Debug  "called info: $message"
    $this.writeLog($message, "INFO")
  }

  # 警告ログを出力するメソッド
  [void] warn([string]$message) {
    Write-Debug  "called warn: $message"
    $this.writeLog($message, "WARN")
  }

  # エラーログを出力するメソッド
  [void] error([string]$message) {
    Write-Debug  "called error: $message"
    $this.writeLog($message, "ERROR")
  }

  # ログレベル毎のログメッセージを出力するメソッド
  hidden [void] writeLog($message, $logLevel) {
    Write-Debug  "writeLog: $logLevel $message"

    # レイアウトに従い、ログメッセージを生成
    $replacedLayout = $this.outputLayout
    $replacedLayout = $replacedLayout.replace("%d", (Get-Date -Format $this.datetimeFormat))
    $replacedLayout = $replacedLayout.replace("%s", $this.sourceName)
    $replacedLayout = $replacedLayout.replace("%p", $logLevel)
    $replacedLayout = $replacedLayout.replace("%m", $message)

    # ログファイルへの書き込み
    Write-Output $replacedLayout |
      Out-File -FilePath (Join-Path $this.logFolder $this.logFilename) -Append -Encoding $this.encoding
  }
}

# モジュール読み込み出力
$moduleName = (Split-Path -Path $PSCommandPath -Leaf) 
Write-Debug "[$moduleName] loaded."

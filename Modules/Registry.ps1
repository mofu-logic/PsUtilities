#------------------------------------------------------------------------------
# レジストリ操作ユーティリティ関数
#------------------------------------------------------------------------------
function Get-RegistryValue {
  # パラメータ定義
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory, ValueFromPipeline, HelpMessage = "取得するレジストリキーのパスを指定します")][string]$RegKeyPath,
    [Parameter(Mandatory, ValueFromPipeline, HelpMessage = "取得するレジストリのエントリ名を指定します")][string]$RegEntry
  )
  try {
    # 返却値テーブルを初期化
    $retHash = @{
      Value   = ""
      IsExist = $false
    }

    # デバッグ情報の出力
    Write-Debug "-- Get-RegistryValue 入力パラメータ --"
    Write-Debug ("RegKeyPath: " + $RegKeyPath)
    Write-Debug ("RegEntry: " + $RegEntry)

    # レジストリキーが存在しない場合は初期化したハッシュテーブルを返却する
    if ((Test-Path -Path $regKeyPath ) -eq $false) {
      Write-Debug ("レジストリキー" + (Join-Path -Path $regKeyPath $regEntry) + "は存在しない")
      return $retHash
    }

    # レジストリエントリが存在する場合は値を取得し、返却値テーブルに格納する
    try {
      $value = Get-ItemProperty -Path $RegKeyPath -Name $RegEntry -ErrorAction Stop
      $retHash.Value = $value.$RegEntry
      $retHash.IsExist = $true
      Write-Debug ("レジストリエントリ" + $regEntry + "の取得値" + ($value.$RegEntry))
    }
    catch [System.Management.Automation.PSArgumentException] {
      $retHash.Value = $null
      Write-Debug ("レジストリエントリ" + $regEntry + "は存在しない")
    }
    catch [System.Exception]
    {
      Write-Debug ("レジストリエントリ" + $regEntry + "の取得に失敗しました")
      throw $_.Exception.Message
    }

    # 返却値テーブルを返却する
    return $retHash
  }
  catch [System.Exception] {
    throw $_.Exception.Message
  }
}

function New-RegKeyPath {
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory, HelpMessage = "作成するレジストリキーのパスを指定します")]
    [string]$Path
  )

  # デバッグ情報の出力
  Write-Debug "-- New-RegKeyPath 入力パラメータ --"
  Write-Debug ("Path: " + $Path)

  # レジストリキーが存在する場合は処理を終了する
  if ( (Test-Path -Path $Path) -eq $true) {
    Write-Debug ("レジストリキー:" + $Path + "は既に存在します")
    return
  } 

  # 親キーの存在確認結果で処理を分岐する
  $parentPath = Split-Path -Path $Path -Parent
  Write-Debug ("親キーのパス:" + $parentPath)
  if (Test-Path -Path $parentPath) {
    New-Item -Path $Path -Force
    Write-Debug ("レジストリキー:" + $Path + "を作成しました")
  }
  else {
    Write-Debug ("レジストリキー:" + $parentPath + "が存在しないため作成します")
    New-RegKeyPath -Path $parentPath
    New-Item -Path $Path -Force
    Write-Debug ("レジストリキー:" + $Path + "を作成しました")
  }
}

function Set-RegistryEntry {
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory, HelpMessage = "設定するレジストリキーのパスを指定します")][string]$RegKeyPath,
    [Parameter(Mandatory, HelpMessage = "設定するレジストリのエントリ名を指定します")][string]$RegEntry,
    [Parameter(Mandatory, HelpMessage = "設定するレジストリ値")][string]$Value,
    [Parameter(Mandatory = $false, HelpMessage = "設定するレジストリキーの値のタイプを指定します")]
    [ValidateSet('String', 'ExpandString', 'Binary', 'DWord', 'MultiString', 'Qword', 'Unknown')][string]$RegType
  )
  Process {
    # 返却値テーブルを初期化
    $retHash = @{
      isSuccess = $false
    }

    # デバッグ情報の出力
    Write-Debug "-- Set-RegistryEntry 入力パラメータ --"
    Write-Debug ("RegKeyPath: " + $RegKeyPath)
    Write-Debug ("RegEntry: " + $RegEntry)
    Write-Debug ("Type: " + $RegType)
    Write-Debug ("Value: " + $Value)

    # レジストリキーが存在しない場合は作成する
    if ((Test-Path -Path $regKeyPath ) -eq $false) {
      Write-Debug ("レジストリキー" + $RegKeyPath + "は存在しないので作成する")
      New-RegKeyPath -Path $RegKeyPath
    }

    # レジストリエントリの作成
    try {
      New-ItemProperty -Path $RegKeyPath -Name $RegEntry -Value $Value -PropertyType $Type -Force
      Write-Debug ("レジストリエントリ" + (Join-Path -Path $RegKeyPath $RegEntry) + "を作成しました")
      # 処理結果を成功に変更する
      $retHash.isSuccess = $true
    }
    catch [System.Exception] {
      Write-Debug ("レジストリエントリ" + (Join-Path -Path $RegKeyPath $RegEntry) + "の作成に失敗しました")
      throw $_.Exception.Message
    }
  
    # 取得結果はハッシュテーブルに格納する
    return $retHash
  }
}

function Remove-RegistryEntry {
  param (
    [Parameter(Mandatory, ValueFromPipeline, HelpMessage = "削除するレジストリキーのパスを指定します")]
    [string]$regKeyPath,
    [Parameter(Mandatory, HelpMessage = "削除するレジストリのエントリ名を指定します")]
    [string]$RegEntry
  )
  # 返却値テーブルを初期化
  $retHash = @{
    isSuccess = $false
  }

  # デバッグ情報の出力
  Write-Debug "-- Remove-RegistryEntry 入力パラメータ --"
  Write-Debug ("RegKeyPath: " + $RegKeyPath)

  # レジストリキーが存在しない場合は初期化したハッシュテーブルを返却する
  if ((Test-Path -Path $regKeyPath ) -eq $false) {
    Write-Debug ("レジストリキー" + $regKeyPath + "は存在しない")
    return $retHash
  }

  try {
    # レジストリエントリを削除する
    Remove-ItemProperty -Path $regKeyPath -Name $RegEntry -ErrorAction Stop
    Write-Debug ("レジストリエントリ" + (Join-Path -Path $regKeyPath $regEntry) + "を削除しました")
    $retHash.isSuccess = $true
  }
  catch [System.Management.Automation.PSArgumentException] {
    Write-Debug ("レジストリエントリ" + (Join-Path -Path $regKeyPath $regEntry) + "は存在しない")
  }
  catch [System.Exception]{
    Write-Debug ("レジストリエントリ" + (Join-Path -Path $regKeyPath $regEntry) + "の削除に失敗しました")
    throw $_.Exception.Message
  }

  return $retHash
}

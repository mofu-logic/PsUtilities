
#----------------------------------------------
# Pesterのコンフィグ設定オブジェクトを返却する
# IN : なし
# OUT: PesterConfiguration
#----------------------------------------------
function New-PesterConfigurationObject() {
  # Pesterのコンフィグ設定オブジェクトを作成する
  $PesterConfig = New-PesterConfiguration

  # 以下オブジェクト設定
  # 各項目の詳細は以下を参照のこと
  # https://pester.dev/docs/commands/New-PesterConfiguration

  #------------------------------------------------------------------------------
  # Pesterのテスト設定オブジェクトの作成
  #------------------------------------------------------------------------------
  $PesterConfig = New-pesterConfiguration

  #------------------------------------------------------------------------------
  # テスト用オブジェクトに値を設定する
  #------------------------------------------------------------------------------
  # Run:
  #------------------------------------------------------------------------------
  #  Path:
  #    テストを検索するディレクトリ、テスト ファイルへの直接パス、または両方の組み合わせ。
  #  Default value: @('.')
  $PesterConfig.Run.Path = @('.')

  #  ExcludePath:
  #    実行から除外するディレクトリまたはファイル。
  #  Default value: @()
  $PesterConfig.Run.ExcludePath = @('.')

  #  ScriptBlock:
  #    実行するテストを含む ScriptBlock。
  #  Default value: @()
  $PesterConfig.Run.ScriptBlock = @()

  #  Container:
  #    実行するテストを含む ContainerInfo オブジェクト。
  #  Default value: @()
  $PesterConfig.Run.Container = @()

  #  TestExtension:
  #    テストファイルの識別に使用されるフィルター。
  #  Default value: '.Tests.ps1'
  $PesterConfig.Run.TestExtension = '.Tests.ps1'

  #  Exit:
  #    テストの実行が失敗した場合、ゼロ以外の終了コードで終了する。
  #    Throw と一緒に使用する場合は、例外のスローが優先される。
  #  Default value: $false
  $PesterConfig.Run.Exit = $false

  #  Throw:
  #    テストの実行が失敗したときに例外をスローする。
  #    Exit と一緒に使用する場合は、例外をスローすることが推奨される。
  #  Default value: $false
  $PesterConfig.Run.Throw = $false

  #  PassThru:
  #    テストの実行が終了したら、結果オブジェクトをパイプラインに返す。
  #  Default value: $false
  $PesterConfig.Run.PassThru = $false

  #  SkipRun:
  #    検出フェーズを実行するが、実行をスキップする。
  #    これを PassThru と一緒に使用して、すべてのテストが入力されたオブジェクトを取得する。
  #  Default value: $false
  $PesterConfig.Run.SkipRun = $false

  #  SkipRemainingOnFailure:
  #    選択したスコープの失敗後に残りのテストをスキップする。
  #    オプションは、None, Run, Container および Block となる。
  #  Default value: 'None'
  $PesterConfig.Run.SkipRemainingOnFailure = 'None'

  #------------------------------------------------------------------------------
  # Filter:
  #------------------------------------------------------------------------------
  #  Tag:
  #    テストする Describe、Context、または It のタグ。
  #  Default value: @()
  $PesterConfig.Filter.Tag = @()

  #  ExcludeTag:
  #    テストから除外される Describe、Context、または It のタグ。
  #  Default value: @()
  $PesterConfig.Filter.ExcludeTag = @()

  #  Line:
  #    ファイルとスクリプトブロックの開始行でのフィルター処理。
  #    解析されたテストをプログラムで実行して、展開された名前の問題を回避するのに使用する。
  #    Example: 'C:\tests\file1.Tests.ps1:37'
  #  Default value: @()
  $PesterConfig.Filter.Line = @()

  #  ExcludeLine:
  #    ファイルとスクリプトブロックの開始行で除外する、設定はLineよりも優先される。
  #  Default value: @()
  $PesterConfig.Filter.ExcludeLine = @()

  #  FullName:
  #    "."とワイルドカードで結合した、テストの完全な名前。
  #    - like ワイルドカードをドットで結合したテストの完全な名前。
  #    Example: '*.describe Get-Item.test1'
  #  Default value: @()
  $PesterConfig.Filter.FullName = @()

  #------------------------------------------------------------------------------
  #CodeCoverage:
  #  Enabled:
  #    コードカバレッジの有効化をする。
  #  Default value: $false
  $PesterConfig.CodeCoverage.Enabled = $true

  #  OutputFormat:
  #    コードカバレッジのレポートに使用するフォーマット。
  #    'JaCoCo'、'CoverageGutters'が使用できる。
  #  Default value: 'JaCoCo'
  $PesterConfig.CodeCoverage.OutputFormat = 'JaCoCo'

  #  OutputPath: 
  #    コードカバレッジのレポートが保存される現在のディレクトリからの相対パス。
  #  Default value: 'coverage.xml'
  $PesterConfig.CodeCoverage.OutputPath = '.\Results\Coverage.xml'

  #  OutputEncoding:
  #    コードカバレッジのレポートの文字エンコードを指定する。
  #  Default value: 'UTF8'
  $PesterConfig.CodeCoverage.OutputEncoding = 'UTF8'

  #  Path:
  #  コード カバレッジに使用されるディレクトリまたはファイル。
  #  デフォルトでは、ここでオーバーライドされない限り、一般設定のパスが使用される。
  #  Default value: @()
  $PesterConfig.CodeCoverage.Path = @()

  #  ExcludeTests:
  #    コード カバレッジからテストを除外する。
  #    除外には TestFilter を使用する。
  #  Default value: $true
  $PesterConfig.CodeCoverage.ExcludeTests = $true

  #  RecursePaths:
  #  Path オプションで指定したフォルダを再帰的に対象とするか？
  #  Default value: $true
  $PesterConfig.CodeCoverage.RecursePaths = $true

  #  CoveragePercentTarget:
  #    達成したいコードカバレッジの目標パーセント。デフォルトは 75%
  #  Default value: 75
  $PesterConfig.CodeCoverage.CoveragePercentTarget = 75

  #  UseBreakpoints: (実験的)
  #    false の場合、ブレークポイントを使用する代わりに、
  #    Profiler ベースのトレーサーを使用して CodeCoverage を実行する。
  #  Default value: $true
  $PesterConfig.CodeCoverage.UseBreakpoints = $true

  #  SingleHitBreakpoints:
  #    ヒット時にブレークポイントを削除する。
  #  Default value: $true
  $PesterConfig.CodeCoverage.SingleHitBreakpoints = $true

  #------------------------------------------------------------------------------
  # TestResult:
  #------------------------------------------------------------------------------
  #  Enabled:
  #    テスト結果レポートを有効化する。
  #  Default value: $false
  $PesterConfig.TestResult.Enabled = $true

  #  OutputFormat:
  #    テスト結果レポートのフォーマット。
  #    'NUnitXml'、'NUnit2.5'、'JUnitXml'が使用できる。
  #  Default value: 'NUnitXml'
  $PesterConfig.TestResult.OutputFormat = 'NUnitXml'

  #  OutputPath:
  #    テスト結果レポートが保存される現在のディレクトリからの相対パス。
  #  Default value: 'testResults.xml'
  $PesterConfig.TestResult.OutputPath = '.\Results\TestResults.xml'

  #  OutputEncoding:
  #    レポートの文字エンコードを指定する。
  #  Default value: 'UTF8'
  $PesterConfig.TestResult.OutputEncoding = 'UTF8'

  #  TestSuiteName:
  #    レポートの'test-suite'エレメントに設定する名前を指定する。
  #  Default value: 'Pester'
  $PesterConfig.TestResult.TestSuiteName = 'Pester'

  #------------------------------------------------------------------------------
  # Should:
  #------------------------------------------------------------------------------
  #  ErrorAction: 
  #    エラー時のアクションを制御する。
  #    'Stop' を使用するとエラーをスローし、'Continue' を使用して継続させる。
  #  Default value: 'Stop'
  $PesterConfig.Should.ErrorAction = 'Stop'

  #------------------------------------------------------------------------------
  # Debug:
  #------------------------------------------------------------------------------
  #  ShowFullErrors:
  #    Pester の内部スタックを含む完全なエラーを表示する。このプロパティは非推奨。
  #    true に設定すると、Output.StackTraceVerbosity が「Full」にオーバーライドされる。
  #  Default value: $false
  $PesterConfig.Debug.ShowFullErrors = $false

  #  WriteDebugMessages:
  #    画面にデバッグ メッセージを書き込む。
  #  Default value: $false
  $PesterConfig.Debug.WriteDebugMessages = $false

  #  WriteDebugMessagesFrom: 
  #    特定のソースからデバッグ メッセージを書き込む。
  #    これを機能させるには、WriteDebugMessages を true に設定する必要がある。
  #    ワイルドカードを使用して複数のソースからメッセージを取得したり、* を使用してすべてを取得したりできる。
  #  Default value: @('Discovery', 'Skip', 'Mock', 'CodeCoverage')
  $PesterConfig.Debug.WriteDebugMessagesFrom = @('Discovery', 'Skip', 'Mock', 'CodeCoverage')

  #  ShowNavigationMarkers: 
  #    VSCode で簡単にナビゲーションできるように、すべてのブロックとテストの後にパスを記述する。
  #  Default value: $false
  $PesterConfig.Debug.ShowNavigationMarkers = $false

  #  ReturnRawResultObject: 
  #    フィルタリングされていない結果オブジェクトを返す。これは開発専用。
  #    追加のプロパティをこのオブジェクトに依存しないこと。
  #    非パブリックプロパティは事前の通知なしに名前が変更されるため。
  #  Default value: $false
  $PesterConfig.Debug.ReturnRawResultObject = $false

  #------------------------------------------------------------------------------
  # Output:
  #------------------------------------------------------------------------------
  #  Verbosity:
  #    出力の詳細度。
  #    オプションは、None、Normal、Detailed、Diagnostic となる。
  #  Default value: 'Normal'
  $PesterConfig.Output.Verbosity = 'Normal'

  #  StackTraceVerbosity:
  #    スタックトレース出力の詳細度。
  #    オプションは、None、FirstLine、Filtered、および Full となる。
  #  Default value: 'Filtered'
  $PesterConfig.Output.StackTraceVerbosity = 'Filtered'

  #  CIFormat:
  #    ビルドログのエラー出力の CI 形式。
  #    オプションは None、Auto、AzureDevops、および GithubActions となる。
  #  Default value: 'Auto'
  $PesterConfig.Output.CIFormat = 'Auto'

  #  RenderMode:
  #    コンソール出力のレンダリングに使用されるモード。
  #    オプションは、Auto、Ansi、ConsoleColor、および Plaintext となる。
  #  Default value: 'Auto'
  $PesterConfig.Output.RenderMode = 'Auto'

  #------------------------------------------------------------------------------
  # TestDrive:
  #------------------------------------------------------------------------------
  #  Enabled:
  #    TestDrive を有効化する。
  #  Default value: $true
  $PesterConfig.TestDrive.Enabled = $true

  #------------------------------------------------------------------------------
  # TestRegistry:
  #------------------------------------------------------------------------------
  #  Enabled:
  #    TestRegistry を有効化する。
  #  Default value: $true
  $PesterConfig.TestRegistry.Enabled = $true

  # Pesterのコンフィグ設定オブジェクトを返却
  return $PesterConfig
}

#------------------------------------------------------------------------------
# Pesterのテスト実行
#------------------------------------------------------------------------------
# テスト用フラグを有効にする
$global:isTest = $true

# Pesterのコンフィグ設定オブジェクトを取得
$PesterConfig = New-PesterConfigurationObject

# コンフィグ設定でInvoke-Pesterを直接実行
Invoke-Pester -Configuration $PesterConfig

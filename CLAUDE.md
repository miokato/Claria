# CLAUDE.md
プロジェクトの概要についてはREADME.mdを読んでください。

YOU MUST: MusicGirl.xcodeprojディレクトリ以下のファイルは編集しないでください

## ディレクトリ構成
- MusicGirl/Errors/ # エラー関連の処理
- MusicGirl/Extensions/ # Swift拡張機能
- MusicGirl/Models/ # データモデル (サーバーと通信する時はCodableに準拠した構造体、ローカルで保持する時は@Modelマクロを付与したクラス)
- MusicGirl/Protocols/ # プロトコル定義
- MusicGirl/Resources/ # リソースファイル（アニメーション、音源など）
- MusicGirl/Services/ # ビジネスロジック・サービス層
- MusicGirl/Stores/ # 状態を持つ処理 (MainActor、Observableマクロを付与したクラス)
- MusicGirl/Supports/ # ユーティリティ（定数、ログなど）
- MusicGirl/ViewComponents/ # 再利用可能なUIコンポーネント
- MusicGirl/ViewModifiers/ # Viewのモディファイヤ
- MusicGirl/Views/ # 画面・ビュー
- MusicGirl/Localizable.xcstrings # ローカライズの定義 (英語、日本語)
- MusicGirlTests/ # テストディレクトリ
- Assets.xcassets # 画像、色などの定義ファイル

## デザインガイドライン
- Appleの[ヒューマンインターフェースガイドライン](https://developer.apple.com/jp/design/human-interface-guidelines "HumanInterfaceGuildeline")に準拠する
- UIはAppleが用意した基本のコンポーネントを利用
- システムフォントを利用し、`.title`や`.body`のようなシステムに応じて可変となる指定を行う

## アーキテクチャ

### 基本構成
- SwiftUI + Observation: `@Observable`マクロによる状態管理
- レイヤー分離: Views → Stores -> Services → Models
- Environmentを利用してDIを行う: `@Environment(\.appStore) var appStore: AppStore`
- ローカルにデータを保持する時は `SwiftData`、 `UserDefaults`を利用

### 並行処理
- `Swift Concurrency（async/await）`を利用
- Actor によるスレッドセーフなデータ管理
- `@MainActor`でUI更新を保証

## 実装指針
- ビジネスロジック、サービス層の処理はユニットテストを書く
- 1つのメソッドは1つの関心がある処理を行う
- 副作用はなるべく抑える
- 1つのファイルは300行程度に収める

## テスト
- UnitTestは `Swift Testing`を利用
- テストは `xcodebuild test`コマンドを利用
- テストで利用するシュミレータは `iPhone 16 Pro,OS=18.5`を利用

## コーディング規約

Appleの[API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)に準拠する

Viewの構造体は以下の順番でコードを記述
```SomeView.swift
struct SomeView: View {
    // MARK: - public properties
    var prop: Int = 0
    
    // MARK: - private properties
    private var prop2: Int = 0
    
    // MARK: - public methods
    func someMethod() {}
    
    // MARK: - private methods
    private func someMethod2() {}
    
    // MARK: - body
    var body: some View {}
    // MARK: - view builders
    
    @ViewBuilder priavte var someView: some View {}
    // MARK: - Preview
    
    # Preview {}
}
```

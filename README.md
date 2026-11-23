# GitHubSearchRxSwift

同じ GitHub 検索仕様を **UIKit + RxSwift**、**UIKit + Combine**、**SwiftUI + Observation** で書き分けた、アーキテクチャ比較・検証用のサンプルです。  
- UIKit + Combine 版: [GitHubSearchUIKit](https://github.com/mickey-wt-pkmn/GitHubSearchUIKit)  
- SwiftUI + Observation 版: [GitHubSearchSwiftUI](https://github.com/mickey-wt-pkmn/GitHubSearchSwiftUI)

画面のイベント制御から API 通信の受け渡しまで RxSwift / RxCocoa(Signal / Driver / Single)で実装しています。
実務で一般的な Input / Output パターンで構成しました。

## 動作
検索欄で文字を入力し、キーボードの検索ボタンで検索します。入力のたびには検索しません。

## 構成
- `SearchViewModel.transform` が `Input`(`Signal`)を `Output`(`Driver`)に変換します
- `Output` は `sections`、`isLoading`、`errorMessage` です
- 通信の async 処理は `Single.create` 内で `Task` として実行し、`flatMapLatest` で直前の検索をキャンセルします
- `SearchViewModelTests` では Swift Testing(`@Test` / `#expect`)を用いて空文字・成功・失敗のテストを実装しています
- GitHub の未認証 Search API には回数制限(1分あたり10回)があります

## 動作環境
- Xcode 27.2 / iOS 27.2
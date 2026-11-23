//
//  SearchViewModelTests.swift
//  GitHubSearchRxSwift
//
//  Created by mickey-wp on 2026/11/24
//  
//

import Foundation
import Testing
import RxSwift
import RxCocoa
@testable import GitHubSearchRxSwift

@MainActor
struct SearchViewModelTests {
    
    @Test("空文字や空白のみのときは検索を実行しない", arguments: ["", "   ", "\n"])
    func blankQueryDoesNotSearch(query: String) {
        let disposeBag = DisposeBag()
        let service = StubSearchRepositoryService()
        let queryRelay = PublishRelay<String>()
        let output = SearchViewModel(searchRepositoryService: service)
            .transform(input: .init(searchQuery: queryRelay.asSignal()))
        
        var isEmitted = false
        output.sections
            .drive(onNext: { _ in
                isEmitted = true
            })
            .disposed(by: disposeBag)
        
        queryRelay.accept(query)
        
        #expect(!isEmitted)
        #expect(service.callCount == 0)
    }
    
    @Test("検索成功時にセクション一覧が更新される")
    func successUpdatesSections() {
        let disposeBag = DisposeBag()
        let service = StubSearchRepositoryService()
        service.result = .success(SearchRepositoryResponse(items: [sampleRepository]))
        let queryRelay = PublishRelay<String>()
        let output = SearchViewModel(searchRepositoryService: service)
            .transform(input: .init(searchQuery: queryRelay.asSignal()))
        
        var titles: [String] = []
        output.sections
            .drive(onNext: { sections in
                let received = sections.flatMap(\.items).map(\.detail.title)
                guard !received.isEmpty else { return }
                titles = received
            })
            .disposed(by: disposeBag)
        
        queryRelay.accept("swift")
        
        #expect(service.callCount == 1)
        #expect(titles == ["swift"])
    }
    
    @Test("検索失敗時にエラーメッセージが更新される")
    func failureUpdatesErrorMessage() {
        let disposeBag = DisposeBag()
        let service = StubSearchRepositoryService()
        service.result = .failure(.responseError)
        let queryRelay = PublishRelay<String>()
        let output = SearchViewModel(searchRepositoryService: service)
            .transform(input: .init(searchQuery: queryRelay.asSignal()))
        
        var message: String?
        output.errorMessage
            .drive(onNext: { received in
                guard let received else { return }
                message = received
            })
            .disposed(by: disposeBag)
        
        queryRelay.accept("swift")
        
        #expect(service.callCount == 1)
        #expect(message == "レスポンスエラー")
    }
}

// MARK: SampleRepository & StubService

private let sampleRepository = Repository(
    id: 1,
    name: "swift",
    description: "desc",
    stargazersCount: 10,
    language: "Swift",
    htmlUrl: "https://github.com/apple/swift",
    owner: Owner(id: 11, avatarUrl: "https://avatars.githubusercontent.com/u/9919?v=4")
)

private final class StubSearchRepositoryService: SearchRepositoryServiceContract {
    var result: Result<SearchRepositoryResponse, APIServiceError> = .failure(.responseError)
    private(set) var callCount = 0
    
    func searchRepository(query: String) -> Single<SearchRepositoryResponse> {
        callCount += 1
        switch result {
        case .success(let response):
            return .just(response)
        case .failure(let error):
            return .error(error)
        }
    }
}

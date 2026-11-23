//
//  ViewModel.swift
//  GitHubSearchRxSwift
//
//  Created by mickey-wp on 2026/11/24
//
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    
    private enum SearchState: Equatable {
        case loading
        case success([ContentsTableSectionModel])
        case failure(String)
    }
    
    private let searchRepositoryService: SearchRepositoryServiceContract
    
    init(searchRepositoryService: SearchRepositoryServiceContract = SearchRepositoryService()) {
        self.searchRepositoryService = searchRepositoryService
    }
    
    func transform(input: Input) -> Output {
        
        let state = input.searchQuery
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .flatMapLatest { query in
                self.search(query: query)
            }

        let sections = state
            .map { state -> [ContentsTableSectionModel] in
                if case .success(let sections) = state { return sections }
                return []
            }
        
        let isLoading = state
            .map { $0 == SearchState.loading }
            .distinctUntilChanged()
        
        let errorMessage = state
            .map { state -> String? in
                if case .failure(let message) = state { return message }
                return nil
            }
        
        return Output(
            sections: sections,
            isLoading: isLoading,
            errorMessage: errorMessage
        )
    }
    
    private func search(query: String) -> Driver<SearchState> {
        searchRepositoryService.searchRepository(query: query)
            .map(makeState)
            .catch {
                .just(.failure($0.localizedDescription))
            }
            .asObservable()
            .startWith(.loading)
            .asDriver(onErrorDriveWith: .empty())
    }
    
    private func makeState(response: SearchRepositoryResponse) -> SearchState {
        let items = response.items.compactMap { repo -> ContentsCellViewModel? in
            guard let url = URL(string: repo.owner.avatarUrl) else {
                return nil
            }
            let detail = ContentsDetail(
                iconImageUrl: url,
                title: repo.name,
                language: repo.language,
                star: repo.stargazersCount,
                description: repo.description,
                url: repo.htmlUrl
            )
            return ContentsCellViewModel(detail: detail)
        }
        let sections = ContentsTableSectionModel.makeSectionModels(.init(items: items))
        return .success(sections)
    }
}

extension SearchViewModel {
    struct Input {
        let searchQuery: Signal<String>
    }
    
    struct Output {
        let sections: Driver<[ContentsTableSectionModel]>
        let isLoading: Driver<Bool>
        let errorMessage: Driver<String?>
    }
}

//
//  SearchRepositoryService.swift
//  GitHubSearchRxSwift
//  
//  Created by mickey-wp on 2026/11/24
//  
//

import RxSwift

final class SearchRepositoryService: SearchRepositoryServiceContract {
    
    private let apiService: APIServiceContract
    
    init() {
        self.apiService = APIService()
    }
    
    func searchRepository(query: String) -> Single<SearchRepositoryResponse> {
        let request = SearchRepositoryRequest(query: query)
        return apiService.request(with: request)
    }
}

//
//  SearchRepositoryServiceContract.swift
//  GitHubSearchRxSwift
//  
//  Created by mickey-wp on 2026/11/24
//  
//

import RxSwift

protocol SearchRepositoryServiceContract {
    /// 検索(RxSwift)
    func searchRepository(query: String) -> Single<SearchRepositoryResponse>
}

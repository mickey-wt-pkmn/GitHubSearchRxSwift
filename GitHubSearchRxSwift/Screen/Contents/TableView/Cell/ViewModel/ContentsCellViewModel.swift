//
//  ContentsCellViewModel.swift
//  GitHubSearchRxSwift
//  
//  Created by mickey-wp on 2026/11/24
//  
//

struct ContentsCellViewModel: Hashable {
    let detail: ContentsDetail
    
    init(detail: ContentsDetail) {
        self.detail = detail
    }
}

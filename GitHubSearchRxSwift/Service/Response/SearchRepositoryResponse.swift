//
//  SearchRepositoryResponse.swift
//  GitHubSearchRxSwift
//  
//  Created by mickey-wp on 2026/11/24
//  
//

import Foundation

struct SearchRepositoryResponse: Decodable {
    let items: [Repository]
}

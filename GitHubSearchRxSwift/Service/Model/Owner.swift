//
//  Owner.swift
//  GitHubSearchRxSwift
//  
//  Created by mickey-wp on 2026/11/24
//  
//

import Foundation

struct Owner: Decodable, Hashable, Identifiable {
    let id: Int
    let avatarUrl: String
}

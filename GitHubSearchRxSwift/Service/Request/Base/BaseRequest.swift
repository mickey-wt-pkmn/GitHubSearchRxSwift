//
//  BaseRequest.swift
//  GitHubSearchRxSwift
//  
//  Created by mickey-wp on 2026/11/24
//  
//

import Foundation

protocol BaseRequest: APIRequestType {}

extension BaseRequest {
    
    var baseURLString: String {
        return Environment.shared.baseURL
    }
}

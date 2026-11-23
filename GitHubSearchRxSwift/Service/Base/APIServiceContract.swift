//
//  APIServiceContract.swift
//  GitHubSearchRxSwift
//  
//  Created by mickey-wp on 2026/11/24
//  
//

import RxSwift

protocol APIServiceContract: Sendable {
    /// リクエスト
    func request<Request>(with request: Request) -> Single<Request.Response> where Request: APIRequestType
}

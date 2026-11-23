//
//  APIService.swift
//  GitHubSearchRxSwift
//  
//  Created by mickey-wp on 2026/11/24
//  
//

import Foundation
import RxSwift

final class APIService: APIServiceContract {
    
    func request<Request>(with request: Request) -> Single<Request.Response> where Request : APIRequestType {
        return .create { emitter in
            let task = Task {
                guard var urlComponents = URLComponents(url: request.requestURL, resolvingAgainstBaseURL: true) else {
                    emitter(.failure(APIServiceError.invalidURL))
                    return
                }
                urlComponents.queryItems = request.queryItems
                
                guard let url = urlComponents.url else {
                    emitter(.failure(APIServiceError.invalidURL))
                    return
                }
                
                var urlRequest = URLRequest(url: url)
                urlRequest.addValue(Const.acceptValue, forHTTPHeaderField: Const.acceptHeader)
                urlRequest.addValue(Const.userAgentValue, forHTTPHeaderField: Const.userAgentHeader)
                
                do {
                    let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
                    guard let httpStatus = urlResponse as? HTTPURLResponse else {
                        emitter(.failure(APIServiceError.responseError))
                        return
                    }
                    guard 200 ..< 300 ~= httpStatus.statusCode else {
                        emitter(.failure(APIServiceError.responseError))
                        return
                    }
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    do {
                        let responseData = try decoder.decode(Request.Response.self, from: data)
                        emitter(.success(responseData))
                    } catch {
                        emitter(.failure(APIServiceError.parseError(error)))
                        return
                    }
                } catch {
                    guard !Task.isCancelled else {
                        return
                    }
                    if let error = error as? APIServiceError {
                        emitter(.failure(error))
                    } else {
                        emitter(.failure(APIServiceError.responseError))
                        return
                    }
                }
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

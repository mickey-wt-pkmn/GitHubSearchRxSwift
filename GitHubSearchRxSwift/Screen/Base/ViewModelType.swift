//
//  ViewModelType.swift
//  GitHubSearchRxSwift
//  
//  Created by mickey-wp on 2026/11/24
//  
//

protocol ViewModelType: AnyObject {
    /// ViewController から送られてくるイベント
    associatedtype Input
    /// ViewController で監視するイベント
    associatedtype Output
    
    func transform(input: Input) -> Output
}

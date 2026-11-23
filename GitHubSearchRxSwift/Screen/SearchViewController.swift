//
//  ViewController.swift
//  GitHubSearchRxSwift
//
//  Created by mickey-wp on 2026/11/24
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: BaseViewController<SearchViewModel> {

    /// 検索テキスト 入力
    @IBOutlet private weak var searchTextField: UITextField!
    /// コンテンツテーブルビュー
    @IBOutlet private weak var contentsTableView: UITableView!
    /// ローディング
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    /// エラーメッセージ
    @IBOutlet private weak var errorLabel: UILabel!
    
    private lazy var dataSource: ContentsTableDataSource = {
        ContentsTableDataSource(tableView: contentsTableView)
    }()
    private let searchQueryRelay = PublishRelay<String>()
    
    override func viewDidLoad() {
        viewModel = SearchViewModel()
        setupSearchTextField()
        setupTableView()
        super.viewDidLoad()
    }
    
    private func setupSearchTextField() {
        searchTextField.borderStyle = .roundedRect
        searchTextField.returnKeyType = .search
        searchTextField.placeholder = "検索キーワードを入力"
        searchTextField.delegate = self
    }
    
    private func setupTableView() {
        contentsTableView.register(ContentsTableViewCell.self)
        contentsTableView.separatorStyle = .none
    }
    
    override func bindViewModel() {
        let input = SearchViewModel.Input(
            searchQuery: searchQueryRelay.asSignal()
        )
        let output = viewModel.transform(input: input)
        
        output.sections
            .drive(onNext: { [weak self] sections in
                self?.dataSource.applySections(sections, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(onNext: { [weak self] isLoading in
                isLoading
                ? self?.indicator.startAnimating()
                : self?.indicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(onNext: { [weak self] message in
                self?.errorLabel.text = message
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchQueryRelay.accept(textField.text ?? "")
        textField.resignFirstResponder()
        return true
    }
}

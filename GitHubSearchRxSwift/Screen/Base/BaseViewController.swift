//
//  BaseViewController.swift
//  GitHubSearchRxSwift
//  
//  Created by mickey-wp on 2026/11/24
//  
//

import UIKit
import RxSwift

class BaseViewController<ViewModel: ViewModelType>: UIViewController {
    
    final var viewModel: ViewModel!
    final let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    /// VM とのバインド(継承先で実装)
    func bindViewModel() {}
}

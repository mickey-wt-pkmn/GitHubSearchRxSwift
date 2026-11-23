//
//  BaseTableViewCell.swift
//  GitHubSearchRxSwift
//  
//  Created by mickey-wp on 2026/11/24
//  
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    class var reuseIdentifier: String {
        String(describing: self)
    }
    
    class var nib: UINib {
        UINib(nibName: reuseIdentifier, bundle: nil)
    }
}

//
//  ContentsTableDataSource.swift
//  GitHubSearchRxSwift
//  
//  Created by mickey-wp on 2026/11/24
//  
//

import UIKit

final class ContentsTableDataSource: BaseTableViewDataSource<ContentsTableSectionModel> {
    
    init(tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ContentsTableViewCell.self)
            cell.update(itemIdentifier)
            return cell
        }
    }
    
}

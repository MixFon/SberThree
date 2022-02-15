//
//  NewsTable.swift
//  SberThree
//
//  Created by Михаил Фокин on 11.02.2022.
//

import UIKit
import BaseTableViewKit

class NewsTable: UIView {
    
    struct ViewState {
        
        struct Row: _StandartCell {
            var title      : String
            var descr: String
            var leftImage  : UIImage?
            var url: String?
            var createdAt: String
            var retweetCount: Int
            var favoriteCount: Int
            var commentsCount: Int
            var separator  : Bool
            let onSelect   : () -> ()
            var backgroundColor: UIColor?
        }
        
        struct Header: _TitleHeaderView {
            var title: String
            var style: HeaderTitleStyle
            var backgroundColor: UIColor
            var isInsetGrouped: Bool
        }
        
        struct Footer: _BaseFooterView {
            var text: String
            var attributedText: NSAttributedString?
            var isInsetGrouped: Bool
        }

        struct ErrorCell: _ErrorData {
            var title: String
            var descr: String
            var onRetry: (() -> ())?
            var backgroundColor: UIColor
        }
        
        struct LoadingCell: _Loading {
            var loadingTitle: String?
        }
        
        struct StaticCell: _StaticCell {
            var title: String
            var descr: String
        }
    }
    
    var table: BaseTableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
    }
    
    private func setupTableView() {
        table = BaseTableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(table)
        table.register(UINib(nibName: ErrorCell.identifire, bundle: nil), forCellReuseIdentifier: ErrorCell.identifire)
        table.register(UINib(nibName: LoadintCell.identifire, bundle: nil), forCellReuseIdentifier: LoadintCell.identifire)
        table.register(UINib(nibName: StaticCell.identifire, bundle: nil), forCellReuseIdentifier: StaticCell.identifire)
        table.register(UINib(nibName: StandartCell.identifire, bundle: nil), forCellReuseIdentifier: StandartCell.identifire)

        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: topAnchor),
            table.leadingAnchor.constraint(equalTo: leadingAnchor),
            table.trailingAnchor.constraint(equalTo: trailingAnchor),
            table.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

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
        
        struct Row: _StandartImage {
            var title      : String
            var leftImage  : UIImage?
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
        table = BaseTableView(frame: .infinite, style: .insetGrouped)
        table.sectionHeaderHeight = 44
        table.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(table)

        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: topAnchor),
            table.leadingAnchor.constraint(equalTo: leadingAnchor),
            table.trailingAnchor.constraint(equalTo: trailingAnchor),
            table.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

//
//  ErrorCell.swift
//  SberThree
//
//  Created by Михаил Фокин on 14.02.2022.
//

import UIKit
import BaseTableViewKit

extension _ErrorData {
    
    var backgroundColor: UIColor? { return .clear }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ErrorCell.identifire, for: indexPath) as? ErrorCell else { return .init() }
        cell.configure(with: self)
        return cell
    }
}

class ErrorCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descr: UILabel!
    var onRetry: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = true
    }
    
    @IBAction func pressRetry(_ sender: UIButton) {
        guard let onRetry = onRetry else { return }
        onRetry()
    }
    
    override func prepareForReuse() {
        self.title = nil
        self.descr = nil
        self.onRetry = nil
    }
    
    func configure(with data: _ErrorData, imageColor: UIColor = .black, boldText: Bool = false, textColor: UIColor = .black) {
        self.title.text = data.title
        self.descr.text = data.descr
        self.onRetry = data.onRetry
        if boldText {
            self.title.font = UIFont.systemFont(ofSize: 20)
        }
        if let accesory = data.accesoryType {
            self.accessoryType = accesory
        }
        
        if let bgColor = data.backgroundColor  {
            self.backgroundColor = bgColor
        }
    }
}



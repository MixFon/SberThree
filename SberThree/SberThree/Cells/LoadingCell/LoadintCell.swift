//
//  LoadintCell.swift
//  SberThree
//
//  Created by Михаил Фокин on 14.02.2022.
//

import UIKit
import BaseTableViewKit

extension _Loading  {
    var backgroundColor: UIColor? { return .clear }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadintCell.identifire, for: indexPath) as? LoadintCell else { return .init() }
        cell.configure(with: self)
        return cell
    }
}

class LoadintCell: UITableViewCell {

    @IBOutlet weak var loadingTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = false
    }

    override func prepareForReuse() {
        self.loadingTitle = nil
    }
    
    func configure(with data: _Loading, imageColor: UIColor = .black, boldText: Bool = false, textColor: UIColor = .black) {
        self.loadingTitle.text = data.loadingTitle
        if boldText {
            self.loadingTitle.font = UIFont.systemFont(ofSize: 20)
        }
        if let accesory = data.accesoryType {
            self.accessoryType = accesory
        }
        
        if let bgColor = data.backgroundColor  {
            self.backgroundColor = bgColor
        }
        
    }
}

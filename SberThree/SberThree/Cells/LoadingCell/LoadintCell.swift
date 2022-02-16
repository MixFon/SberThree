//
//  LoadintCell.swift
//  SberThree
//
//  Created by Михаил Фокин on 14.02.2022.
//

import UIKit
import BaseTableViewKit

protocol _LoadintCell: CellData {
    var loadingTitle: String? { get set }
}

extension _LoadintCell  {
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
    
    func configure(with data: _LoadintCell) {
        self.loadingTitle.text = data.loadingTitle
        
        if let accesory = data.accesoryType {
            self.accessoryType = accesory
        }
        
        if let bgColor = data.backgroundColor  {
            self.backgroundColor = bgColor
        }
        
    }
}

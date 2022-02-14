//
//  StaticCell.swift
//  SberThree
//
//  Created by Михаил Фокин on 14.02.2022.
//

import UIKit
import BaseTableViewKit

public protocol _StaticCell: CellData {
    var title : String   { get }
    var descr : String   { get }
}

extension _StaticCell {
    var backgroundColor: UIColor? { return nil }
    
    public func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StaticCell.identifire, for: indexPath) as? StaticCell else { return .init() }
        cell.configure(with: self)
        return cell
    }
}

class StaticCell : UITableViewCell {
    
    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var descr : UILabel!
    @IBOutlet weak private var rightImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = false
        self.rightImage.layer.cornerRadius = self.rightImage.frame.size.width / 2
        self.rightImage.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        self.title.text = nil
        self.title.textColor = nil
        
        self.descr.text = nil
        self.descr.textColor = nil
    }
    
    func configure(with data: _StaticCell, imageColor: UIColor = .black, boldText: Bool = false, textColor: UIColor = .black) {
        self.title.text = data.title
        
        self.descr.text = data.descr
    }
}


//
//  StandartImageCell.swift
//  BaseTableViewKit
//
//  Created by Слава Платонов on 08.02.2022.
//

import UIKit

public protocol _StandartImage: CellData {
    var title     : String   { get }
    var leftImage : UIImage? { get }
    var separator : Bool     { get }
    var backgroundColor: UIColor? { get }
}

extension _StandartImage {
    var backgroundColor: UIColor? { return nil }
    
    public func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StandartImageCell.identifire, for: indexPath) as? StandartImageCell else { return .init() }
        cell.configure(with: self)
        return cell
    }
}

class StandartImageCell : UITableViewCell {
    
    @IBOutlet weak private var title : UILabel!
    @IBOutlet weak private var separator : UIView!
    @IBOutlet weak private var leftImage : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = true
    }
    
    override func prepareForReuse() {
        self.title.text = nil
        self.title.textColor = nil
        self.leftImage.image = nil
        self.leftImage.tintColor = nil
    }
    
    func configure(with data: _StandartImage, imageColor: UIColor = .black, boldText: Bool = false, textColor: UIColor = .black) {
        self.title.text = data.title
        self.leftImage.image = data.leftImage
        self.title.textColor = textColor
        self.separator.isHidden = !data.separator
        self.leftImage.tintColor = imageColor
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

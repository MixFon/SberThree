//
//  StandartCell.swift
//  SberThree
//
//  Created by Михаил Фокин on 15.02.2022.
//

import UIKit
import BaseTableViewKit
import SDWebImage

protocol _StandartCell : _StandartImage {
    var descr: String { get }
    var url: String? { get }
    var createdAt: String { get }
    var retweetCount: Int { get }
    var favoriteCount: Int { get }
    var commentsCount: Int { get }
}

extension _StandartCell {
    
   func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StandartCell.identifire, for: indexPath) as? StandartCell else { return .init() }
        cell.configure(with: self)
        return cell
    }
}

class StandartCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descr: UILabel!
    @IBOutlet weak var bottomImage: UIImageView!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var createAt: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = true
        self.leftImage.layer.cornerRadius = self.leftImage.frame.size.width / 2
        self.leftImage.clipsToBounds = true
        
        self.bottomImage.layer.cornerRadius = 10
    }
    
    func configure(with data: _StandartCell) {
        self.title.text = data.title
        self.descr.text = data.descr
        self.commentsCount.text = String(data.commentsCount)
        self.retweetCount.text = String(data.retweetCount)
        self.favoriteCount.text = String(data.favoriteCount)
        self.createAt.text = data.createdAt
        self.backgroundColor = .clear
        if let url = data.url {
            // Не заню, на соколько хорошей идее было загружать изображение тут.
            self.bottomImage.sd_setImage(with: URL(string: url), completed: { image,_,_,_ in
                if image == nil { self.bottomImage.isHidden = true }
            })
        } else {
            self.bottomImage.isHidden = true
        }
    }
    
}

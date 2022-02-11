//
//  CellData.swift
//  BaseTableViewKit
//
//  Created by Слава Платонов on 08.02.2022.
//

import UIKit

public protocol CellData {
        
    var accesoryType: UITableViewCell.AccessoryType? { get }
    
    var onSelect: () -> () { get }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    
    func cell(for collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}

extension CellData {
    
    public var accesoryType: UITableViewCell.AccessoryType? { return nil }
    
    public var onSelect: () -> () { return {} }
    
    public func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return .init()
    }
    
    public func cell(for collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return .init()
    }
}

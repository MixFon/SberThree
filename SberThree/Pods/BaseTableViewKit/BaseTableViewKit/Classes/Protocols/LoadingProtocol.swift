//
//  LoadingProtocol.swift
//  BaseTableViewKit
//
//  Created by Слава Платонов on 08.02.2022.
//

import Foundation

public protocol _Loading: CellData {
    var loadingTitle: String? { get set }
}

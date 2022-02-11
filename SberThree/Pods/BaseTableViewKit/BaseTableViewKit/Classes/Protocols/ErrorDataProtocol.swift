//
//  ErrorDataProtocol.swift
//  BaseTableViewKit
//
//  Created by Слава Платонов on 08.02.2022.
//

import Foundation

public protocol _ErrorData: CellData {
    var title   : String   { get }
    var descr   : String   { get }
    var onRetry : (()->())? { get }
}

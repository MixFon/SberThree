//
//  Ext+Bundle.swift
//  BaseTableViewKit
//
//  Created by Слава Платонов on 08.02.2022.
//

import Foundation

public extension Bundle {

    static func resourceBundle(for frameworkClass: AnyClass) -> Bundle {
        guard let moduleName = String(reflecting: frameworkClass).components(separatedBy: ".").first else {
            fatalError("Couldn't determine module name from class \(frameworkClass)")
        }

        let frameworkBundle = Bundle(for: frameworkClass)

        guard let resourceBundleURL = frameworkBundle.url(forResource: moduleName, withExtension: "bundle"),
              let resourceBundle = Bundle(url: resourceBundleURL) else {
            fatalError("\(moduleName).bundle not found in \(frameworkBundle)")
        }
        return resourceBundle
    }
}

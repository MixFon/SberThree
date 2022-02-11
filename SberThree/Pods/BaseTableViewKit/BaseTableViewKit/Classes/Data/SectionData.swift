//
//  SectionData.swift
//  BaseTableViewKit
//
//  Created by Слава Платонов on 08.02.2022.
//

import DifferenceKit

public typealias State = ArraySection<SectionState, Element>

public struct Element: ContentEquatable, ContentIdentifiable {
    
    var id: Int = Int.random(in: 0..<1000000)
    
    var content: CellData
    
    public init(content: CellData) {
        self.content = content
    }
    
    public var differenceIdentifier: Int {
        return self.id
    }
    
    public func isContentEqual(to source: Element) -> Bool {
        return self.id == source.id
    }
}

public struct SectionState : Differentiable, Equatable {
    
    public static func == (lhs: SectionState, rhs: SectionState) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int = Int.random(in: 0..<1000000)
    
    var isCollapsed = false
    
    public var differenceIdentifier: Int {
        return id
    }
    
    var header: Any?
    var footer: Any?
    
    public init(id: Int = Int.random(in: 0..<1000000), isCollapsed: Bool = false, header: Any?, footer: Any?) {
        self.id = id
        self.isCollapsed = isCollapsed
        self.footer = footer
        self.header = header
    }
}

public enum HeaderTitleStyle {
    case small
    case medium
    case large
    
    func font() -> UIFont {
        switch self {
        case .small:
            return .Body_13_Bold
        case .medium:
            return .Body_15_Bold
        case .large:
            return .Headline_2
        }
    }
}

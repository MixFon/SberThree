//
//  BaseTableView.swift
//  BaseTableViewKit
//
//  Created by Слава Платонов on 08.02.2022.
//

import DifferenceKit

public typealias MenuData = (tableView: UITableView, indexPath: IndexPath, point: CGPoint, element: Any)
public typealias TableData = (tableView: UITableView, indexPath: IndexPath, element: Any)
public typealias HeaderData = (tableView: UITableView, section: Int)
public typealias CellDisplayData = (tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath, element: Any)
public typealias CellWillDisplayData = (tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath)

public class BaseTableView: UITableView {
    
    struct Error: _ErrorData {
        var title: String
        var descr: String
        var onRetry: (() -> ())?
    }
    
    struct Loading: _Loading {
        var loadingTitle: String? = nil
    }
    
    /// original data source
    private var viewState = [State]()
    public var rowAnimation: UITableView.RowAnimation = .fade
    public var shouldInterrupt = false
    
    /// public data source. Affects original, used only for diff calculattions
    public var viewStateInput: [State] {
        get {
            return viewState
        }
        set {
            let changeset = StagedChangeset(source: viewState, target: newValue)
            reload(using: changeset, with: rowAnimation, interrupt: { [weak self] change in
                guard let self = self else { return true }
                return self.shouldInterrupt }) { newState in
                self.viewState = newState
            }
        }
    }
    
     var onCellForRow: ((TableData) -> UITableViewCell)?
     var onCellSelect: ((TableData) -> ())?
     var onCellEndDisplaying: ((CellDisplayData) -> ())?
     var onHeaderView: ((HeaderData) -> UIView)?
     var onFooterView: ((HeaderData) -> UIView)?
     var onScroll: ((UIScrollView) -> ())?
     var onWillDisplay: ((CellWillDisplayData) -> Void)?
    
    @available(iOS 13.0, *)
     lazy var onMenu: ((MenuData) -> UIContextMenuConfiguration?)? = nil
    
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public func showError(title: String, desc: String, onRetry: (() -> ())?) {
        let errorData = Error(title: title, descr: desc, onRetry: onRetry)
        let section = SectionState(header: nil, footer: nil)
        let sectionState = State(model: section, elements: [Element(content: errorData)])
        self.viewStateInput = [sectionState]
    }
    
    public func showLoading() {
        let loadingData = Loading()
        let section = SectionState(header: nil, footer: nil)
        let sectionState = State(model: section, elements: [Element(content: loadingData)])
        var states = viewStateInput
        states.append(sectionState)
        self.viewStateInput = states
    }
    
    private func setup() {
        delegate = self
        dataSource = self
        register(TitleHeaderView.nib, forHeaderFooterViewReuseIdentifier: TitleHeaderView.identifire)
        register(StandartImageCell.nib, forCellReuseIdentifier: StandartImageCell.identifire)
        register(BaseFooterView.nib, forHeaderFooterViewReuseIdentifier: BaseFooterView.identifire)
    }
}

extension BaseTableView: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewState.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewState[section].model.isCollapsed ? 0 : viewState[section].elements.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = self.viewState[indexPath.section].elements[indexPath.row].content
        return element.cell(for: tableView, indexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        onWillDisplay?((tableView: tableView, cell: cell, indexPath: indexPath))
    }
}

extension BaseTableView: UITableViewDelegate {
    
    @available(iOS 13.0, *)
    public func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let element = self.viewState[safe: indexPath.section]?.elements[safe: indexPath.row]?.content else { return nil }
        return onMenu?((tableView: tableView, indexPath: indexPath, point: point, element: element))
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = self.viewState[section].model.header else { return nil }
        switch header {
        case is _TitleHeaderView:
            guard let data = header as? _TitleHeaderView,
                  let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView.identifire) as? TitleHeaderView else { return .init() }
            headerView.configure(data)
            return headerView
        default:
            guard let headerView = self.onHeaderView?((tableView: tableView, section: section)) else { return nil }
            return headerView
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = self.viewState[section].model.footer else { return nil }
        switch footer {
        case is _BaseFooterView:
            guard let data = footer as? _BaseFooterView,
                  let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: BaseFooterView.identifire) as? BaseFooterView else { return .init() }
            footerView.configure(data)
            return footerView
        default:
            guard let footerView = self.onFooterView?((tableView: tableView, section: section)) else { return nil }
            return footerView
        }
    }
        
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let element = self.viewState[safe: indexPath.section]?.elements[safe: indexPath.row]?.content else { return }
        onCellEndDisplaying?((tableView: tableView, cell: cell, indexPath: indexPath, element: element))
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let element = self.viewState[safe: indexPath.section]?.elements[safe: indexPath.row]?.content else { return }
        element.onSelect()
        deselectRow(at: indexPath, animated: true)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScroll?(scrollView)
    }
}

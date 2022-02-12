//
//  NewsView.swift
//  SberThree
//
//  Created by Михаил Фокин on 11.02.2022.
//

import UIKit
import BaseTableViewKit

class NewsView: UIView {
    
    var tableView: NewsTable!
    //lazy var tableView = view.makeTableView(delegateAndDatasource: self)
    var loadingView: UIActivityIndicatorView!
    var errorLabel: UILabel!
    var reloadButton: UIButton!
    
    var props: Props = .error(description: "Error", onReload: { print("press error") } ) {
    //var props: Props = .loaded(states: []) {
        didSet {
            //self.setNeedsLayout()
            update()
        }
    }
    
    enum Props {
        case loading
        case error(description: String, onReload: () -> ())
        case loaded(states: [State])
    }
    
    func update() {
        //super.viewWillLayoutSubviews()
        switch props {
        case .loading:
            loadingView.startAnimating()
            tableView.isHidden = true
            reloadButton.isHidden = true
            errorLabel.isHidden = true
        case .error(let description, _):
            loadingView.stopAnimating()
            tableView.isHidden = true
            reloadButton.isHidden = false
            errorLabel.isHidden = false
            errorLabel.text = description
        case .loaded(let states):
            loadingView.stopAnimating()
            tableView.isHidden = false
            reloadButton.isHidden = true
            errorLabel.isHidden = true
            tableView.table.viewStateInput = states
            //tableView.table.showError(title: "Error", desc: "дис", onRetry: { print(23) })
            //tableView.table.showLoading()
            //tableView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.loadingView.startAnimating()
        setSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setSubViews()
        //setupTableView()
    }
    
    private func setSubViews() {
        self.loadingView = self.makeActivityIndicatorView()
        self.addSubview(self.loadingView)
        
        self.errorLabel = self.makeLabel()
        self.addSubview(self.errorLabel)
        
        self.reloadButton = makeButton(
            title: "Reload",
            target: self,
            selector: #selector(onReloadButtonDidTap)
        )
        self.addSubview(self.reloadButton)
        
        self.tableView = NewsTable(frame: UIScreen.main.bounds)
        self.addSubview(self.tableView)
        
        //self.props = .error(description: "Hello", onReload: { print("2134") })
    }
    
    @objc func onReloadButtonDidTap() {
        if case .error(_, let action) = props {
            action()
        }
    }
}

extension UIView {
    
    func makeActivityIndicatorView() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        return activityIndicator
    }
    
    func makeButton(title: String, centerXAnchorConstant: CGFloat = 0, target: Any, selector: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: centerXAnchor, constant: centerXAnchorConstant).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50).isActive = true
        button.addTarget(target, action: selector, for: .touchUpInside)
        return button
    }
    
    func makeLabel(centerXAnchorConstant: CGFloat = 0, centerYAnchorConstant: CGFloat = 0, text: String = "") -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 55)
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor, constant: centerXAnchorConstant).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerYAnchorConstant).isActive = true
        return label
       }
}

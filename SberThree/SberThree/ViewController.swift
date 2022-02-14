//
//  ViewController.swift
//  SberThree
//
//  Created by Михаил Фокин on 11.02.2022.
//

import UIKit
import BaseTableViewKit
import DifferenceKit

class ViewController: UIViewController {
    
    //var newsView = NewsView(frame: UIScreen.main.bounds)
    var newsTable = NewsTable(frame: UIScreen.main.bounds)
    
    var loager = Loader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = newsTable
        view.backgroundColor = .white
        newsTable.table.viewStateInput = []
        loager.delegate = self
        let errorState = makeErrorState(
            title: "Ошибка",
            desct: "Описание",
            onRetry: reloadNews,
            backgroundColor: .clear)
        //let loadingState = makeLoadingState(loadingTitle: "Загрузка...")
        //newsTable.table.viewStateInput = [loadingState]
        //newsTable.table.viewStateInput = [errorState]
        //newsTable.table.showLoading()
        //_ = BaseTableView.showLoading(newsTable.table)
        
        let staticCell = makeStaricCell(title: "Mos Mtro", descr: "Diak")
        newsTable.table.viewStateInput = [staticCell]
    }
    
    private func makeErrorState(title: String, desct: String, onRetry: @escaping ()->(), backgroundColor: UIColor) -> State {
        let error = NewsTable.ViewState.ErrorCell(
            title: title,
            descr: desct,
            onRetry: onRetry,
            backgroundColor: backgroundColor)
        let section = SectionState(header: nil, footer: nil)
        let elem = Element(content: error)
        let block = State(model: section, elements: [elem])
        return block
    }
    
    private func makeLoadingState(loadingTitle: String) -> State {
        let loading = NewsTable.ViewState.LoadingCell(loadingTitle: loadingTitle)
        let section = SectionState(header: nil, footer: nil)
        let elem = Element(content: loading)
        let block = State(model: section, elements: [elem])
        return block
    }
    
    private func makeStaricCell(title: String, descr: String) -> State {
        let loading = NewsTable.ViewState.StaticCell(title: title, descr: descr)
        let section = SectionState(header: nil, footer: nil)
        let elem = Element(content: loading)
        let block = State(model: section, elements: [elem])
        return block
    }
    
    func reloadNews() {
        let loadingState = makeLoadingState(loadingTitle: "Загрузка")
        newsTable.table.viewStateInput = [loadingState]
        loager.loadDataNews()
    }
    
    func printTitle(text: String) {
        print(text)
    }
    
    func makeAtributString(favorite: Int?, retweet: Int?) -> NSAttributedString {
        let fullStaring = NSMutableAttributedString(string: "")
        
        let imageAttachmentHeart = NSTextAttachment()
        imageAttachmentHeart.image = UIImage(systemName: "heart")
        
        let imageAttachmentMessage = NSTextAttachment()
        imageAttachmentMessage.image = UIImage(systemName: "message")
        
        
        let imageStringHeart = NSAttributedString(attachment: imageAttachmentHeart)
        let imageStringMessage = NSAttributedString(attachment: imageAttachmentMessage)
        
        fullStaring.append(imageStringHeart)
        fullStaring.append(NSAttributedString(string: "  \(favorite ?? 0)    "))
        
        fullStaring.append(imageStringMessage)
        fullStaring.append(NSAttributedString(string: "  \(retweet ?? 0)    "))
        return fullStaring
    }
}

extension ViewController: LoaderProtocol {
    
    func update(news: News) {
        let header = NewsTable.ViewState.Header(
            title: "Московское метро",
            style: .medium,
            backgroundColor: .clear,
            isInsetGrouped: false)
        
        var blocks: [State] = []
        for data in news.data {
            let row = NewsTable.ViewState.Row (
                title: data.text,
                leftImage: nil,
                separator: true,
                onSelect: { self.printTitle(text: data.text) },
                backgroundColor: nil)
            let atributString = makeAtributString(favorite: data.favoriteCount, retweet: data.retweetCount)
            let footer = NewsTable.ViewState.Footer(
                text: "",
                attributedText: atributString,
                isInsetGrouped: true)
            
            let section = SectionState(header: header, footer: footer)
            
            let element = Element(content: row)
            blocks.append(State(model: section, elements: [element]))
        }
        newsTable.table.viewStateInput = blocks
        //newsView.props = .loaded(states: blocks)
    }
    
    func showError(title: String, message: String) {
        newsTable.table.viewStateInput = []
        //self.newsView.props = .error(description: "Ошибка", onReload: self.loager.loadDataNews )
    }
    
    
}

/*
 private func makeState() {
     // first section
     let firstRowOfFirstSection = NewsTable.ViewState.Row(
         title: "First row of first section",
         leftImage: UIImage(systemName: "bag"),
         separator: true,
         onSelect: {
         print("selected first row of first section")
     },
         backgroundColor: .clear)
     
     let secondRowOfFirstSection = NewsTable.ViewState.Row(
         title: "Second row of first section",
         leftImage: UIImage(systemName: "creditcard"),
         separator: true,
         onSelect: {
             print("selected second row of first section")
         },
         backgroundColor: .clear)
     
     let thirdRowOfFirstSection = NewsTable.ViewState.Row(
         title: "Third row of first section",
         leftImage: UIImage(systemName: "banknote"),
         separator: true,
         onSelect: {
             print("selected third row of first section")
         },
         backgroundColor: .clear)
     
     let firstSectionHeader = NewsTable.ViewState.Header(
         title: "First section",
         style: .small,
         backgroundColor: .clear,
         isInsetGrouped: false)

     let firstSection = SectionState(header: firstSectionHeader, footer: nil)

     let firstSectionElements: [Element] = [firstRowOfFirstSection, secondRowOfFirstSection, thirdRowOfFirstSection].map { Element(content: $0) }
     
     let firstBlock = State(model: firstSection, elements: firstSectionElements)
     newsView.props = .loaded(states: [firstBlock])
 }
 */

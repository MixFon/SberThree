//
//  ViewController.swift
//  SberThree
//
//  Created by Михаил Фокин on 11.02.2022.
//

import UIKit
import BaseTableViewKit

class ViewController: UIViewController {
    
    var newsView = NewsView(frame: UIScreen.main.bounds)
    
    var loager = Loader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = newsView
        view.backgroundColor = .white
        newsView.props = .error(description: "Попробовать снова", onReload: reloadNews)
        loager.delegate = self
        //navigationController?.addChild(self)
    }
    
    func reloadNews() {
        loager.loadDataNews()
    }
}

extension ViewController: LoaderProtocol {
    
    func update(news: News) {
        let header = NewsTable.ViewState.Header(
            title: "Московское метро",
            style: .small,
            backgroundColor: .clear,
            isInsetGrouped: false)
        
        var blocks: [State] = []
        for data in news.data {
            let row = NewsTable.ViewState.Row (
                title: data.text,
                leftImage: UIImage(systemName: "banknote"),
                separator: true,
                onSelect: { print(21) },
                backgroundColor: nil)
            let footer = NewsTable.ViewState.Footer(
                text: "footer",
                attributedText: nil,
                isInsetGrouped: false)
            
            let section = SectionState(header: header, footer: footer)
            
            let element = Element(content: row)
            blocks.append(State(model: section, elements: [element]))
        }
        //let rows = news.data.map({  } )
        //let elements = rows.map( { Element(content: $0) } )
        
        newsView.props = .loaded(states: blocks)
    }
    
    func showError(title: String, message: String) {
        self.newsView.props = .error(description: "Ошибка", onReload: self.loager.loadDataNews )
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

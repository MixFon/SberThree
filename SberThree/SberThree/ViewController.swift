//
//  ViewController.swift
//  SberThree
//
//  Created by Михаил Фокин on 11.02.2022.
//

import UIKit
import BaseTableViewKit
import DifferenceKit
import SafariServices
import SDWebImage

class ViewController: UIViewController {
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
            desct: "Не удалось загрузить данные :(",
            onRetry: reloadNews,
            backgroundColor: .clear)
        newsTable.table.separatorStyle = .none
        newsTable.table.viewStateInput = [errorState]
    }
    
    /// Создание состояния ошибки
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
    
    /// Создание состояния загрузки
    private func makeLoadingState(loadingTitle: String) -> State {
        let loading = NewsTable.ViewState.LoadingCell(loadingTitle: loadingTitle)
        let section = SectionState(header: nil, footer: nil)
        let elem = Element(content: loading)
        let block = State(model: section, elements: [elem])
        return block
    }
    
    /// Создание статической ячейки
    private func makeStaricCell(title: String, descr: String) -> State {
        let loading = NewsTable.ViewState.StaticCell(title: title, descr: descr)
        let section = SectionState(header: nil, footer: nil)
        let elem = Element(content: loading)
        let block = State(model: section, elements: [elem])
        return block
    }
    
    private func makeTopCell() -> State {
        let title = "Московское метро"
        let descr = "Официальный твиттер-аккаунт Московского метрополитена по оперативному информированию работы метро."
        return makeStaricCell(title: title, descr: descr)
    }
    
    /// Ставит состояние загрузки и загружает данные из сети
    func reloadNews() {
        let loadingState = makeLoadingState(loadingTitle: "Загрузка")
        newsTable.table.viewStateInput = [loadingState]
        loager.loadDataNews()
    }
    
    ///  Открывает страничку metrooperativno с указанным id
    private func showTwitterPage(id: UInt64) {
        if let url = URL(string: "https://mobile.twitter.com/metrooperativno/status/\(id)") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        } else {
            let errorState = makeErrorState(
                title: "Ошибка",
                desct: "Не удалось загрузить данные :(",
                onRetry: reloadNews,
                backgroundColor: .clear)
            newsTable.table.viewStateInput = [errorState]
        }
    }
    
    private func makeDate(createAt: Int) -> String {
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "dd MMMM yyyy г."
        return dataFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(createAt / 1000)))
    }
}

extension ViewController: LoaderProtocol {
    
    func update(news: News) {
        var blocks: [State] = [makeTopCell()]
        let rows = news.data.map( { dataNews in
            NewsTable.ViewState.Row (
            title: "Московское метро",
            descr: dataNews.text,
            leftImage: nil,
            //url: dataNews.mediaEntities.first,
            url: "https://static2.bigstockphoto.com/0/3/4/large1500/430934111.jpg",
            createdAt: makeDate(createAt: dataNews.createdAt ?? 0),
            retweetCount: dataNews.retweetCount ?? 0,
            favoriteCount: dataNews.favoriteCount ?? 0,
            commentsCount: dataNews.commentsCount ?? 0,
            separator: true,
            onSelect: { self.showTwitterPage(id: dataNews.id) },
            backgroundColor: nil)
        })
        let elements = rows.map( { Element(content: $0) } )
        let section = SectionState(header: nil, footer: nil)
        let block = State(model: section, elements: elements)
        blocks.append(block)
        newsTable.table.viewStateInput = blocks
    }
    
    /// Вызов состояния ошибки
    func showError(title: String, message: String) {
        let error = makeErrorState(title: title, desct: message, onRetry: reloadNews, backgroundColor: .clear)
        newsTable.table.viewStateInput = [error]
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

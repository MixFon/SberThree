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

class ViewController: UIViewController {
    var newsTable = NewsTable(frame: UIScreen.main.bounds)
    
    var loager = Loader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = newsTable
        view.backgroundColor = .white
        loager.delegate = self
        newsTable.table.separatorStyle = .none
        showErrorState()
        //reloadNews()
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
    
    /// Показывает состояние ошибки
    private func showErrorState() {
        let errorState = makeErrorState(
            title: "Ошибка",
            desct: "Не удалось загрузить данные :(",
            onRetry: reloadNews,
            backgroundColor: .clear)
        newsTable.table.viewStateInput = [errorState]
    }
    
    /// Показ состояния загрузки
    private func showLoadingState() {
        let loading = NewsTable.ViewState.LoadingCell(loadingTitle: "Загрузка")
        let section = SectionState(header: nil, footer: nil)
        let elem = Element(content: loading)
        let block = State(model: section, elements: [elem])
        self.newsTable.table.viewStateInput = [block]
    }
    
    /// Создание статической ячейки
    private func getStaricCell(title: String, descr: String) -> State {
        let loading = NewsTable.ViewState.StaticCell(title: title, descr: descr)
        let section = SectionState(header: nil, footer: nil)
        let elem = Element(content: loading)
        let block = State(model: section, elements: [elem])
        return block
    }
    
    /// Возвращает статическую яцейку, которая должна быть первой
    private func getTopCell() -> State {
        let title = "Московское метро"
        let descr = "Официальный твиттер-аккаунт Московского метрополитена по оперативному информированию работы метро."
        return getStaricCell(title: title, descr: descr)
    }
    
    /// Ставит состояние загрузки и загружает данные из сети
    func reloadNews() {
        showLoadingState()
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
            showErrorState()
        }
    }
    
    /// Создание строки с временем создания твитта
    private func makeDate(createAt: Int) -> String {
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "dd MMMM yyyy г."
        return dataFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(createAt / 1000)))
    }
}

extension ViewController: LoaderProtocol {
    
    func update(news: News) {
        var blocks: [State] = [getTopCell()]
        let rows = news.data.map( { dataNews in
            NewsTable.ViewState.Row (
            title: "Moscow metro",
            descr: dataNews.text,
            leftImage: nil,
            url: dataNews.mediaEntities.first,
            // Ниже url для тестирования загрузки картинки
            //url: "https://static2.bigstockphoto.com/0/3/4/large1500/430934111.jpg",
            createdAt: makeDate(createAt: dataNews.createdAt ?? 0),
            retweetCount: dataNews.retweetCount ?? 0,
            favoriteCount: dataNews.favoriteCount ?? 0,
            commentsCount: dataNews.commentsCount ?? 0,
            separator: false,
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

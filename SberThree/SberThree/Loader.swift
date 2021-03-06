//
//  Loader.swift
//  SberThree
//
//  Created by Михаил Фокин on 11.02.2022.
//

import Foundation
import UIKit

protocol LoaderProtocol: AnyObject {
    func update(news: News)
    func showError(title: String, message: String)
}

struct Loader {
    
    weak var delegate: LoaderProtocol?
    
    var urlString: String {
        return "https://devapp.mosmetro.ru/api/tweets/v1.0/"
    }
    
    /// По заданному url в скачиваем json. Затем в глачном потоке обновляем таблицу.
    func loadDataNews() {
        guard let url = URL(string: self.urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.delegate?.showError(
                        title: "Ошибка",
                        message: error?.localizedDescription ?? "Не удалось загрузить данные :(")
                }
            }
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    break
                default:
                    DispatchQueue.main.async {
                        self.delegate?.showError(
                            title: "Ошибка",
                            message: "Статус: \(response.statusCode)")
                    }
                }
            }
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let news = try decoder.decode(News.self, from: data)
                DispatchQueue.main.async {
                    self.delegate?.update(news: news)
                }
            } catch {
                print("\(error)")
            }
        }.resume()
    }
}

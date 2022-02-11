//
//  NewsModel.swift
//  SberThree
//
//  Created by Михаил Фокин on 11.02.2022.
//
import Foundation

// MARK: - News
struct News: Codable {
    let success: Bool
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let id: Double
    let text: String
    let createdAt, retweetCount, favoriteCount: Int
    //let mediaEntities: [JSONAny]
}

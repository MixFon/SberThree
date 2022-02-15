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
    let id: UInt64
    let text: String
    let createdAt, retweetCount, favoriteCount, commentsCount: Int?
    let mediaEntities: [String]
}

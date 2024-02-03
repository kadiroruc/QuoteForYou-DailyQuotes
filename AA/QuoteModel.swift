//
//  QuoteModel.swift
//  AA
//
//  Created by Abdulkadir Oruç on 3.02.2024.
//

import Foundation

struct QuoteModel: Codable {
    let id, content, author: String
    let tags: [String]
    let authorSlug: String
    let length: Int
    let dateAdded, dateModified: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case content, author, tags, authorSlug, length, dateAdded, dateModified
    }
}

typealias Quote = [QuoteModel]

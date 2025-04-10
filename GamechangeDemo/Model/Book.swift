//
//  Book.swift
//  GamechangeDemo
//
//  Created by Khushboo Motwani on 11/04/25.
//

import Foundation

// Model 

struct BookResponse: Codable {
    let results: [Book]
}

struct Book: Codable, Identifiable {
    let id: Int
    let title: String
    let authors: [Author]
    let formats: [String: String]
    let download_count: Int

    struct Author: Codable {
        let name: String
        let birth_year: Int?
    }
}

//
//  BookViewModel.swift
//  GamechangeDemo
//
//  Created by Khushboo Motwani on 11/04/25.
//

import Foundation

// API + Logic

import Foundation

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var isLoading: Bool = false

    func fetchBooks() {
        guard let url = URL(string: "https://gutendex.com/books") else { return }

        isLoading = true

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            guard let data = data, error == nil else {
                print("API error: \(error?.localizedDescription ?? "Unknown")")
                return
            }

            do {
                let response = try JSONDecoder().decode(BookResponse.self, from: data)
                DispatchQueue.main.async {
                    self.books = response.results
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
}


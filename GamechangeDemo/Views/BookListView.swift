//
//  BookListView.swift
//  GamechangeDemo
//
//  Created by Khushboo Motwani on 11/04/25.
//

import SwiftUI

// List UI

struct BookListView: View {
    @StateObject var viewModel = BookViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.books) { book in
                NavigationLink(destination: BookDetailView(book: book)) {
                    HStack {
                        AsyncImage(url: URL(string: book.formats["image/jpeg"] ?? "")) { image in
                            image.resizable()
                            .aspectRatio(contentMode: .fit) // This keeps the image from stretching

                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 60, height: 90)
                        .cornerRadius(8)

                        VStack(alignment: .leading) {
                            Text(book.title).font(.headline)
                            Text(book.authors.first?.name ?? "Unknown").font(.subheadline)
                            if let year = book.authors.first?.birth_year {
                                Text("Published ~ \(year + 30)") // Estimated
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Books")
        }
        .onAppear {
            viewModel.fetchBooks()
        }
    }
}

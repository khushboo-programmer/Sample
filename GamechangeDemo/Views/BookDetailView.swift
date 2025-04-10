//
//  BookDetailView.swift
//  GamechangeDemo
//
//  Created by Khushboo Motwani on 11/04/25.
//

import SwiftUI

// Detail UI

struct BookDetailView: View {
    let book: Book
    
    @State private var isDownloading = false
    @State private var showDownloadSuccess = false
    
    var body: some View {
        
        ZStack {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: URL(string: book.formats["image/jpeg"] ?? "")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .aspectRatio(contentMode: .fit) // This keeps the image from stretching
                    .frame(height: 200)
                    .cornerRadius(10)
                    
                    Text(book.title)
                        .font(.title)
                        .bold()
                    
                    Text("Author: \(book.authors.first?.name ?? "Unknown")")
                        .font(.subheadline)
                    
                    if let year = book.authors.first?.birth_year {
                        Text("Published ~ \(year + 30)")
                    }
                    
                    Text("Downloads: \(book.download_count)")
                        .font(.subheadline)
                    
                    if let downloadURL = getDownloadURL(from: book.formats) {
                        Button(action: {
                            isDownloading = true
                            downloadBook(from: downloadURL)
                        }) {
                            HStack {
                                Image(systemName: "arrow.down.circle.fill")
                                Text("Download Book")
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                    }
                    Text("Description:")
                        .font(.headline)
                        .padding(.top)
                    
                    Text("No description provided. This is a public domain book from Project Gutenberg.")
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                .padding()
                
                if isDownloading {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView("Downloading...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
                .alert(isPresented: $showDownloadSuccess) {
                    Alert(title: Text("Success"), message: Text("Book downloaded successfully!"), dismissButton: .default(Text("OK")))
                }
            }
            .navigationTitle("Details")
        }
        
        func getDownloadURL(from formats: [String: String]) -> URL? {
            if let urlString = formats["application/epub+zip"] ??
                formats["text/plain; charset=utf-8"] ??
                formats["application/pdf"],
               let url = URL(string: urlString) {
                return url
            }
            return nil
        }
        
        func downloadBook(from url: URL) {
            let task = URLSession.shared.downloadTask(with: url) { location, response, error in
                DispatchQueue.main.async {
                    isDownloading = false
                }
                
                guard let location = location, error == nil else {
                    print("Download error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destinationURL = documentsURL.appendingPathComponent(url.lastPathComponent)
                    
                    try FileManager.default.moveItem(at: location, to: destinationURL)
                    print("File saved to: \(destinationURL)")
                    
                    DispatchQueue.main.async {
                        showDownloadSuccess = true
                    }
                } catch {
                    print("File move error: \(error)")
                }
            }
            task.resume()
        }
    }

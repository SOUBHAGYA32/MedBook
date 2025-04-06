//
//  HomeViewModel.swift
//  MedBook
//
//  Created by Soubhagya on 06/04/25.
//

import Foundation
import Combine
import Alamofire
import CoreData

final class HomeViewModel: ObservableObject {
    @Published var searchBooks: [BookModel] = []
    @Published var originalBooks: [BookModel] = []
    @Published var isLoading = false
    @Published var allBooksFetched = false
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var offset = 0
    private let limit = 10
    
    func resetAndFetchBooks() {
        offset = 0
        allBooksFetched = false
        searchBooks.removeAll()
        originalBooks.removeAll()
    }
    
    func fetchBooks(query: String, completion: ((Bool) -> Void)? = nil) {
        guard !isLoading && !allBooksFetched else {
            completion?(false)
            return
        }
        
        isLoading = true
        
        APIManager.shared.fetchBooks(query: query, limit: limit, offset: offset) { [weak self] result in
            guard let self = self else {
                completion?(false)
                return
            }
            
            self.isLoading = false
            
            switch result {
            case .success(let books):
                if books.isEmpty {
                    self.allBooksFetched = true
                    completion?(false)
                } else {
                    self.searchBooks.append(contentsOf: books)
                    self.originalBooks.append(contentsOf: books)
                    self.offset += self.limit
                    completion?(true)
                }
            case .failure(let error):
                print("Error fetching books:", error.localizedDescription)
                completion?(false)
            }
        }
    }
    
    func sortBooks(by option: Int) {
        switch option {
        case 0:
            searchBooks.sort { ($0.title ?? "") < ($1.title ?? "") }
        case 1:
            searchBooks.sort { ($0.ratings_average ?? 0) > ($1.ratings_average ?? 0) }
        case 2:
            searchBooks.sort { ($0.ratings_count ?? 0) > ($1.ratings_count ?? 0) }
        default:
            break
        }
    }
    
    func appendBooks(_ books: [BookModel]) {
        searchBooks.append(contentsOf: books)
        originalBooks.append(contentsOf: books)
    }
    
    func resetSorting() {
        searchBooks = originalBooks
    }
    
    func bookmark(book: BookModel, userEmail: String) {
        guard !isBookBookmarked(book, userEmail: userEmail) else { return }
        let newBook = BookEntity(context: context)
        newBook.title = book.title
        newBook.key = book.key
        newBook.authorName = book.author_name as NSObject?
        newBook.coverId = Int64(book.cover_i ?? 0)
        newBook.ratingsAverage = Double(book.ratings_average ?? 0)
        newBook.ratingsCount = Int64(book.ratings_count ?? 0)
        newBook.userEmail = userEmail
        
        do {
            try context.save()
        } catch {
            print("Failed to bookmark the book: \(error.localizedDescription)")
        }
    }
    
    func getBookmarkedBooks(for userEmail: String) -> [BookEntity] {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userEmail == %@", userEmail)
        do {
            let bookmarkedBooks = try context.fetch(fetchRequest)
            return bookmarkedBooks
        } catch {
            print("Failed to fetch bookmarks: \(error.localizedDescription)")
            return []
        }
    }
    
    func isBookBookmarked(_ book: BookModel, userEmail: String) -> Bool {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "key == %@ AND userEmail == %@", book.key ?? "", userEmail)
        do {
            return try context.fetch(request).count > 0
        } catch {
            return false
        }
    }
    
    func removeBookmark(book: BookEntity, userEmail: String) {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "key == %@ AND userEmail == %@", book.key ?? "", userEmail)
        do {
            let result = try context.fetch(request)
            for obj in result {
                context.delete(obj)
            }
            try context.save()
        } catch {
            print("Error removing bookmark: \(error)")
        }
    }
    
    
}

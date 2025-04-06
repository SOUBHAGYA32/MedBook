//
//  BookModel.swift
//  MedBook
//
//  Created by Soubhagya on 06/04/25.
//

import Foundation

public struct SearchBookResponse: Codable {
    public var numFound : Int?
    public var start : Int?
    public var q : String?
    public var offset : Int?
    public var docs : [BookModel]?
    
    enum CodingKeys: String, CodingKey {
        case numFound = "numFound"
        case start = "start"
        case q = "q"
        case offset = "offset"
        case docs = "docs"
    }
}

public struct BookModel: Codable {
    public var author_name : [String]?
    public var cover_i : Int?
    public var key : String?
    public var title : String?
    public var ratings_average : Double?
    public var ratings_count : Int?
    
    enum CodingKeys: String, CodingKey {
        case author_name = "author_name"
        case cover_i = "cover_i"
        case key = "key"
        case title = "title"
        case ratings_average = "ratings_average"
        case ratings_count = "ratings_count"
    }
}

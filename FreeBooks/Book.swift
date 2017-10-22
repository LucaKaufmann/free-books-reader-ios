//
//  Book.swift
//  FreeBooks
//
//  Created by Luca Kaufmann on 11/09/2017.
//

import Foundation

class Book {
    var title: String?
    var subtitle: String?
    var identifier: String?
    var link: String?
    var description: String?
    var publishedDate: String?
    var pageCount: Int?
    var averageRating: Double?
    var ratingsCount: Int?
    var thumbnailLink: String?
    var highResThumbnailLink: String?
    var epubDownloadLink: String?
    var pdfDownloadLink: String?
    var readerLink: String?
    
    init(bookDict: [String:AnyObject]) {
        let volumeInfoDict = bookDict["volumeInfo"]
        let accessInfoDict = bookDict["accessInfo"]
        let epubDict = accessInfoDict?["epub"] as? [String:AnyObject]
        let imageLinksDict = volumeInfoDict?["imageLinks"] as? [String:AnyObject]
        
        title = volumeInfoDict?["title"] as? String
        subtitle = volumeInfoDict?["subtitle"] as? String
        identifier = "todo"
        link = bookDict["selfLink"] as? String
        description = volumeInfoDict?["description"] as? String
        publishedDate = volumeInfoDict?["publishedDate"] as? String
        pageCount = volumeInfoDict?["pageCount"] as? Int
        averageRating = volumeInfoDict?["averageRating"] as? Double
        ratingsCount = volumeInfoDict?["ratingsCount"] as? Int
        thumbnailLink = imageLinksDict?["thumbnail"] as? String
        highResThumbnailLink = thumbnailLink //todo
        
        
        let epubAvailable = epubDict?["isAvailable"] as! Bool
        if (epubAvailable) {
            epubDownloadLink = epubDict?["downloadLink"] as? String
        } else {
            epubDownloadLink = "todo" //todo
        }
        
        pdfDownloadLink = "todo" //todo
        
        readerLink = accessInfoDict?["webReaderLink"] as? String
    }
    
    
}

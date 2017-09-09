//
//  BooksApiClient.swift
//  FreeBooks
//
//  Created by Luca Kaufmann on 25/08/2017.
//
//

import Foundation
import Alamofire
import SwiftyJSON

class BooksApiClient {
    
    let freeBooksString = "https://www.googleapis.com/books/v1/volumes?q=filter=free-ebooks"
    
    func fetchFreeBooksList() {
        Alamofire.request(
            URL(string: "https://www.googleapis.com/books/v1/volumes?q=filter=free-ebooks")!,
            method: .get
            )
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    debugPrint(response.result.error as Any)
                    return
                }
                debugPrint(response)
                
        }
    }
    func fetchFreeBooksSwifty() {
        Alamofire.request(freeBooksString).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print("SwiftyJSON books")
                // Use array to create book model
                print(swiftyJsonVar["items"].arrayObject!)
            }
        }
    }
    
    func fetchBooks(completion: (Bool, responseData) -> Void) {
        
    }
    
    func hardProcessingWithString(input: String, completion: (String) -> Void) {
        completion("we finished!")
    }
    
}


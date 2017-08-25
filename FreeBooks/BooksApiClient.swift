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
        Alamofire.request("https://www.googleapis.com/books/v1/volumes?q=filter=free-ebooks").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print("SwiftyJSON books")
                // Use array to create book model
                print(swiftyJsonVar["items"].arrayObject!)
            }
        }
    }
}


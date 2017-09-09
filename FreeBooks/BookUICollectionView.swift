//
//  ViewController.swift
//  FreeBooks
//
//  Created by Luca Kaufmann on 21/08/2017.
//
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class BookCollectionView: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
 
    var collectionView: UICollectionView!
    var books = [[String:AnyObject]]()
    
    var isDataLoading:Bool=false
    var startIndex:Int=0 //pageNo*limit
    var didEndReached:Bool=false
    var totalItems: Int = 0
    let maxResult = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.white
        
        fetchAllFreeEBooks(startIndex: startIndex)
        self.view.addSubview(collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! BookCell
        let imageView = UIImageView()
        
        let bookDict = books[indexPath.row]
        let volumeInfoDict = bookDict["volumeInfo"] as! [String:AnyObject]
        if let imageLinksDict = volumeInfoDict["imageLinks"] as? [String:AnyObject] {
            Alamofire.request(imageLinksDict["thumbnail"] as! String, method: .get).responseImage { response in
                guard let image = response.result.value else {
                    // Handle error
                    return
                }
                imageView.image = image
                cell.backgroundView = imageView
            }
        }
        
        // See if we need to load more books
        let rowsToLoadFromBottom = 5;
        let rowsLoaded = books.count
        if (!self.isDataLoading && (indexPath.row >= (rowsLoaded - rowsToLoadFromBottom))) {
            let totalRows = self.totalItems
            let remainingSpeciesToLoad = totalRows - rowsLoaded;
            if (remainingSpeciesToLoad > 0) {
                isDataLoading = true
                self.startIndex = self.startIndex + self.maxResult
                print("startIndex \(startIndex)")
                fetchAllFreeEBooks(startIndex: self.startIndex)
            }
        }
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchAllFreeEBooks(startIndex: Int) {
        print("fetch startIndex \(startIndex) with limit 40")
        let parameters: Parameters = [
            "maxResults": maxResult,
            "startIndex": startIndex
        ]
        Alamofire.request(
            URL(string: "https://www.googleapis.com/books/v1/volumes?q=filter=free-ebooks")!,
            method: .get,
            parameters: parameters
            )
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    debugPrint(response.result.error as Any)
                    return
                }
                let swiftyJsonVar = JSON(response.result.value!)
                //debugPrint(swiftyJsonVar)
                
                if let resData = swiftyJsonVar["items"].arrayObject {
                    self.books += resData as! [[String:AnyObject]]
                }
                
                if let totalItems = swiftyJsonVar["totalItems"].int {
                    self.totalItems = totalItems
                }
                
                if self.books.count > 0 {
                    self.collectionView.reloadData()
                    print("Books: \(self.books.count)")
                    print("Total Items: \(self.totalItems)")
                }
                
                self.isDataLoading = false
                
        }
    }

    
    func fetchThumbnail(url: String) {
        Alamofire.request(url, method: .get).responseImage { response in
            guard let image = response.result.value else {
                // Handle error
                return
            }
            // Do stuff with your image
        }
    }

}


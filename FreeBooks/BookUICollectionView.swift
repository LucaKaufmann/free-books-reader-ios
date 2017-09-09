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
        
        self.fetchAllFreeEBooks()
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
        let imageLinksDict = volumeInfoDict["imageLinks"] as! [String:AnyObject]
        Alamofire.request(imageLinksDict["thumbnail"] as! String, method: .get).responseImage { response in
            guard let image = response.result.value else {
                // Handle error
                return
            }
            imageView.image = image
            cell.backgroundView = imageView
        }
        cell.backgroundColor = UIColor.orange
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func fetchAllFreeEBooks() {
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
                let swiftyJsonVar = JSON(response.result.value!)
                
                if let resData = swiftyJsonVar["items"].arrayObject {
                    self.books = resData as! [[String:AnyObject]]
                }
                if self.books.count > 0 {
                    self.collectionView.reloadData()
                }
                
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


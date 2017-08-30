//
//  ViewController.swift
//  FreeBooks
//
//  Created by Luca Kaufmann on 21/08/2017.
//
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var books = [[String:AnyObject]]()
    var tableView = UITableView()
    
    //For Pagination
    var isDataLoading:Bool=false
    var pageNo:Int=0
    var startIndex:Int=0 //pageNo*limit
    var didEndReached:Bool=false
    var totalItems: Int = 0
    let maxResult = 40

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        fetchAllFreeEBooks(startIndex: startIndex)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "myIdentifier")
        var volumeInfoDict = books[indexPath.row]
    
        cell.textLabel?.text = volumeInfoDict["volumeInfo"]?["title"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookDict = books[indexPath.row]
        UIApplication.shared.open(URL(string: bookDict["volumeInfo"]?["infoLink"] as! String)!)
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
                    self.tableView.reloadData()
                    print("Books: \(self.books.count)")
                }
                
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
        {
            if (!isDataLoading && books.count <= self.totalItems - 1) {
                print("pageNo \(pageNo)")
                print("total items \(self.totalItems)")
                isDataLoading = true
                self.pageNo=self.pageNo+1
                self.startIndex = self.pageNo * self.maxResult + 1
                print("startIndex \(startIndex)")
                fetchAllFreeEBooks(startIndex: self.startIndex)
                
            }
        }
        
        
    }

}


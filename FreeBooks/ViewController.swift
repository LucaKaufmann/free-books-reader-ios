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

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        fetchAllFreeEBooks()
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
                //debugPrint(swiftyJsonVar)
                
                if let resData = swiftyJsonVar["items"].arrayObject {
                    self.books = resData as! [[String:AnyObject]]
                }
                if self.books.count > 0 {
                    self.tableView.reloadData()
                    print(self.books.count)
                }
                
        }
    }

}


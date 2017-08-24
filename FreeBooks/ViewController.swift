//
//  ViewController.swift
//  FreeBooks
//
//  Created by Luca Kaufmann on 21/08/2017.
//
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var books = ["funny", "boring", "doing"]

    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = UITableView(frame: view.bounds, style: UITableViewStyle.grouped)
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
        let cell = BookItemView(style: UITableViewCellStyle.default, reuseIdentifier: "myIdentifier")
        cell.title?.text = books[indexPath.row]
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
                debugPrint(response)
                
        }
    }

}


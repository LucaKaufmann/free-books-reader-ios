//
//  BookReaderViewController.swift
//  
//
//  Created by Luca Kaufmann on 22/10/2017.
//

import UIKit
import WebKit

class BookReaderViewController: UIViewController {

    let screenSize: CGRect = UIScreen.main.bounds
    let navBarHeight = CGFloat(55.0)
    let statusBarHeight = CGFloat(20.0)
    
    var webView: WKWebView!
    var bookLink: String!
    
    init(bookLink: String) {
        super.init(nibName: nil, bundle: nil)
        self.bookLink = bookLink
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNavigationBar() {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: navBarHeight))
        let navItem = UINavigationItem(title: "")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(done))
        navItem.rightBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    func done() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        webView = WKWebView(frame: CGRect(x: 0, y: navBarHeight, width: screenSize.width, height: screenSize.height-navBarHeight))
        let bookUrl = URL(string: self.bookLink)
        webView.load(URLRequest(url: bookUrl!))
        webView.contentScaleFactor = 1.0
        self.view.addSubview(webView)
        // Do any additional setup after loading the view.webView.loadRequest(NSURLRequest(URL: someURL!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

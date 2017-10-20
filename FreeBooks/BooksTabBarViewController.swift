//
//  BooksTabBarViewController.swift
//  
//
//  Created by Luca Kaufmann on 09/09/2017.
//

import UIKit

class BooksTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableViewController = ViewController()
        tableViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        
        let uiCollectionViewController = BookCollectionView()
        uiCollectionViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 1)

        let viewControllerList = [ tableViewController, uiCollectionViewController ]
        viewControllers = viewControllerList
        // Do any additional setup after loading the view.
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

//
//  FriendsListViewController.swift
//  testTableView
//
//  Created by Weiqi Wei on 15/11/26.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit

class FriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    
    var friendsList:[String] = []
    var incomming_name:String = ""

    var array1:[String: [String]] = ["Weiqi": ["Yebin", "Mingming"]]
    var array2:[String: [String]] = ["Hao": ["Wen", "Shuai"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(incomming_name)
        /*if incomming_name == "Weiqi"{
            friendsList = array1[incomming_name]!
        }
        else if incomming_name == "Hao"{
            friendsList = array2[incomming_name]!
        }*/
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if incomming_name == "Weiqi"{
            friendsList = array1[incomming_name]!
        }
        else if incomming_name == "Hao"{
            friendsList = array2[incomming_name]!
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return friendsList.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = myTableView.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.text = friendsList[indexPath.row]
        return cell!
    }
    
    @IBAction func unwindFromAddView(segue: UIStoryboardSegue){
    
    }
    
}

//
//  ViewController.swift
//  testTableView
//
//  Created by Weiqi Wei on 15/11/26.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    let names:[String] = ["wwq", "hl"]
    var searchResult:[String] = []
    var name_From: String = ""
    var name_To: String = ""
    
    var add_name_from = ""
    var add_name_to = ""
    var AddInfo:[String] = []
    
    var ShowFrinds:[String] = []
    /*let query = PFQuery(className: "FriendsInfo")
    let str: String = mySearchBar.text!
    query.whereKey("name", matchesRegex: "(?i)\(str)")
    
    query.findObjectsInBackgroundWithBlock{
    (objects:[PFObject]?, error: NSError?)-> Void in
    if error == nil{
    print("successfully")
    if let array = objects{
    for item in array{
    print(item)
    let fullName = item.objectForKey("name") as! String
    self.searchResult.append(fullName)
    }
    }
    }
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery(className: "InvitationObject")
        query.whereKey("nameTo", equalTo: add_name_to)
        query.findObjectsInBackgroundWithBlock{
            (objects:[PFObject]?, error: NSError?)-> Void in
            if error == nil{
                print("successfully")
                if let array = objects{
                    for item in array{
                        print(item)
                        let fullName = item.objectForKey("nameFrom") as! String
                        self.AddInfo.append(fullName)
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ShowFrinds.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = myTableView.dequeueReusableCellWithIdentifier("cell") as! FriendsTableViewCell
        cell.nameLabel?.text = ShowFrinds[indexPath.row]
        cell.cellButton.tag = indexPath.row
        cell.cellButton.addTarget(self, action: Selector("SendInvitationAction:"), forControlEvents: .TouchUpInside)
        name_To = ShowFrinds[indexPath.row]
        return cell
    }
    
    @IBAction func SendInvitationAction(sender: UIButton){
        let str: String = "Invitation Sent"
        sender.setTitle(str, forState: .Normal)
        SaveInvitation(name_From, nameTo: name_To)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        mySearchBar.resignFirstResponder()
        
        
        /*let query = PFQuery(className: "TestObject")
        query.whereKey("foo", equalTo: "\(mySearchBar.text)")
        
        query.findObjectsInBackgroundWithBlock{
            (objects:[PFObject]?, error: NSError?)-> Void in
            if error == nil{
                print("successfully")
                if let arrays = objects{
                    for item in objects!{
                        print(item)
                    }
                }
            }
        }*/
        
        let query = PFQuery(className: "FriendsInfo")
        let str: String = mySearchBar.text!
        query.whereKey("name", matchesRegex: "(?i)\(str)")
        
        query.findObjectsInBackgroundWithBlock{
            (objects:[PFObject]?, error: NSError?)-> Void in
            if error == nil{
                print("successfully")
                if let array = objects{
                    for item in array{
                        print(item)
                        let fullName = item.objectForKey("name") as! String
                        self.searchResult.append(fullName)
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.myTableView.reloadData()
                self.mySearchBar.resignFirstResponder()
                
            }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar){
        mySearchBar.resignFirstResponder()
        mySearchBar.text = ""
    }
    /*let FriendObject = PFObject(className: "FriendsInfo")
    let acl = PFACL()
    acl.publicWriteAccess = true
    acl.publicReadAccess = true
    FriendObject.ACL = acl
    
    FriendObject["name"] = "Weiqi Wei"
    FriendObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
    print("Object has been saved.")
    }*/
    
    func SaveInvitation(nameFrom:String, nameTo: String){
        let InvitationObject = PFObject(className: "InvitationObject")
        let acl = PFACL()
        acl.publicReadAccess = true
        acl.publicWriteAccess = true
        
        InvitationObject.ACL = acl
        InvitationObject["nameFrom"] = nameFrom
        InvitationObject["nameTo"] = nameTo
        InvitationObject["hasAdded"] = "0"
        
        InvitationObject.saveInBackgroundWithBlock{
            (success: Bool, error: NSError?) -> Void in
            print("Invitation Object has been saved")
        }
    }
}


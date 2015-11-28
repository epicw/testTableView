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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return searchResult.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = myTableView.dequeueReusableCellWithIdentifier("cell") as! FriendsTableViewCell
        cell.nameLabel?.text = searchResult[indexPath.row]
        cell.cellButton.tag = indexPath.row
        cell.cellButton.addTarget(self, action: Selector("SendInvitationAction:"), forControlEvents: .TouchUpInside)
        name_To = searchResult[indexPath.row]
        return cell
    }
    
    @IBAction func SendInvitationAction(sender: UIButton){
        let str: String = "Invitation Sent"
        sender.setTitle(str, forState: .Normal)
        SaveInvitation(name_From, nameTo: name_To)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        mySearchBar.resignFirstResponder()
        
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
    
    func SaveInvitation(nameFrom: String, nameTo: String){
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


//
//  FriendsListViewController.swift
//  testTableView
//
//  Created by Weiqi Wei on 15/11/26.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit
import Parse

class FriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    
    var friendsList:[String] = []
    var incomming_name:String = ""

    var array1:[String: [String]] = ["Weiqi": ["Yebin", "Mingming"]]
    var array2:[String: [String]] = ["Hao": ["Wen", "Shuai"]]
    
    var confirmArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(incomming_name)
        getInvitationResultOnline()
        //UserInfoManager.getInstance().saveNewFriend("Weiqi Wei", nameTo: "Guoshan Liu")
        friendsList += UserInfoManager.getInstance().getAllFriends(incomming_name)
        //print("friend number: \(friendsList.count)")
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToInvitation"{
            let nextViewController = (segue.destinationViewController as! UINavigationController).topViewController as! ShowInvitationViewController
            nextViewController.add_name_to = incomming_name
        }
    }
    
    @IBAction func unwindFromInvitation(segue: UIStoryboardSegue){
        let source = segue.sourceViewController as! ShowInvitationViewController
        friendsList += source.confirmList
        confirmArray = source.confirmList
        let strArray = source.confirmList
        if source.confirmList.count > 0{
            for item in strArray{
                dispatch_async(dispatch_get_main_queue()){
                    UserInfoManager.getInstance().saveNewFriend(self.incomming_name, nameTo: item)
                    
                }
            }
        }        
        dispatch_async(dispatch_get_main_queue()){
            self.myTableView.reloadData()
        }
    }
    
    func getInvitationResultOnline(){
        let query = PFQuery(className: "InvitationObject")
        query.whereKey("nameFrom", equalTo: incomming_name)
        query.findObjectsInBackgroundWithBlock{
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                print("Successfully")
                if let array = objects{
                    for item in array{
                        let name_to = item.objectForKey("nameTo") as! String
                        let hasAdded = item.objectForKey("hasAdded") as! String
                        let id = item.objectId
                        if hasAdded == "1"{
                            self.friendsList.append(name_to)
                            let obj = PFObject.init(withoutDataWithClassName: "InvitationObject", objectId: id)
                            obj.deleteEventually()
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()){
                self.myTableView.reloadData()
            }
        }
    }
}

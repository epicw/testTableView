//
//  LoginViewController.swift
//  testTableView
//
//  Created by Weiqi Wei on 15/11/26.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passWordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameText.text = "Weiqi Wei"
        // Do any additional setup after loading the view.
        loginButton.addTarget(self, action: Selector("login:"), forControlEvents: .TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: UIButton){
        let friendsView = self.storyboard?.instantiateViewControllerWithIdentifier("friendViewController")
        let navController = UINavigationController(rootViewController: friendsView!)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromFriendsList(segue: UIStoryboardSegue){
    
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
        if(segue.identifier == "segueToFriends"){
            let targetViewController = (segue.destinationViewController as! UINavigationController).topViewController as! FriendsListViewController
            targetViewController.incomming_name = userNameText.text!
        }
    }
}

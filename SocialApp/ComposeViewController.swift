//
//  ComposeViewController.swift
//  SocialApp
//
//  Created by Sean Fulcher on 10/30/16.
//  Copyright © 2016 Sean Fulcher. All rights reserved.
//

import UIKit
import Accounts
import Social


class ComposeViewController: UIViewController, UITextViewDelegate {

    var selectedAccount : ACAccount!
    
    @IBOutlet weak var tweetContent: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var postActivity: UIActivityIndicatorView!
    
    @IBAction func dismissView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func postToTwitter(sender: AnyObject) {
        postContent(self.tweetContent.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tweetContent.delegate = self
        
        // Do any additional setup after loading the view.
    }

    func postContent(post : String){
        postActivity.startAnimating()
        
        if let account = selectedAccount {
            let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/update.json")
            let request = SLRequest(forServiceType: SLServiceTypeTwitter,
                requestMethod: SLRequestMethod.POST,
                URL: requestURL,
                parameters: NSDictionary(object: post, forKey: "status") as [NSObject : AnyObject])
            request.account = account
            
            request.performRequestWithHandler()
            {
                    responseData, urlResponse, error in
                if(urlResponse.statusCode == 200)
                {
                    print("Status Posted")
                    
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.postActivity.stopAnimating()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
        }
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let targetlength : Int = 140
        return textView.text.characters.count <= targetlength
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

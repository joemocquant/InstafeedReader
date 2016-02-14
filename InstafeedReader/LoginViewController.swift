//
//  FeedViewController.swift
//  InstafeedReader
//
//  Created by Joe Mocquant on 2/13/16.
//  Copyright (c) 2015 InstafeedReader. All rights reserved.
//

import UIKit
import InstagramKit

class LoginViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.scrollView.bounces = false

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        InstagramEngine.sharedEngine().logout()
        let authURL = InstagramEngine.sharedEngine().authorizationURL()
        webView.loadRequest(NSURLRequest(URL: authURL))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        do {
            try InstagramEngine.sharedEngine().receivedValidAccessTokenFromURL(request.URL!)
            authenticated()
            
        } catch { //let error {
            
            //print("An error occurred retrieving media:\(error).")
        }
        
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func authenticated() {
        
        let userId = InstagramEngine.sharedEngine().accessToken!.componentsSeparatedByString(".")[0]
        
        InstagramEngine.sharedEngine().getUserDetails(userId, withSuccess: { (user) -> Void in
            
            ItemsCollection.sharedInstance.userId = userId
            ItemsCollection.sharedInstance.instagramUser = user
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.performSegueWithIdentifier("Login", sender: nil)
            
            }) { (error, code) -> Void in
                print("An error occurred retrieving user details:\(error).")
        }
    }
    
    
    // MARK - Navigation

    @IBAction func logout(segue:UIStoryboardSegue) {

        InstagramEngine.sharedEngine().logout()
        let authURL = InstagramEngine.sharedEngine().authorizationURL()
        webView.loadRequest(NSURLRequest(URL: authURL))
    }
    
}

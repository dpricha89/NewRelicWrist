//
//  ViewController.swift
//  nuw
//
//  Created by David Richards on 7/8/16.
//  Copyright © 2016 David Richards. All rights reserved.
//

import UIKit
import WatchConnectivity
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ViewController: UIViewController, WCSessionDelegate{
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var APIKeyInput: UITextField!
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var Spinner: UIActivityIndicatorView!
    
    // setup alert
    // returns an error if the api key is malformed
    let alertController = UIAlertController(title: "Error", message: "API key is not the correct length", preferredStyle: UIAlertControllerStyle.alert)
    


    override func viewDidLoad() {
        super.viewDidLoad()
        Spinner.hidesWhenStopped = true
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        SaveButton.addTarget(self, action: #selector(ViewController.saveTouched), for: .touchUpInside)
        
        // plug the value into the input if its already saved to local storage
        if let key = userDefaults.object(forKey: "NewRelicKey") as? String {
            APIKeyInput.text = key
        }
        
        // setup WCSession so we can communicate with the watch
        if(WCSession.isSupported()) {
            WCSession.default().delegate = self
            WCSession.default().activate()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("session did deactivate")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("foo")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("test")
    }
    
    func saveTouched() {
        print("touch saved")
        self.view.endEditing(true)
        Spinner.startAnimating()
        if (APIKeyInput.text?.characters.count > 5) {
            print("Successfully save the api key \(APIKeyInput.text!)")
            userDefaults.set(APIKeyInput.text!, forKey: "NewRelicKey")
            userDefaults.synchronize()
            // if watch is reachable then send the key
            if(WCSession.default().isReachable) {
                WCSession.default().sendMessage(["NewRelicKey" : APIKeyInput.text!], replyHandler: nil, errorHandler: nil)
                Spinner.stopAnimating()
            // backup if not reachable
            }else if(WCSession.isSupported()) {
                do {
                    try WCSession.default().updateApplicationContext(["msgContents" :APIKeyInput.text!])
                    Spinner.stopAnimating()
                }
                catch let error as NSError {
                    Spinner.stopAnimating()
                    print(error)
                }
            }
        } else {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    

    
    


}


//
//  ErrorController.swift
//  nuw
//
//  Created by David Richards on 9/7/16.
//  Copyright © 2016 David Richards. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class ErrorController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var errorMessageLabel: WKInterfaceLabel?
    let userDefaults = UserDefaults.standard
    var this: WKInterfaceController!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        this = self
        WCSession.default().delegate = self
        WCSession.default().activate()
        
        
        // Configure interface objects here.
        if let dictionary = context as? [String: String] {
            if let message = dictionary["message"] {
                errorMessageLabel!.setText(message)
            }
        }
    }
    
    

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func closeModalView() {
        dismiss()
    }
 
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let key = message["NewRelicKey"] as? String {
           dismiss()
           popToRootController()
           self.userDefaults.set(key, forKey: "NewRelicKey")
           self.userDefaults.synchronize()
           self.didDeactivate()
           print("Got the key and should be popped")
        }
    }

    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("connection")
    }


}

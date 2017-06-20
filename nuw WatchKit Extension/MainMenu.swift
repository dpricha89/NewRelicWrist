//
//  MainMenu.swift
//  nuw
//
//  Created by David Richards on 8/6/16.
//  Copyright © 2016 David Richards. All rights reserved.
//

import WatchKit
import Foundation
import SwiftyJSON
import Alamofire


class MainMenu: WKInterfaceController {
    

    @IBOutlet var MainMenuTable: WKInterfaceTable!
    
    let userDefaults = UserDefaults.standard
    // Main Menu List - List of items to build the main menu with
    var MainMenuList: [String] = ["APM", "Servers", "Browser"];
    var NewRelicKey: String!
    
    // Get the userdata synchonized from the iphone app
    // this is where we get shared data between iPhone -> Apple Watch
    //let userDefaults = NSUserDefaults(suiteName: "group.com.dritechnologies.nuw")

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        loadTable()
    }
    
    override func didAppear() {
        loadTable()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func loadNoKey() {
        print("Running")
        self.presentController(withName: "ErrorController", context: ["message": "Mising New Relic API key. Please open the iPhone app to send it"]);
    }
    
    
    func loadTable() {
        if let key = userDefaults.object(forKey: "NewRelicKey") as? String {
            
            print("key \(key)")
            NewRelicKey = key
            
            // Load the menu table data
            MainMenuTable.setNumberOfRows(MainMenuList.count, withRowType: "MainMenuRow")
            
            for index in 0..<MainMenuTable.numberOfRows {
                if let controller = MainMenuTable.rowController(at: index) as? MainMenuRow {
                    controller.CategoryLabel.setText(MainMenuList[index])
                }
            }
            
        } else {
            loadNoKey()
            print("key not found. Open the iPhone app to enter it")
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        switch(rowIndex) {
           case 0:
               runApp()
           case 1:
               runServers()
           case 2:
               runBrowser()
           default:
               print("Used an unknown index")
        }
    }
    
    func runApp() {
        let url = "https://api.newrelic.com/v2/applications.json"
        if let controller = MainMenuTable.rowController(at: 0) as? MainMenuRow {
            // add loading label so user knows it is getting data
            controller.CategoryLabel.setText("loading...")
            Alamofire.request(url, headers: ["X-api-key": NewRelicKey]).validate().responseJSON { response in
                // change label back to normal
                controller.CategoryLabel.setText(self.MainMenuList[0])
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        self.presentController(withName: "APM", context: json.object)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    func runServers() {
        let url = "https://api.newrelic.com/v2/servers.json"
        if let controller = MainMenuTable.rowController(at: 1) as? MainMenuRow {
            // add loading label so user knows it is getting data
            controller.CategoryLabel.setText("loading...")
            Alamofire.request(url, headers: ["X-api-key": NewRelicKey]).validate().responseJSON { response in
                // change label back to normal
                controller.CategoryLabel.setText(self.MainMenuList[1])
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        self.presentController(withName: "Server", context: json.object)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    func runBrowser() {
        let url = "https://api.newrelic.com/v2/browser_applications.json"
        if let controller = MainMenuTable.rowController(at: 2) as? MainMenuRow {
            controller.CategoryLabel.setText("loading...")
            Alamofire.request(url, headers: ["X-api-key": NewRelicKey]).validate().responseJSON { response in
                // change label back to normal
                controller.CategoryLabel.setText(self.MainMenuList[2])
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        self.presentController(withName: "Browser", context: json.object)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

}

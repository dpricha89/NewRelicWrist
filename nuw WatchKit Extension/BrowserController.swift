//
//  BrowserController.swift
//  nuw
//
//  Created by David Richards on 8/6/16.
//  Copyright © 2016 David Richards. All rights reserved.
//

import WatchKit
import Foundation
import SwiftyJSON
import Alamofire

class BrowserController: WKInterfaceController {
    

    @IBOutlet var BrowserTable: WKInterfaceTable!
    let WARNING_COLOR = UIColor(red: 0.853, green: 0.422, blue: 0.000, alpha: 1.0)
    let GREEN_COLOR = UIColor(red: 0.230, green: 0.777, blue: 0.316, alpha: 1.0)
    let FAIL_COLOR = UIColor(red: 0.850, green: 0.218, blue: 0.159, alpha: 1.0)
    var Browsers: [JSON] = []

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let Context = JSON(context!)
        Browsers = Context["browser_applications"].arrayValue

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
    
    func determineRowColor(_ status: String) -> UIColor {
        switch(status) {
        case "green":
            return GREEN_COLOR
        case "orange":
            return WARNING_COLOR
        case "red":
            return FAIL_COLOR
        default:
            return GREEN_COLOR
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let Application = Browsers[rowIndex].object
        self.presentController(withName: "BrowserDetail", context: Application)
    }
    
    func loadTable() {
        
        BrowserTable.setNumberOfRows(Browsers.count, withRowType: "BrowserRow")
        
        for index in 0..<BrowserTable.numberOfRows {
            if let controller = BrowserTable.rowController(at: index) as? BrowserRow {
                var browser = Browsers[index]
                if let name = browser["name"].string {
                    browser["loader_script"] = ""
                    controller.StatusBar.setColor(determineRowColor(browser["status"].stringValue))
                    controller.BrowserLabel.setText(name)
                }
            }
        }
    }

}

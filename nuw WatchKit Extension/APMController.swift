//
//  APMController.swift
//  nuw
//
//  Created by David Richards on 8/6/16.
//  Copyright © 2016 David Richards. All rights reserved.
//

import WatchKit
import Foundation
import SwiftyJSON


class APMController: WKInterfaceController {


    @IBOutlet var APMTable: WKInterfaceTable!
    let WARNING_COLOR = UIColor(red: 0.853, green: 0.422, blue: 0.000, alpha: 1.0)
    let GREEN_COLOR = UIColor(red: 0.230, green: 0.777, blue: 0.316, alpha: 1.0)
    let FAIL_COLOR = UIColor(red: 0.850, green: 0.218, blue: 0.159, alpha: 1.0)
    let GRAY_COLOR = UIColor.gray
    var Applications: [JSON] = []
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let Context = JSON(context!)
        Applications = Context["applications"].arrayValue
        Applications.sort { $0["health_status"].stringValue > $1["health_status"].stringValue }
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
            return GRAY_COLOR
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let Application = Applications[rowIndex].object
        self.presentController(withName: "APMDetail", context: Application)
    }
    
    func loadTable() {
        
        APMTable.setNumberOfRows(Applications.count, withRowType: "APMRow")
        
        for index in 0..<APMTable.numberOfRows {
            if let controller = APMTable.rowController(at: index) as? APMRow {
                let application = Applications[index]
                if let name = application["name"].string {
                    let status = application["health_status"].stringValue
                    // determine seperator color
                    let rowColor = determineRowColor(status)
                    controller.APMStatus.setColor(rowColor)
                    controller.APMLabel.setText(name)
                }
            }
        }
    }

}

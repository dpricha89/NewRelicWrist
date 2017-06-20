//
//  ServersController.swift
//  nuw
//
//  Created by David Richards on 8/6/16.
//  Copyright © 2016 David Richards. All rights reserved.
//

import WatchKit
import Foundation
import SwiftyJSON


class ServerController: WKInterfaceController {

    @IBOutlet var ServersTable: WKInterfaceTable!
    let WARNING_COLOR = UIColor(red: 0.853, green: 0.422, blue: 0.000, alpha: 1.0)
    let GREEN_COLOR = UIColor(red: 0.230, green: 0.777, blue: 0.316, alpha: 1.0)
    let FAIL_COLOR = UIColor(red: 0.850, green: 0.218, blue: 0.159, alpha: 1.0)
    let GRAY_COLOR = UIColor.gray
    var Servers: [JSON] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        let Context = JSON(context!)
        Servers = Context["servers"].arrayValue
        
        // sort so servers with warnings show at the top
        Servers.sort { $0["health_status"].stringValue > $1["health_status"].stringValue }
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

    func loadTable() {
        
        ServersTable.setNumberOfRows(Servers.count, withRowType: "ServerRow")
        
        for index in 0..<ServersTable.numberOfRows {
            if let controller = ServersTable.rowController(at: index) as? ServerRow {
                // ger server object at the correct index
                let server = Servers[index]
                // make sure there is a name
                if let name = server["name"].string {
                    
                    // get health status of the server
                    let status = server["health_status"].stringValue
                    var statString = ""
                    
                    // determine seperator color
                    let rowColor = determineRowColor(status)
                    controller.ServerSeperator.setColor(rowColor)
                    controller.ServerLabel.setText(name)
                    
                    // make sure there is a summary before trying to set it
                    if let cpu = server["summary"]["cpu"].float,
                    let disk_used = server["summary"]["fullest_disk"].float,
                    let memory = server["summary"]["memory"].float {
                       statString = "CPU:\(cpu) DSK:\(disk_used) MEM:\(memory)"
                    }
                    // set stat label
                    controller.ServerStatsLabel.setText(statString)
                }
            }
        }
    }
}

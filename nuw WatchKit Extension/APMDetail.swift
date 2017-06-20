//
//  APMDetail.swift
//  nuw
//
//  Created by David Richards on 8/8/16.
//  Copyright © 2016 David Richards. All rights reserved.
//

import WatchKit
import Foundation
import SwiftyJSON
import Alamofire


class APMDetail: WKInterfaceController {
    @IBOutlet var NameLabel: WKInterfaceLabel!
    @IBOutlet var LanguageLabel: WKInterfaceLabel!
    @IBOutlet var ApdexLabel: WKInterfaceLabel!
    @IBOutlet var ThoughputLabel: WKInterfaceLabel!
    @IBOutlet var ErrorRateLabel: WKInterfaceLabel!
    @IBOutlet var HealthStatusLabel: WKInterfaceLabel!
    @IBOutlet var HostCountLabel: WKInterfaceLabel!
    let userDefaults = UserDefaults.standard
    var NewRelicKey: String!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let Application = JSON(context!)
        
        if let key = userDefaults.object(forKey: "NewRelicKey") as? String {
            print("key \(key)")
            NewRelicKey = key
        }
        
        let app_name = Application["name"].stringValue
        // set application summary params
        let apdex_target = Application["application_summary"]["apdex_target"].floatValue
        let throughput = Application["application_summary"]["throughput"].floatValue
        //let response_time = Application["application_summary"]["response_time"].stringValue
        let error_rate = Application["application_summary"]["error_rate"].floatValue
        let host_count = Application["application_summary"]["host_count"].intValue
        let apdex_score = Application["application_summary"]["apdex_score"].floatValue
        // set language
        let language = Application["language"].stringValue
        // last reported
        //let last_reported_at = Application["last_reported_at"].stringValue
        // health status
        let health_status = Application["health_status"].stringValue
        // application hosts
        //let application_hosts = Application["links"]["application_hosts"].arrayValue
        // APM id
        //let id = Application["id"].int


        
        // setup ui with data
        self.LanguageLabel.setText(language)
        self.NameLabel.setText(app_name)
        self.ApdexLabel.setText("Apdex: \(apdex_score) [\(apdex_target)]")
        self.ThoughputLabel.setText("Throughput: \(throughput) rpm")
        self.ErrorRateLabel.setText("Error Rate: \(error_rate)%")
        self.HealthStatusLabel.setText("Status: \(health_status)")
        self.HostCountLabel.setText("Hosts: \(host_count)")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

//
//  BrowserDetail.swift
//  nuw
//
//  Created by David Richards on 8/8/16.
//  Copyright © 2016 David Richards. All rights reserved.
//

import WatchKit
import Foundation
import Alamofire
import SwiftyJSON
import YOChartImageKit


class BrowserDetail: WKInterfaceController {
    
    @IBOutlet var ChartImage1: WKInterfaceImage!
    @IBOutlet var ChartImageLabel1: WKInterfaceLabel!
    @IBOutlet var ChartImageLabel2: WKInterfaceLabel!
    @IBOutlet var ChartImage2: WKInterfaceImage!
    @IBOutlet var ChartImageLabel3: WKInterfaceLabel!
    @IBOutlet var ChartImage3: WKInterfaceImage!
    @IBOutlet var BrowserName: WKInterfaceLabel!
    
    let userDefaults = UserDefaults.standard
    var NewRelicKey: String!
    let BaseUrl = "https://api.newrelic.com/v2/applications"

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let Browser = JSON(context!)
        
        if let key = userDefaults.object(forKey: "NewRelicKey") as? String {
            NewRelicKey = key
        }
        
        let app_id = Browser["id"].stringValue
        BrowserName.setText(Browser["name"].stringValue)
        
        let MetricsUrl = [BaseUrl, app_id, "metrics/data.json?names[]=EndUser"].joined(separator: "/")
        
        // is all 0
        var isAllZero: Bool = true
        
        // setup chart 1
        let chart1 = YOLineChartImage()
        chart1.fillColor = UIColor.blue
        chart1.values = [0]
        
        
        
        Alamofire.request(MetricsUrl,headers: ["X-api-key": NewRelicKey]).responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        var av_app_array: [NSNumber] = [NSNumber]()
                        
                        let metrics = json["metric_data"]["metrics"][0]["timeslices"].arrayValue
                        for metric in metrics {
                            let stat = metric["values"]["total_app_time"].numberValue
                            if (!stat.isEqual(to: 0)) {
                                isAllZero = false
                            }
                            av_app_array.append(metric["values"]["total_app_time"].numberValue)
                            
                        }

                        // init chart 1
                        if (!isAllZero) {
                            chart1.values = av_app_array
                            let frame = CGRect(x: 0, y: 0, width: self.contentFrame.width, height: self.contentFrame.height / 1.5)
                            let image = chart1.draw(frame, scale: WKInterfaceDevice.current().screenScale) // draw an image
                            self.ChartImage1.setImage(image)
                            self.ChartImageLabel1.setText("Average Load Time")
                        } else {
                            self.ChartImageLabel1.setText("No data")
                        }
                        
                    }
                case .failure(let error):
                    print(error)
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

}

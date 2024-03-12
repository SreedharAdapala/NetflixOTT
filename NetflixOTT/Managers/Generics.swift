//
//  Generics.swift
//  NetflixOTT
//
//  Created by Perennials on 12/03/24.
//

import Foundation
import FirebaseAnalytics

struct Generics {
    static let shared = Generics()
    
    func logEvent(id:String,itemName:String) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
          AnalyticsParameterItemID: "id-\(id)",
          AnalyticsParameterItemName: "\(itemName)",
          AnalyticsParameterContentType: "cont",
        ])
    }
    
    
}

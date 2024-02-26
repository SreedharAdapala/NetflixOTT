//
//  NSObject.swift
//  NetflixOTT
//
//  Created by Perennials on 23/02/24.
//

import Foundation

extension NSObject {
    class func className() -> String {
        return String(describing: self)
    }
}

//
//  Extensions.swift
//  NetflixOTT
//
//  Created by Perennials on 07/02/24.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

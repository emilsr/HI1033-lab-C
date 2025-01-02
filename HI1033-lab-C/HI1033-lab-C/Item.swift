//
//  Item.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-02.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

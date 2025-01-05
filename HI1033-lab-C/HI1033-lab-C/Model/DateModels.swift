//
//  DateModels.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

import Foundation

enum Month: String, CaseIterable {
    case january = "Jan"
    case february = "Feb"
    case march = "Mar"
    case april = "Apr"
    case may = "May"
    case june = "Jun"
    case july = "Jul"
    case august = "Aug"
    case september = "Sep"
    case october = "Oct"
    case november = "Nov"
    case december = "Dec"
    
    var number: Int {
        switch self {
        case .january: return 1
        case .february: return 2
        case .march: return 3
        case .april: return 4
        case .may: return 5
        case .june: return 6
        case .july: return 7
        case .august: return 8
        case .september: return 9
        case .october: return 10
        case .november: return 11
        case .december: return 12
        }
    }
    
    static func fromNumber(_ number: Int) -> Month? {
        return Month.allCases.first { $0.number == number }
    }
    
    static func fromString(_ string: String) -> Month? {
        return Month(rawValue: string)
    }
}

struct DateConstants {
    static let monthOrder: [String: Int] = Dictionary(
        uniqueKeysWithValues: Month.allCases.map { ($0.rawValue, $0.number) }
    )
    
    static let months: [String] = Month.allCases.map { $0.rawValue }
}

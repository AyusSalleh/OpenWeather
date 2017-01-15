//
//  Constant.swift
//  CodingChallenge
//
//  Created by Ayus Salleh on 15/01/2017.
//  Copyright © 2017 SubZ3r0X. All rights reserved.
//

import Foundation

class Utility {
    static let sharedInstance = Utility()
    
    func getMonthFullName(_ month: String) -> String {
        
        switch month {
        case "01":
            return "January"
        case "02":
            return "February"
        case "03":
            return "March"
        case "04":
            return "April"
        case "05":
            return "May"
        case "06":
            return "Jun"
        case "07":
            return "July"
        case "08":
            return "August"
        case "09":
            return "September"
        case "10":
            return "October"
        case "11":
            return "November"
        case "12":
            return "December"
        default:
            return ""
        }
        
    }
}

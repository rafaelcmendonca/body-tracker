//
//  Extensions.swift
//  BodyTracker
//
//  Created by Administrator on 20/01/20.
//  Copyright © 2020 RafaelCM. All rights reserved.
//

import Foundation
import SwiftUI

func convertStrToNSNum(text:String) -> NSNumber{
    if let myFloat = Float(text) {
        return NSNumber(value:myFloat)
    } else {
        return 0
    }
}

extension String {
    static let numberFormatter = NumberFormatter()
    var nsNumberValue: NSNumber {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return NSNumber(value:result.doubleValue)
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return NSNumber(value:result.doubleValue)
            }
        }
        return 0
    }
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}

func convertLbsToKg(text:String) -> NSNumber{
    let result = text.doubleValue * 0.454
    return NSNumber(value:result)
}

func getMyColor() -> Color{
    return Color(hue: 0.454, saturation: 1.0, brightness: 1.0)
}

func getTextFieldColor() -> Color{
    return Color(hue: 1.0, saturation: 0.026, brightness: 0.100)
}

func dateToString(rawDate:Date) -> String{
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "dd-MM-yyyy  -  HH:MM"

    return dateFormatterPrint.string(from: rawDate)
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

class HapticFeedback {
    #if os(watchOS)
    //watchOS implementation
    static func playSelection() -> Void {
        WKInterfaceDevice.current().play(.click)
    }
    #else
    //iOS implementation
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    static func playSelection() -> Void {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
        //UISelectionFeedbackGenerator().selectionChanged()
    }
    #endif
}

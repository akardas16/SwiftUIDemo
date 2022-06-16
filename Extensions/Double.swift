//
//  Double.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 4.05.2022.
//

import Foundation
import UIKit
import SwiftUI

extension Double{
    
    private var currencyFormatter:NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        
//        formatter.currencyCode = "usd"
//        formatter.currencySymbol = "$"
        
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        
        return formatter
    }
    
    func currencyFormatString() -> String {
        let number = NSNumber(value: self)
       
        return currencyFormatter.string(from: number) ?? "$0.00"
    }
    
    func asPercantage() -> String{
       return String(format: "%.2f", self) + "%"
    }
    
    func asTwoDigit() -> String{
        return String(format: "%.2f", self) 
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension String {
    func formatStr() -> String{
        let dataString = String(self)
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let showDate = inputFormatter.date(from: dataString) // 04/05/2020
        inputFormatter.dateFormat = "dd/MM/yyyy"
        return inputFormatter.string(from: showDate!)
    }
    
    func add7Day() -> String{
        let dataString = String(self)
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        var showDate = inputFormatter.date(from: dataString) // 04/05/2020
        showDate?.addTimeInterval(7 * 24 * 60 * 60)
        inputFormatter.dateFormat = "dd/MM/yyyy"
        return inputFormatter.string(from: showDate!)
    }
}


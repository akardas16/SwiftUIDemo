//
//  String.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 12.06.2022.
//

import Foundation
extension String {
    
    var removeHtml:String{
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

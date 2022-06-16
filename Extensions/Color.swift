//
//  Color.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 30.04.2022.
//

import Foundation
import SwiftUI
//var a = UserDefaults.standard.bool(forKey: "dfgdfg")



extension Color{
    static let theme = CustomColors()
    
        
}

struct CustomColors{
  
   
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}




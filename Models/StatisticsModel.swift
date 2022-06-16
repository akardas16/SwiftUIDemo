//
//  StatisticsModel.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 24.05.2022.
//

import Foundation
struct StatisticsModel:Identifiable{
    let id:UUID = UUID()
    let title:String
    let value:String
    let percentageChange:Double?
    init(title:String,value:String,percentageChange:Double? = nil){
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
//let model = StatisticsModel(title: <#T##String#>, value: <#T##String#>)

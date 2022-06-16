//
//  StatisticView.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 24.05.2022.
//

import SwiftUI

struct StatisticView: View {
    let stat = StatisticsModel(title: "Total Volume", value: "$1.23Tr")
    let stst2 = StatisticsModel(title: "Porfolio Value", value: "$50.4k", percentageChange: -12.34)
    var model:StatisticsModel
    var body: some View {
        VStack(alignment:.leading){
            Text(model.title).foregroundColor(.theme.secondaryText).font(.caption)
            Text(model.value).font(.headline).foregroundColor(.theme.accent)
            HStack(spacing:4) {
                Image(systemName: "triangle.fill").font(.caption2)
                    .rotationEffect(.degrees(model.percentageChange ?? 0 >= 0 ? 0:180))
                Text("\(String(format: "%.2f", model.percentageChange ?? ""))%")
                    .font(.caption).bold()
            }.foregroundColor(model.percentageChange ?? 0 >= 0 ? .theme.green:.theme.red).opacity(model.percentageChange == nil ? 0:1)
        }.padding()
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            StatisticView(model: StatisticsModel(title: "Market cap", value: "$12.5Bn", percentageChange: 25.34)).previewLayout(.sizeThatFits)
            
            StatisticView(model: StatisticsModel(title: "Market cap", value: "$12.5Bn", percentageChange: 25.34)).previewLayout(.sizeThatFits).preferredColorScheme(.dark)
        }
       
    }
}

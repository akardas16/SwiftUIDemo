//
//  HomeStatsView.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 24.05.2022.
//

import SwiftUI

struct HomeStatsView: View {
    @EnvironmentObject private var homeModel:HomeViewModel
    @Binding var isOpenPortfolio:Bool
    
    var body: some View {
        HStack{
            ForEach(homeModel.model) { item in
                StatisticView(model: item).frame(width:UIScreen.main.bounds.width / 3)
            }
        }.frame(width:UIScreen.main.bounds.width,alignment: .leading).offset(x:isOpenPortfolio ? -(UIScreen.main.bounds.width / 3) : 0, y: 0).animation(.easeInOut, value: isOpenPortfolio)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HomeStatsView(isOpenPortfolio: .constant(false))
        }.environmentObject(HomeViewModel())
        
    }
}

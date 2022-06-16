//
//  DetailView.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 28.05.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct LoadingView: View {
    var coin:CoinModel?
    var body: some View {
        DetailView(coin: coin)
    }
}
struct DetailView: View {
     var coin:CoinModel?
    @State var isLimit:Bool = true
    @StateObject var detailViewModel:DetailViewModel
    init(coin:CoinModel?){
        self.coin = coin
        _detailViewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
       
    }
    
    var body: some View {
        ZStack {
            ScrollView{
                VStack(spacing:20){
                    ChartView(coin: coin ?? ExampleCoinModel.coin).padding(.horizontal).padding(.vertical)
                    Text("OverView").font(.title).bold().foregroundColor(.theme.accent).frame(maxWidth:.infinity,alignment: .leading).padding(.leading)
                    Divider()
                    if let describtion = detailViewModel.describtion, !describtion.isEmpty{
                        VStack(alignment:.leading) {
                            Text(describtion).font(.callout).foregroundColor(Color.theme.secondaryText).lineLimit(isLimit ? 3:.max)
                            Button(isLimit ? "Expand":"Collapse"){
                                withAnimation(isLimit ? .spring() :.none) {
                                    isLimit.toggle()
                                }
                            }.font(.callout).tint(.blue).padding(.vertical,1)
                        }
                    }
                    
                   
                    
                    LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())], alignment: .leading, spacing: 15, pinnedViews: []) {
                        ForEach(detailViewModel.overviewArray) { item in
                            StatisticView(model: item)
                        }
                        
                    }
                    Spacer()
                    Text("Additional Details").font(.title).bold().foregroundColor(.theme.accent).frame(maxWidth:.infinity,alignment: .leading).padding(.leading)
                    
                    LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())], alignment: .leading, spacing: 15, pinnedViews: []) {
                        ForEach(detailViewModel.detailArray) { item in
                            StatisticView(model: item)
                        }
                        
                    }
                    
                    if let websiteString = detailViewModel.homeUrl, let url = URL(string: websiteString) {
                        
                        HStack(spacing:45) {
                            
                            Link(destination: url) {
                                Text("Home Page").font(.callout).underline().foregroundColor(Color.blue)
                            }
                            
                            if let redditString = detailViewModel.redditUrls, let url = URL(string: redditString){
                                Link(destination: url) {
                                    Text("Reddit").font(.callout).underline().foregroundColor(Color.blue)
                                }
                            }
                           
                        }.frame(maxWidth: .infinity)
                    }
                }
            }
           
           
        }.navigationTitle(coin?.name ?? "").navigationBarTitleDisplayMode(.inline).toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack{
                    Text(coin?.symbol.uppercased() ?? "").font(.headline).foregroundColor(.theme.secondaryText)
                    
                    AnimatedImage(url: URL(string: coin?.image ?? "")).placeholder(content: {
                        ProgressView()
                    }).resizable().scaledToFit().frame(width: 28, height: 28).clipShape(Circle())
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DetailView(coin: ExampleCoinModel.coin).environmentObject(DetailViewModel(coin: ExampleCoinModel.coin)).preferredColorScheme(.dark)
        }
       
    }
}

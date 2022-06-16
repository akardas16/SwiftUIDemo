//
//  HomeView.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 30.04.2022.
//

import SwiftUI
import SwiftUIRefresh

struct HomeView: View {
    @State var showPortFolio:Bool = false
    @EnvironmentObject var homeModel:HomeViewModel
    @State var searchText:String = ""
    @State var plusSheetOpen:Bool = false
    //For DetailView
    @State var isShowDetail:Bool = false
    @State var slcCoin:CoinModel? = nil
    @State var isSheetOpen:Bool = false
    
    var body: some View {
        ZStack {
           Color.theme.background.ignoresSafeArea()
            VStack{
                headerView
                HomeStatsView(isOpenPortfolio: $showPortFolio)
                SearchBarView(textHolder: $homeModel.searchText)
                columnName
                if !showPortFolio{
                    allCoinsList.listStyle(PlainListStyle()).transition(.move(edge: .leading))
                }
                
                if showPortFolio {
                    ZStack(alignment:.center){
                        if homeModel.portfolioCoins.isEmpty && searchText.isEmpty {
                            Text("You don't have any coin. Click + to add new coin").padding().multilineTextAlignment(.center).font(.callout).foregroundColor(.theme.accent).padding(.horizontal)

                        }else{
                            portfolioList.listStyle(PlainListStyle())
                        }
                    }.transition(.move(edge: .trailing))
                    
                    
                }
                Spacer()
               
            }
           
        }.sheet(isPresented: $isSheetOpen) {
            SettingsView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {

    static var previews: some View {
        
        NavigationView{
            VStack {
                HomeView().navigationBarHidden(true)
            }
        }.environmentObject(HomeViewModel()).preferredColorScheme(.light)
    }
}

extension HomeView{
    var headerView:some View{
        VStack{
            HStack{
                CircleButton(iconName: showPortFolio ? "plus" : "info") {
                    if showPortFolio {
                        plusSheetOpen.toggle()
                    }else{
                        isSheetOpen.toggle()
                    }
                }
                .background(CircleButtonAnim(animate: $showPortFolio)).animation(.none, value: showPortFolio)
                .sheet(isPresented: $plusSheetOpen) {
                    PortfolioView().environmentObject(homeModel)
                }
                Spacer()
                Text(showPortFolio ? "Portfolio" : "Live Prices").font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.theme.accent).animation(.none, value: showPortFolio)
                Spacer()
                CircleButton(iconName: "chevron.right") {
                    withAnimation(.spring()) {
                        showPortFolio.toggle()
                    }
                    
                }.rotationEffect(.degrees(showPortFolio ? 180:0)).animation(.spring(), value: showPortFolio)

            }.padding(.horizontal)
       
        }
    }
}
struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
extension HomeView {

    var allCoinsList:some View {
        List{
            ForEach(homeModel.allCoins, id: \.id) { eachCoin in
                CoinRowView(coin: eachCoin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0)).background(
                        NavigationLink {
                            NavigationLazyView(LoadingView(coin:eachCoin))
                        } label: {
                            
                        }.opacity(0)
                    )
                
            }
            
        }.pullToRefresh(isShowing: $homeModel.isLoading) {
            homeModel.reloadData()
        }
    }
    
    var portfolioList:some View {
        List{
            ForEach(homeModel.portfolioCoins, id: \.id) { eachCoin in
                CoinRowView(coin: eachCoin, showHoldingsColumn: true).listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
            }
            
        }
    }
    var columnName:some View {
        HStack{
            Spacer()
            Menu {
 
                if showPortFolio {
                    Button {
                        homeModel.sortOption = .holding
                    } label: {
                        Label("Holding", systemImage: "chevron.right")
                    }
                    
                    Button {
                        homeModel.sortOption = .reverseHolding
                    } label: {
                        Label("Reverse Holding", systemImage: "chevron.right")
                    }
                }else {
                    Button {
                        homeModel.sortOption = .price
                    } label: {
                        Label("Price", systemImage: "chevron.right")
                    }
                    
                    Button {
                        homeModel.sortOption = .reversePrice
                    } label: {
                        Label("Reverse Price", systemImage: "chevron.right")
                    }
                    
                    Button {
                        homeModel.sortOption = .rank
                    } label: {
                        Label("Rank", systemImage: "chevron.right")
                    }
                    
                    Button {
                        homeModel.sortOption = .reverseRank
                    } label: {
                        Label("Reverse Rank", systemImage: "chevron.right")
                    }
                }
            } label: {
                HStack(spacing:4){
                    Text("Coin")
                    Image(systemName: "arrow.up.arrow.down").font(.caption2)
                    
                }
            }

           
            
            
            Spacer()
            Spacer()
            if showPortFolio {
                Text("Holdings")
            }
            Spacer()
            Spacer()
            Text("Price")
            Spacer()
        }.font(.caption).foregroundColor(.theme.secondaryText)
    }
}

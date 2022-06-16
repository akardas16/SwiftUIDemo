//
//  HomeViewModel.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 10.05.2022.
//

import Foundation
import Combine

class HomeViewModel:ObservableObject {
    var url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")
    
    @Published var allCoins:[CoinModel] = []
    @Published var portfolioCoins:[CoinModel] = []
    @Published var searchText:String = ""
    @Published var model:[StatisticsModel] = []
    @Published var dictionaryArray = UserDefaults.standard.object(forKey: "userHolds") as? [[String:String]] ?? [[:]]
    @Published var isLoading:Bool = false
    @Published var sortOption:SortBy = .reverseRank
    
    let dataService = CoinDataServices()
    private var cancalables = Set<AnyCancellable>()
    
    init(){
       addSubsciber()
       subscribeStaticData()
        //getHoldingCoins()
    }
    
    func reloadData() {
        isLoading = true
        dataService.getCoins()
        dataService.getDataStatistic()
       
    }
    func getHoldingCoins(){
        $dictionaryArray
            .combineLatest($sortOption)
            .map {[weak self] arraydic, sorting -> [CoinModel] in
            var holdModel:[CoinModel] = []
            for dic in arraydic {
                if let symbol = dic["symbol"] {
                    if let allCoinss = self?.allCoins {
                        if let item = self?.find(value: symbol, in:  allCoinss){
                            var newItem = item
                            newItem.currentHolding = Double(dic["amount"] ?? "0")
                            holdModel.append(newItem)
                        }
                    }

                }
            }
                switch sorting {
                case .price:
                    holdModel.sort{$0.currentPrice ?? 0 < $1.currentPrice ?? 0}
                case .holding:
                    holdModel.sort{$0.currentHolding ?? 0 < $1.currentHolding ?? 0}
                case .rank:
                    holdModel.sort{$0.rank < $1.rank}
                case .reversePrice:
                    holdModel.sort{$0.currentPrice ?? 0 > $1.currentPrice ?? 0}
                case .reverseRank:
                    holdModel.sort{$0.rank > $1.rank}
                case .reverseHolding:
                    holdModel.sort{$0.currentHolding ?? 0 > $1.currentHolding ?? 0}
                }
            return holdModel
        }.sink {[weak self] returnedData in
            self?.portfolioCoins = returnedData
        }.store(in: &cancalables)

       
    }
    
    func sortBy(sorting:SortBy,holdModel:[CoinModel]){
        
    }
    func setHoldingCoin(symbol:String,amount:String){
       
        var newDic:[String:String] = [:]
        newDic["symbol"] = symbol
        newDic["amount"] = amount
        dictionaryArray.append(newDic)
        UserDefaults.standard.set(dictionaryArray, forKey: "userHolds")
        if dictionaryArray.allSatisfy({$0["symbol"] != symbol}){
            
        }
    }
    
    func find(value coinSymbol: String, in array: [CoinModel]) -> CoinModel?{
        for (_, value) in array.enumerated(){
            if value.symbol.uppercased() == coinSymbol.uppercased(){
    return value}
    }

    return nil
    }
    func subscribeStaticData(){
        dataService.$statisticData
            .map{globalData -> [StatisticsModel] in
                var statisticModel:[StatisticsModel] = []
                let model1 = StatisticsModel(title: "Market Cap", value: String(format: "%.2f", globalData?.data.totalMarketCap ?? 0), percentageChange: globalData?.data.marketCapChangePercentage24HUsd)
                let model2 = StatisticsModel(title: "Total Volume", value: String(format: "%.2f", globalData?.data.totalVolume ?? 0))
                let model3 = StatisticsModel(title: "Total Currencies", value: "\(globalData?.data.activeCryptocurrencies ?? 0)" )
                let model4 = StatisticsModel(title: "Portfolio", value: "$0.00",percentageChange: 0)
                
                statisticModel.append(contentsOf: [model1,model2,model3,model4])
                return statisticModel
            }
            .sink {[weak self] returnedData in
                self?.model = returnedData
                self?.isLoading = false
            }.store(in: &cancalables)
    }
    
    func addSubsciber(){
//        dataService.$allCoins.sink { [weak self]returnedCoins in
//            self?.allCoins = returnedCoins
//        }.store(in: &cancalables)
        
        $searchText.combineLatest(dataService.$allCoins,$sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filteredAndSortedCoinModel)
            .sink { [weak self] returnedModel in
            self?.allCoins = returnedModel
            self?.getHoldingCoins()
        }.store(in: &cancalables)
    }
    
    func sortBy(name:SortBy){
        $allCoins.map { modelArray -> [CoinModel] in
            var newArray:[CoinModel] = modelArray
            if name == SortBy.price{
                newArray.sort {$0.currentPrice ?? 0 <= $1.currentPrice ?? 0}
            }else if name == SortBy.reversePrice {
                newArray.sort {$0.currentPrice ?? 0 >= $1.currentPrice ?? 0}
            }
            
            return newArray
        }.sink {[weak self] returnedModel in
            self?.allCoins = returnedModel
        }.store(in: &cancalables)
    }
    
    enum SortBy {
        case price,rank,holding,reversePrice,reverseRank,reverseHolding
    }
    func filteredAndSortedCoinModel(userText:String,newCoinModel:[CoinModel],name:SortBy) -> [CoinModel]{
        let lovercasedText = userText.lowercased()
        var newArray:[CoinModel] = newCoinModel
        switch name {
        case .price,.holding:
            newArray.sort {$0.currentPrice ?? 0 <= $1.currentPrice ?? 0}
        case .reversePrice,.reverseHolding:
            newArray.sort {$0.currentPrice ?? 0 >= $1.currentPrice ?? 0}
        case .rank:
            newArray.sort {$0.rank >= $1.rank}
        case .reverseRank:
            newArray.sort {$0.rank <= $1.rank}
        }
    
        if !lovercasedText.isEmpty {
            
           return newArray.filter({$0.name.lowercased().contains(lovercasedText) && $0.symbol.lowercased().contains(lovercasedText)})
        }else {
            return newArray
        }
    }

}

//
//  DetailViewModel.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 29.05.2022.
//

import Foundation
import Combine
class DetailViewModel:ObservableObject{
    @Published var detailMod:DetailModel? = nil
    @Published var overviewArray:[StatisticsModel] = []
    @Published var detailArray:[StatisticsModel] = []
    @Published var selectedCoin:CoinModel? = nil
    
    @Published var redditUrls:String? = nil
    @Published var homeUrl:String? = nil
    @Published var describtion:String? = nil
    
    let coinService = CoinDataServices()
    
    var cancellable:Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(coin:CoinModel? = nil){
        selectedCoin = coin
        addDetailCoinSubscriber(coin: coin)
        createDetailData()
    }
    
    func addDetailCoinSubscriber(coin:CoinModel?){
        guard let id = coin?.id else {return}
       let urlString = "https://api.coingecko.com/api/v3/coins/\(id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
        guard let url = URL(string: urlString) else {return}
       NetworkingManager.download(url: url)
            .decode(type: DetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) {[weak self] returnedModel in
                guard let self = self else{return}
                self.detailMod = returnedModel
                //print(returnedModel)
                //Cancel
                for cancl in self.cancellable {
                    cancl.cancel()
                }
            }.store(in: &cancellable)

    }
    
    func createDetailData(){
        $detailMod.combineLatest($selectedCoin)
            .map { (returnedDModel,coin) -> (overview:[StatisticsModel],additional:[StatisticsModel],linkMaps:[String:String]) in
            
            var ovArray:[StatisticsModel] = []
            var addiArray:[StatisticsModel] = []
            
            let price = coin?.currentPrice?.asTwoDigit() ?? "0.00"
            let priceChange = coin?.priceChangePercentage24H?.asPercantage() ?? "0%"
            let priceState = StatisticsModel(title: "Current Price", value: price,percentageChange: Double(priceChange))
            
            let marketCap = "$" + (coin?.marketCap?.asTwoDigit() ?? "0.00")
            let marketCapChange = coin?.marketCapChangePercentage24H
            let marketState = StatisticsModel(title: "Market Capitilization", value: marketCap, percentageChange: marketCapChange)
           
            
            let rank = "\(coin?.rank ?? 0)"
            let rankState = StatisticsModel(title: "Rank", value: rank)
            
            let volume = coin?.totalVolume?.asTwoDigit() ?? "0.00"
            let volumeState = StatisticsModel(title: "Total Volume", value: volume)
            
            ovArray.append(contentsOf: [priceState,marketState,rankState,volumeState])
            
            //Additional
            let high = coin?.high24H?.asTwoDigit() ?? "0.00"
            let highState = StatisticsModel(title: "24H", value: high)
            
            let low = coin?.low24H?.asTwoDigit() ?? "0.00"
            let lowhState = StatisticsModel(title: "24H", value: low)
            
            let priceChange2 = coin?.marketCapChange24H?.asTwoDigit() ?? "0.00"
            let pricePercantage2 = coin?.priceChangePercentage24H?.asPercantage() ?? "0%"
            let priceState2 = StatisticsModel(title: "24H Price Change", value: priceChange2,percentageChange: Double(pricePercantage2))
            
            let marketCap2 = "$" + (coin?.marketCap?.asTwoDigit() ?? "0.00")
            let marketCapChange2 = coin?.marketCapChangePercentage24H
            let marketState2 = StatisticsModel(title: "24H Market Cap Change", value: marketCap2, percentageChange: marketCapChange2)
   
            var maps:[String:String] = [:]
            maps["home"] = returnedDModel?.links?.homepage?.first
            maps["sub"] = returnedDModel?.links?.subredditURL
            maps["desc"] = returnedDModel?.welcomeDescription?.en?.removeHtml
        
            addiArray.append(contentsOf: [highState,lowhState,priceState2,marketState2])
            return (ovArray,addiArray,maps)
        }
        .sink(receiveValue: {[weak self]returnedObjects in
            guard let self = self else{return}
            self.overviewArray = returnedObjects.overview
            self.detailArray = returnedObjects.additional
            self.homeUrl = returnedObjects.linkMaps["home"]
            self.redditUrls = returnedObjects.linkMaps["sub"]
            self.describtion = returnedObjects.linkMaps["desc"]
        }).store(in: &cancellable)

    }
    
    func handleArrays(detailMod:DetailModel?,coin:CoinModel?) -> (overview:[StatisticsModel],additional:[StatisticsModel]) {
        
        var ovArray:[StatisticsModel] = []
        var addiArray:[StatisticsModel] = []
        
        let price = coin?.currentPrice?.asTwoDigit() ?? "0.00"
        let priceChange = coin?.priceChangePercentage24H?.asPercantage() ?? "0%"
        let priceState = StatisticsModel(title: "Current Price", value: price,percentageChange: Double(priceChange))
        
        let marketCap = "$" + (coin?.marketCap?.asTwoDigit() ?? "0.00")
        let marketCapChange = coin?.marketCapChangePercentage24H
        let marketState = StatisticsModel(title: "Market Capitilization", value: marketCap, percentageChange: marketCapChange)
        print("******" + price)
        print("******" + marketCap)
        print("******" + priceChange)
        let rank = "\(coin?.rank ?? 0)"
        let rankState = StatisticsModel(title: "Rank", value: rank)
        
        let volume = coin?.totalVolume?.asTwoDigit() ?? "0.00"
        let volumeState = StatisticsModel(title: "Total Volume", value: volume)
        
        ovArray.append(contentsOf: [priceState,marketState,rankState,volumeState])
        
        //Additional
        let high = coin?.high24H?.asTwoDigit() ?? "0.00"
        let highState = StatisticsModel(title: "24H", value: high)
        
        let low = coin?.low24H?.asTwoDigit() ?? "0.00"
        let lowhState = StatisticsModel(title: "24H", value: low)
        
        let priceChange2 = coin?.marketCapChange24H?.asTwoDigit() ?? "0.00"
        let pricePercantage2 = coin?.priceChangePercentage24H?.asPercantage() ?? "0%"
        let priceState2 = StatisticsModel(title: "24H Price Change", value: priceChange2,percentageChange: Double(pricePercantage2))
        
        let marketCap2 = "$" + (coin?.marketCap?.asTwoDigit() ?? "0.00")
        let marketCapChange2 = coin?.marketCapChangePercentage24H
        let marketState2 = StatisticsModel(title: "24H Market Cap Change", value: marketCap2, percentageChange: marketCapChange2)
        
//        let blockTime = coin.lastUpdated ?? "16:20"
//        let timeState = StatisticsModel(title: "Last Update", value: blockTime)
        
        
        addiArray.append(contentsOf: [highState,lowhState,priceState2,marketState2])
        
        return (ovArray,addiArray)
    }
}

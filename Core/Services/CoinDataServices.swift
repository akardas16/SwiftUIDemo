//
//  CoinDataServices.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 11.05.2022.
//

import Foundation
import Combine
class CoinDataServices {
    @Published var allCoins:[CoinModel] = []
    @Published var statisticData:GlobalData?
    var cancelables:AnyCancellable?
    var secondCancellable:AnyCancellable?
    
    init()  {
         getCoins()
         getDataStatistic()
    }
    
    func getCoins()  {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {
            return
        }
        
        cancelables = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {[weak self](returnedCoins) in
                self?.allCoins = returnedCoins
                self?.cancelables?.cancel()
            })
}
    
    func getDataStatistic() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {return}
        secondCancellable =  NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) {[weak self] returnedData in
                self?.statisticData = returnedData
                self?.secondCancellable?.cancel()
            }

    }
    
}

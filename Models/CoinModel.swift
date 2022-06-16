//
//  CoinModel.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 4.05.2022.
//

import Foundation
import UIKit

var url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")

/*
 {
     "id": "bitcoin",
     "symbol": "btc",
     "name": "Bitcoin",
     "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
     "current_price": 38953,
     "market_cap": 740708505599,
     "market_cap_rank": 1,
     "fully_diluted_valuation": 817372735836,
     "total_volume": 26166170503,
     "high_24h": 38970,
     "low_24h": 37615,
     "price_change_24h": 405.54,
     "price_change_percentage_24h": 1.05206,
     "market_cap_change_24h": 7112978942,
     "market_cap_change_percentage_24h": 0.96961,
     "circulating_supply": 19030337,
     "total_supply": 21000000,
     "max_supply": 21000000,
     "ath": 69045,
     "ath_change_percentage": -43.5589,
     "ath_date": "2021-11-10T14:24:11.849Z",
     "atl": 67.81,
     "atl_change_percentage": 57369.69485,
     "atl_date": "2013-07-06T00:00:00.000Z",
     "roi": null,
     "last_updated": "2022-05-04T09:18:18.005Z",
     "sparkline_in_7d": {
       "price": [
         38472.40175045033,
         38614.46439304863,
         38896.40247754651,
         38960.06153944932,
         39097.743014707834,
         39108.063247346785,
         38897.511566629255,
         38920.772506072244,
         39389.84923995019,
         38744.51681687499,
         39054.6273156367,
       ]
     },
     "price_change_percentage_24h_in_currency": 1.0520617284328948
   }
 */
struct CoinModel:Identifiable,Codable,Equatable{
    static func == (lhs: CoinModel, rhs: CoinModel) -> Bool {
        return lhs.name == rhs.name
    }
    
     let id, symbol, name: String
     let image: String
     let currentPrice, marketCap, marketCapRank, fullyDilutedValuation: Double?
     let totalVolume, high24H, low24H: Double?
     let priceChange24H, priceChangePercentage24H: Double?
     let marketCapChange24H: Double?
     let marketCapChangePercentage24H: Double?
     let circulatingSupply, totalSupply, maxSupply, ath: Double?
     let athChangePercentage: Double?
     let athDate: String?
     let atl, atlChangePercentage: Double?
     let atlDate: String?
    // let roi: String?
     let lastUpdated: String?
     let sparklineIn7D: SparklineIn7D?
     let priceChangePercentage24HInCurrency: Double?
    
    var currentHolding:Double?

     enum CodingKeys: String, CodingKey {
         
         case id, symbol, name, image
         case currentPrice = "current_price"
         case marketCap = "market_cap"
         case marketCapRank = "market_cap_rank"
         case fullyDilutedValuation = "fully_diluted_valuation"
         case totalVolume = "total_volume"
         case high24H = "high_24h"
         case low24H = "low_24h"
         case priceChange24H = "price_change_24h"
         case priceChangePercentage24H = "price_change_percentage_24h"
         case marketCapChange24H = "market_cap_change_24h"
         case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
         case circulatingSupply = "circulating_supply"
         case totalSupply = "total_supply"
         case maxSupply = "max_supply"
         case ath
         case athChangePercentage = "ath_change_percentage"
         case athDate = "ath_date"
         case atl
         case atlChangePercentage = "atl_change_percentage"
         case atlDate = "atl_date"
         //case roi
         case lastUpdated = "last_updated"
         case sparklineIn7D = "sparkline_in_7d"
         case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
         case currentHolding
     }
    
    
    func updateHolding(amount:Double) -> CoinModel {
        return CoinModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHolding: amount)
    }
    
    var currentHoldingValue: Double {
        return (currentHolding ?? 0.0) * (currentPrice ?? 0)
    }
    
    var rank:Int {
        return Int(marketCapRank ?? 0)
    }
    

}

// MARK: - SparklineIn7D
struct SparklineIn7D: Codable {
    let price: [Double]?
}

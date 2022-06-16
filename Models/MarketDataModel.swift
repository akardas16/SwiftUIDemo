//
//  MarketDataModel.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 24.05.2022.
//

import Foundation
// MARK: - DataClass

struct GlobalData: Codable {
    let data: MarketDataModel
}
struct MarketDataModel: Codable {
    let activeCryptocurrencies, upcomingIcos, ongoingIcos, endedIcos: Int
    let markets: Int
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    let updatedAt: Int

    enum CodingKeys: String, CodingKey {
          case activeCryptocurrencies = "active_cryptocurrencies"
          case upcomingIcos = "upcoming_icos"
          case ongoingIcos = "ongoing_icos"
          case endedIcos = "ended_icos"
          case markets
          case totalMarketCap = "total_market_cap"
          case totalVolume = "total_volume"
          case marketCapPercentage = "market_cap_percentage"
          case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
          case updatedAt = "updated_at"
      }
    
    func getValueFromKey(key:String) -> String{
       return String(format: "%.2f", totalMarketCap[key] ?? 0)
    }
}

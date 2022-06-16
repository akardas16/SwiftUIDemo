//
//  CoinRowView.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 4.05.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct CoinRowView: View {
    let coin:CoinModel
    let showHoldingsColumn:Bool
    var body: some View {
        HStack{
           
            leftColumn
            Spacer()
            
           middleColumn
            
            Spacer()
            
            rightColumn
            
           
        }.font(.subheadline).background(Color.theme.background.opacity(0.001))
        
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group{
            CoinRowView(coin: ExampleCoinModel.coin, showHoldingsColumn: true).previewLayout(.sizeThatFits)
            
            CoinRowView(coin: ExampleCoinModel.coin, showHoldingsColumn: true).previewLayout(.sizeThatFits).preferredColorScheme(.dark)
        }
        
    }
}

extension CoinRowView {
    private var leftColumn:some View {
        HStack{
            Text("\(coin.rank)").font(.caption).foregroundColor(.theme.secondaryText).frame(minWidth:30)
            //Circle().frame(width: 30, height: 30)
            AnimatedImage(url: URL(string: coin.image)).placeholder(content: {
                ProgressView()
            }).resizable().scaledToFit().frame(width: 30, height: 30).clipShape(Circle())
        
//            AsyncImage(url: URL(string: coin.image),transaction: Transaction(animation: .easeOut)) { phase in
//                             switch phase {
//                             case .success(let image):
//                                 image.resizable().scaledToFit().frame(width: 30, height: 30).clipShape(Circle())
//                             default:
//                                 ProgressView()
//                             }
//                         }
            Text(coin.symbol.uppercased()).font(.headline).padding(.leading,4)
        }
    }
}

extension CoinRowView {
    private var middleColumn:some View {
        VStack{
            if showHoldingsColumn {
                VStack(alignment:.trailing){
                    Text(coin.currentHoldingValue.currencyFormatString()).bold()
                    Text(String(format: "%.2f", coin.currentHolding ?? 0))
                }.foregroundColor(.theme.accent)
            }
        }
    }
}

extension CoinRowView {
    private var rightColumn:some View{
        VStack(alignment:.trailing){
            Text(coin.currentPrice?.currencyFormatString() ?? "$0.00").bold().foregroundColor(.theme.accent)
            
            Text((coin.priceChangePercentage24H?.asPercantage())!).foregroundColor(coin.priceChangePercentage24H ?? 0 >= 0 ? .theme.green:.theme.red)
        }.padding(.trailing,8)
    }
}

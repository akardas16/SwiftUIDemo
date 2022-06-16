//
//  ChartView.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 31.05.2022.
//

import SwiftUI

struct ChartView: View {
    let coin:CoinModel
    let priceArray:[Double]
    var lineColor:Color
    var maxY:Double
    var minY:Double
    let startingDate:String
    let endingDate:String
    @State var isAnimStart:Bool = false
    
    init(coin:CoinModel){
        self.coin = coin
        self.priceArray = coin.sparklineIn7D?.price ?? []
        self.maxY = priceArray.max() ?? 0
        self.minY = priceArray.min() ?? 0
        self.lineColor = priceArray.last ?? 0 > priceArray.first ?? 0 ? Color.theme.green:Color.theme.red
        self.startingDate = coin.lastUpdated?.formatStr() ?? ""
        self.endingDate = coin.lastUpdated?.add7Day() ?? ""
    }
    var body: some View {
        VStack {
            backgroundAndOverlay
            HStack {
                Text(startingDate).font(.caption).foregroundColor(.theme.secondaryText).padding(.leading,2)
                Spacer()
                Text(endingDate).font(.caption).foregroundColor(.theme.secondaryText).padding(.trailing,2)
            }
            
        }
    }
    
    var geometryPart:some View {
        GeometryReader { geometry in
            Path {path in
                for index in priceArray.indices {
                    let xPosition = geometry.size.width / CGFloat(priceArray.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((priceArray[index] - minY)) / yAxis) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    
                }
            }.trim(from: 0, to: isAnimStart ? 1:0).stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .shadow(color: lineColor.opacity(0.8), radius: 10, x: 0, y: 10)
                .shadow(color: lineColor.opacity(0.6), radius: 10, x: 0, y: 10)
                .shadow(color: lineColor.opacity(0.4), radius: 10, x: 0, y: 10)
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.linear(duration: 2)){
                    isAnimStart = true
                }
            }
           
        }
    }
    var backgroundAndOverlay: some View{
        geometryPart.frame(height:200).background(
            VStack{
                Divider()
                Spacer()
                Divider()
                Spacer()
                Divider()
            }
        ).overlay(alignment: .leading, content: {
            VStack{
                Text("\(maxY.asTwoDigit())").font(.caption).foregroundColor(.theme.secondaryText)
                Spacer()
                Text("\(((minY + maxY) / 2).asTwoDigit())").font(.caption).foregroundColor(.theme.secondaryText)
                Spacer()
                Text("\(minY.asTwoDigit())").font(.caption).foregroundColor(.theme.secondaryText)
            }.padding(.leading,2)
        })
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: ExampleCoinModel.coin)
    }
}

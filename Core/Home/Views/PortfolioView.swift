//
//  PortfolioView.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 25.05.2022.
//

import SwiftUI
import SDWebImageSwiftUI


struct PortfolioView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var model:HomeViewModel
    @State var selectedCoin:CoinModel? = nil
    @State var textfieldAmount:String = ""
    @State var navTitle:String = "Edit Portfolio"

    
    var body: some View {
        NavigationView{
            ZStack {
                Color.theme.background.ignoresSafeArea()
                VStack(spacing:8){
                    SearchBarView(textHolder: $model.searchText)
                    scrollList
                    if selectedCoin != nil {
                        VStack(spacing:8) {
                            HStack(alignment:.top){
                                Text("Current price of \(selectedCoin?.name ?? ""):").foregroundColor(.theme.secondaryText)
                                Spacer()
                                Text("\(String(format: "%.2f", selectedCoin?.currentPrice ?? 0)) $").foregroundColor(.theme.secondaryText)
                            }
                            Divider()
                            HStack(alignment:.center){
                                Text("Amount in Portfolio:").foregroundColor(.theme.secondaryText)
                                Spacer()
                                TextField("Ex 1.4", text: $textfieldAmount).keyboardType(.decimalPad)
                                    //.focused($isFocussed)
                                    .padding(6).background(RoundedRectangle(cornerRadius: 8).stroke(Color.theme.secondaryText, lineWidth: 1)).frame(width:100).padding(2)
                            }
                            Divider()
                            HStack(alignment:.center){
                                Text("Current Value:").foregroundColor(.theme.secondaryText)
                                Spacer()
                                Text(currentValue()).foregroundColor(.theme.secondaryText)
                            }
                            Divider()
                        }.frame(width:.infinity).animation(.none, value: selectedCoin).padding(.horizontal,8)
                    }
                    Spacer()
                   
                }.navigationTitle(navTitle).toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }

                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save"){
                            withAnimation(.easeInOut){
                                model.setHoldingCoin(symbol: selectedCoin?.symbol ?? "", amount: textfieldAmount)
                                navTitle = "Holding Saved!"
                                UIApplication.shared.endEditing()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    navTitle = "Edit Portfolio"
                                }
                            }
                        }.opacity(
                            selectedCoin != nil && textfieldAmount.count > 0 ? 1:0
                        )
                    }

                }.onChange(of: model.searchText) { newValue in
                    if newValue == ""{
                        selectedCoin = nil
                    }
                }
            }
        }
        
    }
    var scrollList:some View{
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack(alignment:.top,spacing:0){
                ForEach(model.allCoins) { eachCoin in
                    LazyVStack{
                        AnimatedImage(url: URL(string: eachCoin.image)).placeholder(content: {
                            ProgressView()
                        }).resizable().scaledToFit().frame(width: 50, height: 50).clipShape(Circle())
                        
                        Text(eachCoin.symbol.uppercased()).foregroundColor(selectedCoin?.id == eachCoin.id ? Color.theme.green : Color.theme.accent).font(.headline).bold().lineLimit(2).minimumScaleFactor(0.5).multilineTextAlignment(.center).padding(.top,4)
                        Text(eachCoin.name).font(.caption).foregroundColor(.theme.secondaryText).multilineTextAlignment(.center).minimumScaleFactor(0.5)
                    }.padding(.vertical,12).padding(.horizontal,12)
                    .background(
                        RoundedRectangle(cornerRadius: 8).stroke(selectedCoin?.id == eachCoin.id ? Color.theme.green : Color.clear, lineWidth: 1)
                    ).padding(.leading,12).onTapGesture {
                        withAnimation(.easeOut){
                            selectedCoin = eachCoin
                        }
                    }.frame(width:120)
                    
                }
            }
        }.frame(height:150).padding(.top,12)
    }
    
    func currentValue() -> String{
        let a = (selectedCoin?.currentPrice ?? 0) * (Double(textfieldAmount) ?? 0)
       return "\(String(format: "%.2f", a)) $"
    }
    
  
    
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView().environmentObject(HomeViewModel()).preferredColorScheme(.dark)
    }
}
struct UserHolding{
    let symbol:String
    let holdingAmnt:Double
}

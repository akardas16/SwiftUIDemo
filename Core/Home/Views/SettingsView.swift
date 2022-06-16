//
//  SettingsView.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 12.06.2022.
//

import SwiftUI

struct listModel:Identifiable{
    let id:UUID = UUID()
    let url:URL?
    let name:String
}
struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    var urls:[listModel] = [listModel(url: URL(string: "https://www.youtube.com/"), name: "Youtube"),listModel(url: URL(string: "https://twitter.com/home"), name: "Twitter"),listModel(url: URL(string: "https://www.reddit.com/"), name: "Reddit")]
    var body: some View {
        NavigationView{
            ZStack {
               
                VStack{
                    GroupBox {
                        Image("logo").resizable().frame(width: 100, height: 100).clipShape(RoundedRectangle(cornerRadius: 20))
                        Text("This app developed by Abdullah Kardas wtih help of Nick. All rights are reserved.").font(.headline).foregroundColor(.theme.secondaryText).multilineTextAlignment(.center)
                    }
                  
                    
                    List {
                        ForEach(urls) { url in
                            Link(destination: url.url!) {
                                Text(url.name).foregroundColor(.blue).bold().font(.callout)
                            }
                           
                        }
                    }.listStyle(GroupedListStyle())
                }.padding()
            }.navigationTitle("Settings").toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark").font(.callout).foregroundColor(.theme.accent)
                    }

                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().preferredColorScheme(.dark)
    }
}

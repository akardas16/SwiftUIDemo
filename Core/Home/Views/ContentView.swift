//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 28.04.2022.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    @State var backColor: Color = .theme.red
    @State var title:String = "title 1"

    var body: some View {
       
        ZStack {
        
            backColor.ignoresSafeArea()
            VStack {
                Text(title).foregroundColor(.white).bold()
                ExtractedV(myColor: $backColor, title: $title)
            }

         
    }
       
    }
    
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}


struct ExtractedV :View {
    @Binding var myColor: Color
    @Binding var title:String
    var body: some View{
        ZStack{
            Button {
                myColor = .purple
                title = "title changed"
            } label: {
                Text("Change background").foregroundColor(.white)
            }
        }
    }
}

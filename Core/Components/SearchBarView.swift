//
//  SearchBarView.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 15.05.2022.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var textHolder:String
    @FocusState private var nameIsFocused: Bool

    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass").foregroundColor(textHolder == "" ? .theme.secondaryText:.theme.accent)
            
            TextField("Search By name or Symbol", text: $textHolder).foregroundColor(textHolder == "" ? .theme.secondaryText:.theme.accent).disableAutocorrection(true).focused($nameIsFocused)
            Button {
                textHolder = ""
                nameIsFocused = false
            } label: {
                Image(systemName: "xmark.circle.fill").foregroundColor(textHolder == "" ? .theme.secondaryText:.theme.accent).opacity(textHolder == "" ? 0:1)
            }

        }.font(.headline).padding().background(
            RoundedRectangle(cornerRadius: 25).fill(Color.theme.background)
        ).padding().shadow(color: .theme.accent.opacity(0.3), radius: 12, x: 0, y: 0)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SearchBarView(textHolder: .constant("")).preferredColorScheme(.light).previewLayout(.sizeThatFits)
            SearchBarView(textHolder: .constant("")).preferredColorScheme(.dark).previewLayout(.sizeThatFits)

        }
    }
}

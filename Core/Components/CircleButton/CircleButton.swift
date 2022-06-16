//
//  CircleButton.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 30.04.2022.
//

import SwiftUI

struct CircleButton: View {
    var iconName:String
    var onClicked: () -> Void = {}
    var body: some View {
        Button {
            onClicked()
        } label: {
            Image(systemName: iconName)
                .font(.headline).foregroundColor(.theme.accent)
                .frame(width: 50, height: 50)
                .background(
                    Circle().foregroundColor(.theme.background)
                ).shadow(color: .theme.accent.opacity(0.36), radius: 10, x: 0, y: 0).padding()
        }

      
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        Group{
        
            CircleButton(iconName: "folder.fill",onClicked: {
                
            }).previewLayout(.sizeThatFits)
            CircleButton(iconName: "trash.fill").previewLayout(.sizeThatFits).preferredColorScheme(.dark)

        }
    }
}

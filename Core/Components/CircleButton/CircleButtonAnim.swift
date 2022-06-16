//
//  CircleButtonAnim.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 30.04.2022.
//

import SwiftUI

struct CircleButtonAnim: View {
    
    @Binding var animate:Bool
    var body: some View {
        Circle().stroke(lineWidth: 5).scale(animate ? 1:0)
            .opacity(animate ? 0:1).animation(animate ? .easeOut(duration: 1) : .none, value: animate)
    }
}

struct CircleButtonAnim_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnim(animate: .constant(true)).foregroundColor(.red).frame(width: 200, height: 200)
    }
}

//
//  OutdoorValue.swift
//  Hilo-iwatch-1 WatchKit Extension
//
//  Created by ZHONG Sailin on 06.12.19.
//  Copyright © 2019 ZHONG Sailin. All rights reserved.
//

import SwiftUI

struct OutdoorValueView: View {
    @State var scale: CGFloat = 1
    @State var opacity: Double = 1.0
    
    var body: some View {
        ZStack {
            Circle()
            .fill(Color.green)
            .frame(width: 30, height: 30)
            .shadow(color: .green, radius: 10)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                let baseAnimation = Animation.easeInOut(duration: 1)
                let repeated = baseAnimation.repeatForever(autoreverses: true)

                return withAnimation(repeated) {
                    self.scale = CGFloat.random(in: 0.9 ..< 1.0)
                    self.opacity = Double.random(in: 0.6 ..< 1.0)
                }
            }
        }
    }
    
}



struct OutdoorValueView_Previews: PreviewProvider {
    static var previews: some View {
        OutdoorValueView()
    }
}



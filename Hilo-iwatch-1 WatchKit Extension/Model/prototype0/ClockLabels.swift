//
//  ClockLabels.swift
//  Hilo-iwatch-1 WatchKit Extension
//
//  Created by ZHONG Sailin on 03.12.19.
//  Copyright © 2019 ZHONG Sailin. All rights reserved.
//

import SwiftUI

struct ClockLabals: View {
    
    let paddingValue: CGFloat
    let rotationDegree: Double
    let textColor: Color
    
    
    var body: some View {
        VStack {
            Text(String(Int(rotationDegree / 360 * 60)))
                .foregroundColor(textColor)
                .font(Font.custom("Helvetica Bold", size: 12))
                .rotationEffect(Angle(degrees: -rotationDegree))
                .padding(.bottom, paddingValue)
        }.rotationEffect(Angle(degrees: rotationDegree))
    
    }

}

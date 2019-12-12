//
//  ClockMarks.swift
//  Hilo-iwatch-1 WatchKit Extension
//
//  Created by ZHONG Sailin on 03.12.19.
//  Copyright © 2019 ZHONG Sailin. All rights reserved.
//

import SwiftUI

struct ClockMarks: View {
    
//    private let relativeLength: CGFloat = 0.015
    @Binding var nbPoints: Int
    @Binding var showRiskIndicator: Bool
    @Binding var isStayAlarmed: Bool
    
    let time: ClockModel
    
    var body: some View {
        
        GeometryReader { geometry in
            // --- the hour tick marks
//            ForEach(0..<self.nbPoints) { n in
//                Path { path in
//                    path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
//                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: self.relativeLength * geometry.size.height))
//                }
//                .stroke(Color.secondary)
//                .rotationEffect(Angle(degrees: Double(n) * 360 / 60))
//            }
            
            // --- the minutes dot marks
            // 60 min; opacity of the dots with prediction is full and opacity of the dots without prediction is low
            ForEach(0 ..< 60) { n in
                
                ZStack {
                    if(n < self.nbPoints){
                        Circle()
                            .frame(width: CGFloat(2), height: CGFloat(2))
                            .position(CGPoint(x: geometry.size.width / 2, y: CGFloat(4)))
                            .opacity(1.0)
                    }else{
                        Circle()
                            .frame(width: CGFloat(2), height: CGFloat(2))
                            .position(CGPoint(x: geometry.size.width / 2, y: CGFloat(4)))
                            .opacity(0.3)
                    }
                    
                }
                .rotationEffect(Angle(degrees: Double(n) * 360 / 60))
                .shadow(color: Color.white, radius: 1)
                
                
            }
            
            // --- the hour labels
            ZStack {
                // --- current time label
                if(!self.isStayAlarmed){
                    ClockLabals(paddingValue: CGFloat(geometry.size.width) * 1.05, rotationDegree: Double(0), textColor: Color.white)
                        .position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                }else{ // the zero mark will stay red
                    ClockLabals(paddingValue: CGFloat(geometry.size.width) * 1.05, rotationDegree: Double(0), textColor: Color.red)
                        .position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                }
                
                // --- risky moment label
                if(self.showRiskIndicator){
                    ClockLabals(paddingValue: CGFloat(geometry.size.width) * 1.05, rotationDegree: Double(self.time.minutes) * 360 / 60, textColor: Color.red)
                        .position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                        .shadow(color: Color.red, radius: 5)
                }
                
                // --- prediction end time label
                ClockLabals(paddingValue: CGFloat(geometry.size.width) * 1.05, rotationDegree: Double(self.nbPoints) * 360 / 60, textColor: Color.white)
                    .position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                
                
            }
        }
        
       
    }

}

//struct ClockMarks_Previews: PreviewProvider {
//    static var previews: some View {
//        ClockMarks(nbPoints: .constant(20), time: <#ClockModel#>)
//    }
//}


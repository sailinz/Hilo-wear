//
//  ClockIndicator.swift
//  Hilo-iwatch-1 WatchKit Extension
//
//  Created by ZHONG Sailin on 03.12.19.
//  Copyright © 2019 ZHONG Sailin. All rights reserved.
//

import SwiftUI

struct ClockIndicator: View {
    
        enum `Type` {
        case minute
        
        var color: Color {
            return Color.red
        }
        
        var thickness: CGFloat {
            return 3 // minute
        }
        
        func angle(for time: ClockModel) -> Angle {
            return Angle(degrees: Double(time.minutes) * 360 / 60)
        }
        
        func baseRadiusFactor(for time: ClockModel) -> CGFloat {
            return 0.05
        }
    }
    
    let type: `Type`
    
    let time: ClockModel
    
//    let relativeLength: CGFloat
    @Binding var clockIndicatorLength: CGFloat
    @Binding var showClockIndicator: Bool
    
    //clock tick
    var body: some View {
        GeometryReader { geometry in
            Path {
                path in
                let c = self.center(of: geometry.size)
                let baseRadius = 0.5 * self.type.baseRadiusFactor(for: self.time) * min(geometry.size.width, geometry.size.height)
                path.addArc(center: c, radius: baseRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: true)
            }
            .fill(self.type.color)
            
            if(self.showClockIndicator){
                Path {
                    path in
                    let c = self.center(of: geometry.size)
                    path.move(to: c)
                    path.addLine(to: CGPoint(x: c.x, y: c.y - self.clockIndicatorLength * self.radius(for: geometry.size)))
                }
                .stroke(style: StrokeStyle(lineWidth: self.type.thickness, lineCap: .round))
                .fill(self.type.color)
                .rotationEffect(self.type.angle(for: self.time))
                
                Path {
                    path in
                    let c = CGPoint(x: self.center(of: geometry.size).x, y: self.center(of: geometry.size).y - self.clockIndicatorLength * self.radius(for: geometry.size))
                    let baseRadius = 0.5 * self.type.baseRadiusFactor(for: self.time) * min(geometry.size.width, geometry.size.height)
                    path.addArc(center: c, radius: baseRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: true)
                }
                .fill(self.type.color)
                .rotationEffect(self.type.angle(for: self.time))
            }
            
        }
    }
    
    private func center(of size: CGSize) -> CGPoint {
        return CGPoint(x: size.width / 2, y: size.height / 2)
    }
    
    private func radius(for size: CGSize) -> CGFloat {
        return min(size.width, size.height) / 2
    }
}

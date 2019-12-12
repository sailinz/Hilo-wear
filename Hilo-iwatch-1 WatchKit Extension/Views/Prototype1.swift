//
//  ScenarioList.swift
//  Hilo-iwatch-1 WatchKit Extension
//
//  Created by ZHONG Sailin on 02.12.19.
//  Copyright © 2019 ZHONG Sailin. All rights reserved.
//

import SwiftUI
import WatchKit

struct Prototype1: View {
    let topic: Topic
    // -- for experiment only: hardcoded the moment of risk and prediction period
    @State public var nbPointMarks: Int = 20 // define number of prediction minutes
    @State public var riskyMinute: Int = 12
    @State private var showRiskIndicator: Bool = true
    @State private var clockIndicatorLength: CGFloat = 0.73
    @State private var isP1UserReacted:Bool = false
    @State private var isStayAlarmed:Bool = false
    
    @State private var startTime: Date = Date()
    @State private var isFirstLoad = true
     

    @State(initialValue: ClockModel())
    private var time: ClockModel
    
    var body: some View {
        ZStack {
            ClockMarks(nbPoints: $nbPointMarks, showRiskIndicator: $showRiskIndicator, isStayAlarmed: $isStayAlarmed, time: time)
            ClockIndicator(type: .minute, time: time, clockIndicatorLength: $clockIndicatorLength, showClockIndicator: $showRiskIndicator)
            OutdoorValueView()
        }
        .padding()
        .aspectRatio(1, contentMode: .fit)
        .onAppear{
            if(self.isFirstLoad){
                self.initStartDateTime()
                self.isFirstLoad = false
            }
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                CloudKitHelper.fetch { (result) in
                    switch result {
                    case .success(let newItem):
                        if(newItem.p1UserReaction != 0){ // user reacts to the interface 0=false
                            self.isP1UserReacted = true
                            self.showRiskIndicator = false
                        }
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                }
                
                
                let minuteElapsed = Calendar.current
                    .dateComponents([.minute], from: self.startTime, to: Date())
                    .minute!
                
//                if(self.time.minutes > 0)
//                {
//                    self.clockIndicatorLength += CGFloat.random(in: -0.005 ..< 0.03) // randomize the prediction
//                    self.time.minutes -= 1
                if(self.riskyMinute - minuteElapsed > 0)
                {
                    self.time.minutes = self.riskyMinute - minuteElapsed
                    let current_minute = self.time.minutes
                    self.time.minutes = self.riskyMinute - minuteElapsed
                    if(current_minute - self.time.minutes  > 0){
                        self.clockIndicatorLength += CGFloat.random(in: -0.005 ..< 0.03) // randomize the prediction
                    }
                    
                }else{
                    self.time.minutes = 0
                    if(self.isP1UserReacted != true){
                        WKInterfaceDevice.current().play(.stop)
                        self.isP1UserReacted = true  // stop vibration
                        self.showRiskIndicator = true
                    }
                }

            }
        }
    }
    
    func initStartDateTime(){
        self.startTime = Date()
    }
}

struct CardList_Previews1: PreviewProvider {
    static var previews: some View {
        Prototype1(topic: Topic.previewTopic)
    }
}



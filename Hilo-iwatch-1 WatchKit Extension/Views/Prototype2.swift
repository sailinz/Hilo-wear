//
//  ScenarioList.swift
//  Hilo-iwatch-1 WatchKit Extension
//
//  Created by ZHONG Sailin on 02.12.19.
//  Copyright © 2019 ZHONG Sailin. All rights reserved.
//

import SwiftUI
import WatchKit

struct Prototype2: View {
    let topic: Topic
    /// -- for experiment only: hardcoded the moment of risk and prediction period
    @State public var nbPointMarks: Int = 20 /// define number of prediction minutes
    @State public var riskyMinute: Int = 19
    let ongoingPredTime = 2
    @State private var showRiskIndicator: Bool = false
    @State private var isP2Notified:Bool = false
    @State private var isStayAlarmed:Bool = false

    @State(initialValue: ClockModel())
    private var time: ClockModel
    @State(initialValue: WorkoutDataStore())
    private var backgroundSession: WorkoutDataStore

    
    private let hourPointerBaseRadius: CGFloat = 0.1
    private let secondPointerBaseRadius: CGFloat = 0.05
    @State private var isReacted = false
    @State private var isFirstLoad = true /// the wedges need to be created before the view. this is to handle this situation
    @State private var startTime: Date = Date()
    
    @State private var currentCO2Text: Int = 451
    @State private var currentCO2TextColor: Color = .green
    
    let currentCO2 = [430, 440, 445, 450, 460, 470, 480, 500, 560, 570, 580, 590, 600, 800, 860, 870, 900, 934, 1025, 1055, 1085, 1104, 1140, 1150, 1160, 1146, 1143, 1150, 1146, 1160, 1025, 1055, 1085, 1104, 1140, 1150, 1160, 1146, 1143, 1143]
    let certainty = [0.93, 0.94, 0.92, 0.93, 0.90, 0.89, 0.87, 0.86, 0.84, 0.83, 0.82, 0.81, 0.80, 0.79, 0.78, 0.77, 0.75, 0.74, 0.76, 0.75]
    
    /// The description of the ring of wedges.
    @State(initialValue: Ring())
    private var ring: Ring
    
    var body: some View {
        ZStack {
            ClockMarks(nbPoints: $nbPointMarks, showRiskIndicator: $showRiskIndicator, isStayAlarmed: $isStayAlarmed, time: time)
                
            if(!isFirstLoad){
                ForEach(ring.wedgeIDs, id: \.self) { wedgeID in
                    WedgeView(wedge: self.ring.wedges[wedgeID]!)

                }
            }
            
            OutdoorValueView()
                .onAppear(){
                    if(self.isFirstLoad){
                        self.initWedge()
                        self.initStartDateTime()
                        self.isFirstLoad = false
                    }
                }

                ZStack(){
                    Text(String(self.currentCO2Text))
                        .font(Font.custom("Helvetica Bold", size: 14))
                        .foregroundColor(self.currentCO2TextColor)
                    Text("ppm")
                        .font(Font.custom("Helvetica", size: 6))
                        .foregroundColor(self.currentCO2TextColor)
                        .offset(y: 8)
                        
                }
                .offset(y: 80)
            
        }
        .padding()
        .aspectRatio(1, contentMode: .fit)
        .onAppear{
            Timer.scheduledTimer(withTimeInterval: 1 , repeats: true) { timer in
                if(self.time.minutes > self.riskyMinute - self.nbPointMarks)
                {
                    /// this is to handle the situation that the watch goes to sleep now and then
                    let minuteElapsed = Calendar.current
                        .dateComponents([.minute], from: self.startTime, to: Date())
                        .minute!
                    let current_minute = self.time.minutes ///store the previous value before assign new value to it
                    self.time.minutes = self.riskyMinute - minuteElapsed

                    /// update the prediction every minute
                    if( (current_minute - self.time.minutes) > 0 && minuteElapsed >= self.ongoingPredTime){
//                        for n in self.ring.wedgeIDs.min()!...(self.ring.wedgeIDs.min()! + current_minute - self.time.minutes - 1){
//                            self.ring.removeWedge(id: n)
//                        }
                        
                        self.updateRing(minuteElapsed: minuteElapsed)
                        self.showRiskIndicator = true
                        
                        /// notify user when the first risk is detected
                        if(minuteElapsed == self.ongoingPredTime){
                            WKInterfaceDevice.current().play(.failure)
                        }
                        
                    }
                    
                    
//                    self.ring.randomizeWedgeDepth()
                    
                    CloudKitHelper.fetch { (result) in
                        switch result {
                        case .success(let newItem):
                            if(newItem.p2UserReaction != 0){ // user reacts to the interface 0=false
                                self.isP2Notified = true
//                                self.ring.updateWedgesColor()
                                self.initWedge()
                                self.showRiskIndicator = false
                                self.isReacted = true
                                self.currentCO2Text = Int.random(in: 450 ..< 470)
                            }else{
                                self.currentCO2Text = Int.random(in: (self.currentCO2[self.nbPointMarks - self.time.minutes - 1]-10) ..< (self.currentCO2[self.nbPointMarks - self.time.minutes - 1]+10))
                            }
                            
                            /// update text color according to current CO2 level
                            if(self.currentCO2Text < 600){
                                self.currentCO2TextColor = .green
                            }else if(self.currentCO2Text >= 600 && self.currentCO2Text < 1000){
                                self.currentCO2TextColor = .yellow
                            }else{
                                self.currentCO2TextColor = .red
                            }
                        case .failure(let err):
                            print(err.localizedDescription)
                        }
                    }
                    
                    /// if there's no action (like opening a window) from the user, give them another alarm
                    if(self.time.minutes == 0){
                        if(self.isP2Notified != true){
                            WKInterfaceDevice.current().play(.failure)
                            self.isP2Notified = true
                        }
                    }
                    
                    /// keep the mark at position 0 red
                    if(self.time.minutes < 0){
                        self.showRiskIndicator = false
                        if(!self.isReacted){
                            self.isStayAlarmed = true
                        }
                    }
                    
                    /// enable vibration when the app enters background mode
                    if(minuteElapsed == self.nbPointMarks){
                        self.backgroundSession.stopWorkoutSession()
                    }
                
                }
            }
        }
    }
    
    func initWedge(){
        self.ring.reset()
        
        for n in 0..<nbPointMarks{

                let newWedge = Ring.Wedge(
                width: 1,
                depth: self.certainty[n] * 0.95, // -> certainty
                hue: 0.37 // -> risk: green
            )
            self.ring.addWedge(newWedge)
        }
    }
    
    
    
    func updateRing(minuteElapsed: Int){
        self.ring.reset()
                
        var wedgeHue: Double
        var isRiskIndicator: Bool = false

        
        // pre-defined wedges for experiment.
        if(self.nbPointMarks - 1 + minuteElapsed < self.currentCO2.count){
            for n in 0 ... self.nbPointMarks - 1 {
                
                if(self.currentCO2[n + minuteElapsed] < 600){
                    wedgeHue = 0.37
                }else if(self.currentCO2[n + minuteElapsed] >= 600 && self.currentCO2[n + minuteElapsed] < 1000){
                    wedgeHue = 0.16
                }else{
                    wedgeHue = 0.0
                }
                
                if(minuteElapsed > 0 && self.currentCO2[n + minuteElapsed - 1] < 1000){ /// change state from unrisky to risky
                    isRiskIndicator = true
                }else{
                    isRiskIndicator = false
                }
                
                let newWedge = Ring.Wedge(
                    width: 1,
                    depth: Double.random(in: (self.certainty[n] - 0.02) ..< (self.certainty[n] + 0.02)) * 0.95, /// -> certainty
                    hue: wedgeHue, /// -> risk: green
                    isRiskIndicator: isRiskIndicator
                )
                self.ring.addWedge(newWedge)
            }
        }
            
        self.isFirstLoad = false
    }
    
    func initStartDateTime(){
        self.startTime = Date()
        self.backgroundSession.startWorkoutSession()
        
    }
}

//struct CardList_Previews2: PreviewProvider {
//    static var previews: some View {
//        Prototype2(topic: Topic.previewTopic)
//    }
//}




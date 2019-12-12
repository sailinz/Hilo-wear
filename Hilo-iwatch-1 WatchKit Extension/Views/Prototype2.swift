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
    // -- for experiment only: hardcoded the moment of risk and prediction period
    @State public var nbPointMarks: Int = 20 // define number of prediction minutes
    @State public var riskyMinute: Int = 12
    @State private var showRiskIndicator: Bool = true
    @State private var isP2Notified:Bool = false
    @State private var isStayAlarmed:Bool = false
    

    @State(initialValue: ClockModel())
    private var time: ClockModel

    
    private let hourPointerBaseRadius: CGFloat = 0.1
    private let secondPointerBaseRadius: CGFloat = 0.05
    @State private var isReacted = false
    @State private var isFirstLoad = true
    @State private var startTime: Date = Date()
    
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
                
                ///for debugging purpose
//                VStack{
//                    Text(String(self.ring.wedgeIDs.min()!))
////                    ForEach(ring.wedgeIDs, id: \.self) { wedgeID in
////                        Text(String(wedgeID))
////                        .font(Font.custom("Helvetica Bold", size: 6))
////                    }
//                }

            }
            
            
            
            OutdoorValueView()
                .onAppear(){
                    if(self.isFirstLoad){
                        self.initWedge()
                        self.initStartDateTime()
                    }
                }
        }
        .padding()
        .aspectRatio(1, contentMode: .fit)
        .onAppear{
            Timer.scheduledTimer(withTimeInterval: 1 , repeats: true) { timer in
                if(self.time.minutes > self.riskyMinute - self.nbPointMarks)
                {
                    
//                    self.time.minutes -= 1
//                    self.ring.removeWedge(id: self.ring.wedgeIDs.min()!)
                    
                    let minuteElapsed = Calendar.current
                        .dateComponents([.minute], from: self.startTime, to: Date())
                        .minute!
                    let current_minute = self.time.minutes
                    self.time.minutes = self.riskyMinute - minuteElapsed

                    if(current_minute - self.time.minutes  > 0){
                        for n in self.ring.wedgeIDs.min()!...(self.ring.wedgeIDs.min()! + current_minute - self.time.minutes - 1){
                            self.ring.removeWedge(id: n)
                        }
                    }
                    
                    
                    self.ring.randomizeWedgeDepth()
                    
                    CloudKitHelper.fetch { (result) in
                        switch result {
                        case .success(let newItem):
                            if(newItem.p2UserReaction != 0){ // user reacts to the interface 0=false
                                self.isP2Notified = true
                                self.ring.updateWedgeColor()
                                self.showRiskIndicator = false
                                self.isReacted = true
                            }
                        case .failure(let err):
                            print(err.localizedDescription)
                        }
                    }
                    
                    // if there's no action (like opening a window) from the user, give them an alarm
                    if(self.time.minutes == 0){
                        if(self.isP2Notified != true){
                            WKInterfaceDevice.current().play(.stop)
                            self.isP2Notified = true
                        }
                    }
                    
                    if(self.time.minutes < 0){
                        self.showRiskIndicator = false
                        if(!self.isReacted){
                            self.isStayAlarmed = true
                        }
                    }
                }
            }
        }
    }
    
    func initWedge(){
        self.ring.reset()
        
        // pre-defined wedges for experiment.
        let risk = [0.37, 0.37, 0.37, 0.16, 0.37, 0.37, 0.37, 0.16, 0.16, 0.16, 0.0, 0.0, 0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0 ]
        let certainty = [0.6, 0.7, 0.7, 0.2, 0.5, 0.6, 0.7, 0.7, 0.8, 0.7, 0.75, 0.97, 0.8, 0.7, 0.67, 0.76, 0.68, 0.70, 0.69, 0.78 ]
        
        for n in 0..<nbPointMarks{
            var newWedge = Ring.Wedge(
                    width: 1,
                    depth: certainty[n] * 0.95, // -> certainty
                    hue: risk[n] // -> risk
            )
            if(n == riskyMinute - 1){
                newWedge.isRiskIndicator = true
            }
            self.ring.addWedge(newWedge)
        }
        self.isFirstLoad = false
    }
    
    func initStartDateTime(){
        self.startTime = Date()
    }
}

//struct CardList_Previews2: PreviewProvider {
//    static var previews: some View {
//        Prototype2(topic: Topic.previewTopic)
//    }
//}




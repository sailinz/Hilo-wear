import SwiftUI
import Combine
import WatchKit
import CoreData
import CloudKit

struct Prototype0 : View {
    let topic: Topic
    /// -- for experiment only: hardcoded the moment of risk and prediction period
    @State public var nbPointMarks: Int = 20 /// define number of prediction minutes
    @State public var riskyMinute: Int = 19
    let ongoingPredTime = 2 /// for experiment only. the first 2 min, it doesn't predict anything
    @State private var showRiskIndicator: Bool = false ///  determine if the app keeps the mark at position 0 red
    @State private var isStayAlarmed: Bool = false

    @State(initialValue: ClockModel())
    private var time: ClockModel
    
    @State(initialValue: WorkoutDataStore())
    private var backgroundSession: WorkoutDataStore
    
    @State private var clockIndicatorLength: CGFloat = 0.93
    @State private var isP0UserReacted: Bool = false
    @State private var startTime: Date = Date()
    @State private var isFirstLoad = true
    @State private var isVibrated = false /// to handle the first notification
    @State private var currentCO2Text: Int = 451
    @State private var currentCO2TextColor: Color = .green

    
    let currentCO2 = [430, 440, 445, 450, 460, 470, 480, 500, 560, 570, 580, 590, 600, 800, 860, 870, 900, 934, 1025, 1055, 1085, 1104, 1140, 1150, 1160, 1146, 1143, 1150, 1146, 1160, 1025, 1055, 1085, 1104, 1140, 1150, 1160, 1146, 1143, 1143]
    
    

    var body: some View {

        ZStack {
            
            ClockMarks(nbPoints: $nbPointMarks, showRiskIndicator: $showRiskIndicator, isStayAlarmed: $isStayAlarmed, time: time)
            ClockIndicator(type: .minute, time: time, clockIndicatorLength: $clockIndicatorLength, showClockIndicator: $showRiskIndicator)
            OutdoorValueView()
            
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
            if(self.isFirstLoad){
                self.initStartDateTime()
                self.isFirstLoad = false
                
            }
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                CloudKitHelper.fetch { (result) in
                    switch result {
                    case .success(let newItem):
                        if(newItem.p0UserReaction != 0){ /// user reacts to the interface 0=false
                            self.isP0UserReacted = true
                            self.showRiskIndicator = false
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
                

                let minuteElapsed = Calendar.current
                    .dateComponents([.minute], from: self.startTime, to: Date())
                    .minute!
                
                
                if(minuteElapsed == self.ongoingPredTime && !self.isVibrated){
                    WKInterfaceDevice.current().play(.failure)
                    self.isVibrated = true
                }
                
                /// needs to use >= to in case the user didn't look at the screen when the first risky moment happends
                if (minuteElapsed >= self.ongoingPredTime && !self.isP0UserReacted){ /// for experiment purpose
                    self.showRiskIndicator = true
                }
                
                /// the tick stays at  0 position
                if(self.riskyMinute - minuteElapsed > 0)
                {
                    self.time.minutes = self.riskyMinute - minuteElapsed
                }else{
                    self.time.minutes = 0
                    if(self.isP0UserReacted != true){
                        WKInterfaceDevice.current().play(.failure)
                        self.isP0UserReacted = true // stop vibration
                        self.showRiskIndicator = true
                    }
                    
                }
                
                /// enable vibration when the app enters background mode
                if(minuteElapsed == self.nbPointMarks){
                    self.backgroundSession.stopWorkoutSession()
                }
            }
        }
    
    }
    
    func initStartDateTime(){
        self.startTime = Date()
        self.backgroundSession.startWorkoutSession()
    }
}

#if DEBUG
struct ContentView_Previews0 : PreviewProvider {
    static var previews: some View {
        Prototype0(topic: Topic.previewTopic)
    }
}
#endif



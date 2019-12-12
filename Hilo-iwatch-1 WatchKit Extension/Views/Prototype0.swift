import SwiftUI
import Combine
import WatchKit
import CoreData
import CloudKit

struct Prototype0 : View {
    let topic: Topic
    // -- for experiment only: hardcoded the moment of risk and prediction period
    @State public var nbPointMarks: Int = 20 // define number of prediction minutes
    @State public var riskyMinute: Int = 12
    @State private var showRiskIndicator: Bool = true
    @State private var isStayAlarmed: Bool = false


    @State(initialValue: ClockModel())
    private var time: ClockModel
    
    @State private var clockIndicatorLength: CGFloat = 0.93
    @State private var isP0UserReacted: Bool = false
    @State private var startTime: Date = Date()
    @State private var isFirstLoad = true
     

    
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
                        if(newItem.p0UserReaction != 0){ // user reacts to the interface 0=false
                            self.isP0UserReacted = true
                            self.showRiskIndicator = false
                        }
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                }
                

                let minuteElapsed = Calendar.current
                    .dateComponents([.minute], from: self.startTime, to: Date())
                    .minute!
                
                if(self.riskyMinute - minuteElapsed > 0)
                {
                    self.time.minutes = self.riskyMinute - minuteElapsed
                }else{
                    self.time.minutes = 0
                    if(self.isP0UserReacted != true){
                        WKInterfaceDevice.current().play(.stop)
                        self.isP0UserReacted = true // stop vibration
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

#if DEBUG
struct ContentView_Previews0 : PreviewProvider {
    static var previews: some View {
        Prototype0(topic: Topic.previewTopic)
    }
}
#endif



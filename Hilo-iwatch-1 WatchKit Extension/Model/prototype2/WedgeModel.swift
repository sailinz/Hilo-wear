//
//  WedgeModel.swift
//  Hilo-iwatch-1 WatchKit Extension
//
//  Created by ZHONG Sailin on 04.12.19.
//  Copyright © 2019 ZHONG Sailin. All rights reserved.
//

import SwiftUI
import Combine

/// The data model for a single chart ring.
//class Ring: ObservableObject {
class Ring: ObservableObject {
    /// A single wedge within a chart ring.
    
    let scaleFactor = 0.95 //to adjust the wedge length
    struct Wedge: Equatable {
        /// The wedge's width, as an angle in radians.
        var width: Double
        /// The wedge's cross-axis depth, in range [0,1].
        var depth: Double
        /// The ring's hue.
        var hue: Double
        
        /// if this wedge is a high risk indicator
        var isRiskIndicator: Bool = false

        /// The wedge's start location, as an angle in radians.
        fileprivate(set) var start = 0.0
        /// The wedge's end location, as an angle in radians.
        fileprivate(set) var end = 0.0

        static var random: Wedge {
            return Wedge(
//                width: .random(in: 0.5 ... 1),
                width: 1,
                depth: .random(in: 0.2 ... 1), // -> certainty
                hue: .random(in: 0 ... 1)) // -> risk; to be changed
        }
    }

    /// The collection of wedges, tracked by their id.
    var wedges: [Int: Wedge] {
        get {
            if _wedgesNeedUpdate {
                /// Recalculate locations, to pack within circle.
                let total = wedgeIDs.reduce(0.0) { $0 + _wedges[$1]!.width }
                let scaleFactor = Double(wedgeIDs.count) / 60.0 // total portion of the circle that should have wadges
                let scale = (.pi * 2 * scaleFactor) / max(.pi * 2 * scaleFactor, total)
                var location = 0.0
                for id in wedgeIDs {
                    var wedge = _wedges[id]!
                    wedge.start = location * scale - Double.pi/2 // addjust to clock 0
                    location += wedge.width
                    wedge.end = location * scale - Double.pi/2 // addjust to clock 0
                    _wedges[id] = wedge
                }
                _wedgesNeedUpdate = false
            }
            return _wedges
        }
        set {
            objectWillChange.send()
            _wedges = newValue
            _wedgesNeedUpdate = true
        }
    }

    private var _wedges = [Int: Wedge]()
    private var _wedgesNeedUpdate = false

    /// The display order of the wedges.
    private(set) var wedgeIDs = [Int]() {
        willSet {
            objectWillChange.send()
        }
    }


    /// The next id to allocate.
    private var nextID = 0

    /// Trivial publisher for our changes.
    let objectWillChange = PassthroughSubject<Void, Never>()

    /// Adds a new wedge description to `array`.
    func addWedge(_ value: Wedge) {
        let id = nextID
        nextID += 1
        wedges[id] = value
        wedgeIDs.append(id)
    }

    /// Removes the wedge with `id`.
    func removeWedge(id: Int) {
        if let indexToRemove = wedgeIDs.firstIndex(where: { $0 == id }) {
            wedgeIDs.remove(at: indexToRemove)
            wedges.removeValue(forKey: id)
        }
    }
    
    /// When user react to the interface, the air quality change to positive (green)
    func updateWedgesColor(){
        for id in wedgeIDs {
            wedges[id]!.depth = Double.random(in: 0.7 ..< 0.95) * scaleFactor
            wedges[id]!.hue = 0.37 //(green)
            wedges[id]!.isRiskIndicator = false // no risk
        }
    }
    
    func updateWedgeColor(id: Int, co2Value: Int, certainty: Double){
        
        
        wedges[id]!.depth = certainty * scaleFactor//Double.random(in: 0.7 ..< 0.95) * 0.95
        
        if(co2Value < 600){
            wedges[id]!.hue = 0.37 //(green)
        }else if(co2Value >= 600 && co2Value < 1000){
            wedges[id]!.hue = 0.16 //(yellow)
        }else{
            wedges[id]!.hue = 0.0 //(red)
        }
        
        if(id >= 1){
            if(wedges[id - 1]!.hue > 0.0){
                wedges[id]!.isRiskIndicator = false // no risk
            }else{
                wedges[id]!.isRiskIndicator = true // no risk
            }
        }
        

//        if(certainty <= 0.95){
//            wedges[id]!.isRiskIndicator = false // no risk
//        }else{
//            wedges[id]!.isRiskIndicator = true // no risk
//        }
    }
    
    func randomizeWedgeDepth(){
        for id in wedgeIDs {
            if(wedges[id]!.isRiskIndicator == false){
                wedges[id]!.depth = Double.random(in: 0.7 ..< 0.9) * 0.95
            }
        }
    }

    /// Clear all data.
    func reset() {
        if !wedgeIDs.isEmpty {
            nextID = 0
            wedgeIDs = []
            wedges = [:]
        }
    }


}




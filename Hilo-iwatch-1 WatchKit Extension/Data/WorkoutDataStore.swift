//
//  WorkoutDataStore.swift
//  Hilo-iwatch-1 WatchKit Extension
//
//  Created by ZHONG Sailin on 15.12.19.
//  Copyright © 2019 ZHONG Sailin. All rights reserved.
//
// reference: https://www.raywenderlich.com/6992-healthkit-tutorial-with-swift-workouts

import Foundation
import Combine
import HealthKit

struct WorkoutDataStore {
    
    var builder: HKLiveWorkoutBuilder
    var session: HKWorkoutSession
    
    init(){
        let healthStore = HKHealthStore()
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .other
        
        session = try! HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
        builder = session.associatedWorkoutBuilder()
    }
    
        func startWorkoutSession(){
            
            session.startActivity(with: Date())
            builder.beginCollection(withStart: Date()) { (success, error) in
                
                guard success else {
                    return
                }
                // Indicate that the session has started.
            }
            
        }
    
        func stopWorkoutSession(){
            session.end()
            builder.endCollection(withEnd: Date()) { (success, error) in
                
                guard success else {
                    return
                }
                self.builder.finishWorkout { (workout, error) in
                    
                    guard workout != nil else {
                        return
                    }
                    
                }
            }
        }
    
//    var builder:HKWorkoutBuilder
//
//    init() {
//        let healthStore = HKHealthStore()
//        let workoutConfiguration = HKWorkoutConfiguration()
//        workoutConfiguration.activityType = .other
//
//        builder = HKWorkoutBuilder(healthStore: healthStore,
//            configuration: workoutConfiguration,
//            device: .local())
//    }
//
//    func startWorkoutSession(){
//        builder.beginCollection(withStart: Date()) { (success, error) in
//          guard success else {
//            return
//          }
//        }
//    }
//
//    func stopWorkoutSession(){
//        builder.discardWorkout()
//    }
  
  }
  
  
  

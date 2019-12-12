//
//  ClockModel.swift
//  Hilo-iwatch-1 WatchKit Extension
//
//  Created by ZHONG Sailin on 03.12.19.
//  Copyright © 2019 ZHONG Sailin. All rights reserved.
//

import Foundation
import Combine
import SwiftUI



struct ClockModel {
    var minutes : Int
    
    init() {
        minutes = 12 //hardcoded: this is a a walkaround as of now because the initialization couldn't be passed through
    }
}

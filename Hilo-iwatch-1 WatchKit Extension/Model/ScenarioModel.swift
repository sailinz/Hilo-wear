//
//  ScenarioModel.swift
//  Hilo-iwatch-1 WatchKit Extension
//
//  Created by ZHONG Sailin on 02.12.19.
//  Copyright © 2019 ZHONG Sailin. All rights reserved.
//

import Foundation

/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The PopQuiz flash card model which represents a list of topics that can be
 studied and questions for each topic.
*/

import Combine
import UIKit

extension Int: Identifiable {
    public var id: Int {
        self
    }
}

/// A topic that users can study.
struct Topic: Identifiable {
    let title: String
    let color: UIColor

    var id: String {
        title
    }
}

class ScenarioModel: ObservableObject {
    /// An array of topics that the user is currently studying.
    @Published var topics: [Topic] = [
        Topic(title: "Prototype 0",
              color: #colorLiteral(red: 150.0 / 255.0, green: 10.0 / 255.0,
                                   blue: 47.0 / 255.0, alpha: 1.0)
              
        ),
        
        Topic(title: "Prototype 1",
              color: #colorLiteral(red: 153.0 / 255.0, green: 35.0 / 255.0,
                                   blue: 29.0 / 255.0, alpha: 1.0)
              
        ),
        
        Topic(title: "Prototype 2",
              color: #colorLiteral(red: 153.0 / 255.0, green: 89.0 / 255.0,
                                   blue: 0.0, alpha: 1.0)
              
        )

    ]

}


extension Topic {
    /// A sample topic used in the preview.
    static let previewTopic = Topic(title: "Prototype 1",
        color: .white)
}

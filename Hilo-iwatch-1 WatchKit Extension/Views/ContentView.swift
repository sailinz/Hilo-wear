//
//  ContentView.swift
//  Hilo-iwatch-1 WatchKit Extension
//
//  Created by ZHONG Sailin on 08.11.19.
//  Copyright © 2019 ZHONG Sailin. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var model: ScenarioModel

    var body: some View {
        
        List {
            NavigationLink(destination:
                Prototype0(topic: model.topics[0])) {
                TopicCell(topic: model.topics[0])
                    .frame(height: 100.0)
            }
            .listRowPlatterColor(Color(model.topics[0].color))
            
            NavigationLink(destination:
                Prototype1(topic: model.topics[1])) {
                TopicCell(topic: model.topics[1])
                    .frame(height: 100.0)
            }
            .listRowPlatterColor(Color(model.topics[1].color))
            
            NavigationLink(destination:
                Prototype2(topic: model.topics[2])) {
                TopicCell(topic: model.topics[2])
                    .frame(height: 100.0)
            }
            .listRowPlatterColor(Color(model.topics[2].color))


        }
        .listStyle(CarouselListStyle())
        .navigationBarTitle(Text("Air Quality Forecast"))
    }


}

struct TopicCell: View {
    var topic: Topic

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(topic.title)
                    .font(.system(.headline, design: .rounded))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: ScenarioModel())
    }
}

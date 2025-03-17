//
//  ContentView.swift
//  ClockBurn
//
//  Created by Kevin on 2025/3/14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // 计时器页面
            TimerView()
                .tabItem {
                    Image(systemName: "timer")
                    Text("计时器")
                }
            
            // 世界时钟页面
            WorldClockView()
                .tabItem {
                    Image(systemName: "globe")
                    Text("世界时钟")
                }
            
            // 闹钟页面
            AlarmView()
                .tabItem {
                    Image(systemName: "alarm")
                    Text("闹钟")
                }
        }
    }
}

#Preview {
    ContentView()
}

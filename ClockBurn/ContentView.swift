//
//  ContentView.swift
//  ClockBurn
//
//  Created by Kevin on 2025/3/14.
//

import SwiftUI

struct ContentView: View {
    @State private var currentTime = Date()
    @State private var elapsedTime: TimeInterval = 0
    @State private var isRunning = false
    @State private var laps: [TimeInterval] = []
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let stopwatchTimer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            // 时钟
            Text(timeString(from: currentTime))
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top, 20)
            
            // 码表
            Text(formatTime(elapsedTime))
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.vertical, 20)
            
            // 控制按钮
            HStack(spacing: 30) {
                Button(action: {
                    if isRunning {
                        stopTimer()
                    } else {
                        startTimer()
                    }
                }) {
                    Text(isRunning ? "停止" : "开始")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background(isRunning ? Color.red : Color.green)
                        .clipShape(Circle())
                }
                
                Button(action: {
                    if isRunning {
                        recordLap()
                    } else {
                        resetTimer()
                    }
                }) {
                    Text(isRunning ? "计圈" : "重设")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background(isRunning ? Color.blue : Color.orange)
                        .clipShape(Circle())
                }
            }
            .padding(.bottom, 20)
            
            // 计圈列表
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(laps.enumerated()), id: \.offset) { index, lap in
                        HStack {
                            Text("第\(index + 1)圈")
                                .font(.headline)
                            Spacer()
                            Text(formatTime(lap))
                                .font(.system(.body, design: .monospaced))
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .padding()
        .onReceive(timer) { input in
            currentTime = input
        }
        .onReceive(stopwatchTimer) { _ in
            if isRunning {
                elapsedTime += 0.01
            }
        }
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let milliseconds = Int((timeInterval * 100).truncatingRemainder(dividingBy: 100))
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
    
    private func startTimer() {
        isRunning = true
    }
    
    private func stopTimer() {
        isRunning = false
    }
    
    private func recordLap() {
        laps.append(elapsedTime)
    }
    
    private func resetTimer() {
        elapsedTime = 0
        laps.removeAll()
    }
}

#Preview {
    ContentView()
}

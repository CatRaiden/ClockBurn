import SwiftUI

struct TimerView: View {
    @State private var elapsedTime: TimeInterval = 0
    @State private var isRunning = false
    @State private var laps: [TimeInterval] = []
    let stopwatchTimer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
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
            .navigationTitle("计时器")
            .onReceive(stopwatchTimer) { _ in
                if isRunning {
                    elapsedTime += 0.01
                }
            }
        }
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
    TimerView()
} 
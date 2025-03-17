import SwiftUI

struct WorldClockView: View {
    @State private var currentTime = Date()
    @State private var showingAddTimeZone = false
    @State private var timeZones: [(name: String, identifier: String)] = [
        ("台北", "Asia/Taipei"),
        ("东京", "Asia/Tokyo"),
        ("伦敦", "Europe/London"),
        ("洛杉矶", "America/Los_Angeles")
    ]
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(timeZones, id: \.identifier) { timeZone in
                    HStack {
                        Text(timeZone.name)
                            .font(.headline)
                        Spacer()
                        Text(timeString(from: currentTime, timeZone: timeZone.identifier))
                            .font(.system(.body, design: .monospaced))
                    }
                    .padding(.vertical, 8)
                }
                .onDelete(perform: deleteTimeZone)
            }
            .navigationTitle("世界时钟")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddTimeZone = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTimeZone) {
                AddTimeZoneView(timeZones: $timeZones)
            }
            .onReceive(timer) { input in
                currentTime = input
            }
        }
    }
    
    private func timeString(from date: Date, timeZone: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: timeZone)
        return formatter.string(from: date)
    }
    
    private func deleteTimeZone(at offsets: IndexSet) {
        timeZones.remove(atOffsets: offsets)
    }
}

struct AddTimeZoneView: View {
    @Binding var timeZones: [(name: String, identifier: String)]
    @Environment(\.dismiss) var dismiss
    @State private var selectedTimeZone: TimeZone?
    @State private var customName: String = ""
    
    private let commonTimeZones: [(name: String, identifier: String)] = [
        ("纽约", "America/New_York"),
        ("巴黎", "Europe/Paris"),
        ("悉尼", "Australia/Sydney"),
        ("新加坡", "Asia/Singapore"),
        ("香港", "Asia/Hong_Kong"),
        ("首尔", "Asia/Seoul")
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("选择时区")) {
                    ForEach(commonTimeZones, id: \.identifier) { timeZone in
                        Button(action: {
                            selectedTimeZone = TimeZone(identifier: timeZone.identifier)
                            customName = timeZone.name
                        }) {
                            HStack {
                                Text(timeZone.name)
                                Spacer()
                                if selectedTimeZone?.identifier == timeZone.identifier {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("自定义名称")) {
                    TextField("输入名称", text: $customName)
                }
            }
            .navigationTitle("添加时区")
            .navigationBarItems(
                leading: Button("取消") {
                    dismiss()
                },
                trailing: Button("添加") {
                    if let timeZone = selectedTimeZone {
                        timeZones.append((customName, timeZone.identifier))
                        dismiss()
                    }
                }
                .disabled(selectedTimeZone == nil || customName.isEmpty)
            )
        }
    }
}

#Preview {
    WorldClockView()
} 
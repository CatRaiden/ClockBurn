import SwiftUI

struct AlarmView: View {
    @State private var alarms: [Alarm] = []
    @State private var showingAddAlarm = false
    @State private var selectedTime = Date()
    @State private var isEditing = false
    @State private var selectedAlarms: Set<UUID> = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(alarms) { alarm in
                    AlarmRow(alarm: alarm, isEditing: isEditing, isSelected: selectedAlarms.contains(alarm.id))
                        .onTapGesture {
                            if isEditing {
                                if selectedAlarms.contains(alarm.id) {
                                    selectedAlarms.remove(alarm.id)
                                } else {
                                    selectedAlarms.insert(alarm.id)
                                }
                            }
                        }
                }
            }
            .navigationTitle("闹钟")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            isEditing.toggle()
                            if !isEditing {
                                selectedAlarms.removeAll()
                            }
                        }) {
                            Text(isEditing ? "完成" : "编辑")
                        }
                        
                        if isEditing {
                            Button(action: {
                                deleteSelectedAlarms()
                            }) {
                                Text("删除")
                                    .foregroundColor(.red)
                            }
                            .disabled(selectedAlarms.isEmpty)
                        } else {
                            Button(action: {
                                showingAddAlarm = true
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddAlarm) {
                AddAlarmView(alarms: $alarms, selectedTime: $selectedTime)
            }
        }
    }
    
    private func deleteSelectedAlarms() {
        alarms.removeAll { alarm in
            selectedAlarms.contains(alarm.id)
        }
        selectedAlarms.removeAll()
    }
}

struct Alarm: Identifiable {
    let id = UUID()
    let time: Date
    var isEnabled: Bool
    var label: String
}

struct AlarmRow: View {
    let alarm: Alarm
    let isEditing: Bool
    let isSelected: Bool
    
    var body: some View {
        HStack {
            if isEditing {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                    .font(.title2)
            }
            
            VStack(alignment: .leading) {
                Text(timeString(from: alarm.time))
                    .font(.title2)
                    .fontWeight(.bold)
                Text(alarm.label)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if !isEditing {
                Toggle("", isOn: .constant(alarm.isEnabled))
            }
        }
        .padding(.vertical, 8)
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct AddAlarmView: View {
    @Binding var alarms: [Alarm]
    @Binding var selectedTime: Date
    @Environment(\.dismiss) var dismiss
    @State private var label: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("时间", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                }
                
                Section {
                    TextField("标签", text: $label)
                }
            }
            .navigationTitle("添加闹钟")
            .navigationBarItems(
                leading: Button("取消") {
                    dismiss()
                },
                trailing: Button("保存") {
                    let newAlarm = Alarm(time: selectedTime, isEnabled: true, label: label)
                    alarms.append(newAlarm)
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    AlarmView()
} 
//
//  SettingsView.swift
//  Workout_App
//
//  Created by Landon Hollis on 1/26/25.
//

struct SettingsView: View {
    @EnvironmentObject private var userManager: UserManager
    @State private var showingReminderSheet = false
    @State private var showingColorPicker = false
    
    private let accentColors = ["blue", "red", "green", "purple", "orange", "pink"]
    
    var body: some View {
        List {
            // Appearance Section
            Section("Appearance") {
                // Theme Toggle
                Picker("Theme", selection: Binding(
                    get: { userManager.preferences.theme },
                    set: { userManager.updateTheme($0) }
                )) {
                    Text("Light").tag(AppTheme.light)
                    Text("Dark").tag(AppTheme.dark)
                }
                .pickerStyle(.segmented)
                
                // Custom Image Toggle
                Toggle("Enable Custom Images", isOn: Binding(
                    get: { userManager.preferences.isCustomImageEnabled },
                    set: { userManager.updateCustomImageEnabled($0) }
                ))
                
                // Accent Color
                HStack {
                    Text("Accent Color")
                    Spacer()
                    Circle()
                        .fill(Color(userManager.preferences.accentColor))
                        .frame(width: 25, height: 25)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    showingColorPicker = true
                }
            }
            
            // Reminders Section
            Section("Workout Reminders") {
                Toggle("Enable Reminders", isOn: Binding(
                    get: { userManager.preferences.isRemindersEnabled },
                    set: { userManager.updateReminderSettings(enabled: $0) }
                ))
                
                if userManager.preferences.isRemindersEnabled {
                    Button("Configure Reminders") {
                        showingReminderSheet = true
                    }
                    
                    // Show current reminder settings
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Current Schedule:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(formatReminderDays(userManager.preferences.reminderDays))
                            .font(.caption2)
                        
                        Text("Time: \(formatReminderTime(userManager.preferences.reminderTime))")
                            .font(.caption2)
                    }
                }
            }
            
            // Haptics Section
            Section("Feedback") {
                Toggle("Haptic Feedback", isOn: Binding(
                    get: { userManager.preferences.isHapticsEnabled },
                    set: { userManager.toggleHaptics($0) }
                ))
            }
            
            // App Info Section
            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(Bundle.main.appVersionString)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Settings")
        .sheet(isPresented: $showingReminderSheet) {
            ReminderSettingsView()
        }
        .sheet(isPresented: $showingColorPicker) {
            ColorPickerView(
                selectedColor: Binding(
                    get: { userManager.preferences.accentColor },
                    set: { userManager.updateAccentColor($0) }
                ),
                colors: accentColors
            )
        }
    }
    
    private func formatReminderDays(_ days: Set<DayOfWeek>) -> String {
        days.sorted { $0.rawValue < $1.rawValue }
            .map { $0.displayName }
            .joined(separator: ", ")
    }
    
    private func formatReminderTime(_ time: ReminderTime) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time.date)
    }
}

struct ReminderSettingsView: View {
    @EnvironmentObject private var userManager: UserManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDays: Set<DayOfWeek>
    @State private var selectedTime: Date
    
    init() {
        _selectedDays = State(initialValue: UserManager.shared.preferences.reminderDays)
        _selectedTime = State(initialValue: UserManager.shared.preferences.reminderTime.date)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Reminder Days") {
                    ForEach(DayOfWeek.allCases, id: \.self) { day in
                        Toggle(day.displayName, isOn: Binding(
                            get: { selectedDays.contains(day) },
                            set: { isSelected in
                                if isSelected {
                                    selectedDays.insert(day)
                                } else {
                                    selectedDays.remove(day)
                                }
                            }
                        ))
                    }
                }
                
                Section("Reminder Time") {
                    DatePicker(
                        "Time",
                        selection: $selectedTime,
                        displayedComponents: .hourAndMinute
                    )
                }
            }
            .navigationTitle("Configure Reminders")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        userManager.updateReminderSettings(
                            enabled: true,
                            days: selectedDays,
                            time: ReminderTime(date: selectedTime)
                        )
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ColorPickerView: View {
    @Binding var selectedColor: String
    let colors: [String]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(colors, id: \.self) { color in
                    HStack {
                        Circle()
                            .fill(Color(color))
                            .frame(width: 30, height: 30)
                        
                        Text(color.capitalized)
                            .padding(.leading)
                        
                        Spacer()
                        
                        if color == selectedColor {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedColor = color
                        dismiss()
                    }
                }
            }
            .navigationTitle("Select Color")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Helper extension for app version
extension Bundle {
    var appVersionString: String {
        let version = infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}


//
//  UserModels.swift
//  Workout_App
//
//  Created by Landon Hollis on 1/26/25.
//

import Foundation

struct UserPreferences: Codable {
    let id: UUID
    var isCustomImageEnabled: Bool
    var theme: AppTheme
    var accentColor: String
    var isRemindersEnabled: Bool
    var reminderDays: Set<DayOfWeek>
    var reminderTime: ReminderTime
    var isHapticsEnabled: Bool
    
    static let defaultReminderTime: ReminderTime = {
        ReminderTime.from(date: {
            var components = DateComponents()
            components.hour = 8
            components.minute = 0
            return Calendar.current.date(from: components) ?? Date()
        }())
    }()
    
    static let `default` = UserPreferences(
        id: UUID(),
        isCustomImageEnabled: false,
        theme: .light,
        accentColor: "blue",
        isRemindersEnabled: true,
        reminderDays: Set(DayOfWeek.allCases),  // All days by default
        reminderTime: defaultReminderTime,
        isHapticsEnabled: true
    )
    
    // UserDefaults keys
    private static let preferencesKey = "userPreferences"
    
    // Save to UserDefaults
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: Self.preferencesKey)
        }
    }
    
    // Load from UserDefaults
    static func load() -> UserPreferences {
        guard 
            let data = UserDefaults.standard.data(forKey: preferencesKey),
            let preferences = try? JSONDecoder().decode(UserPreferences.self, from: data)
        else {
            return .default
        }
        return preferences
    }
    
    // Computed property for current theme
    var isDarkMode: Bool {
        theme == .dark
    }
}

enum AppTheme: String, Codable, CaseIterable {
    case light
    case dark
}

enum WorkoutType: String, CaseIterable {
    case strength = "Strength"
    case cardio = "Cardio"
    case hiit = "HIIT"
    case flexibility = "Flexibility"
}

enum MuscleGroup: String, CaseIterable {
    case chest = "Chest"
    case back = "Back"
    case legs = "Legs"
    case shoulders = "Shoulders"
    case arms = "Arms"
    case core = "Core"
}

enum DayOfWeek: String, CaseIterable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
}

enum ReminderTime: String, Codable, CaseIterable {
    // Generate cases for every 30 minutes
    private static let allTimes: [ReminderTime] = {
        var times: [ReminderTime] = []
        for hour in 0...23 {
            for minute in stride(from: 0, to: 60, by: 30) {
                let timeString = String(format: "%02d:%02d", hour, minute)
                times.append(ReminderTime(rawValue: timeString)!)
            }
        }
        return times
    }()
    
    static var allCases: [ReminderTime] {
        return allTimes
    }
    
    // Convert raw string time to Date
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: self.rawValue) ?? Date()
    }
    
    // Convert Date to nearest ReminderTime
    static func from(date: Date) -> ReminderTime {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let roundedMinute = minute >= 30 ? 30 : 0
        let timeString = String(format: "%02d:%02d", hour, roundedMinute)
        return ReminderTime(rawValue: timeString) ?? ReminderTime.allCases[0]
    }
}

struct Exercise: Identifiable {
    let id = UUID()
    var name: String
    var muscleGroup: MuscleGroup
    var sets: Int
    var reps: Int
    var weight: Double
}

struct Workout: Identifiable {
    let id = UUID()
    var type: WorkoutType
    var muscleGroups: Set<MuscleGroup>
    var schedule: Set<DayOfWeek>
    var exercises: [Exercise]
}


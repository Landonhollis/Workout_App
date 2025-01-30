//
//  WorkoutModels.swift
//  Workout_App
//
//  Created by Landon Hollis on 1/26/25.
//

enum WorkoutType: String, Codable, CaseIterable {
    case cardio
    case push
    case pull
    case skip
}

enum MuscleGroup: String, Codable, CaseIterable {
    case chest
    case arms
    case shoulders
    case back
    case core
    case legs
}

struct Workout: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: WorkoutType
    let muscleGroups: Set<MuscleGroup>
    let exercises: [Exercise]  // We'll define Exercise struct later
    let createdAt: Date
    let scheduledDays: Set<DayOfWeek>
    
    init(
        id: UUID = UUID(),
        name: String,
        type: WorkoutType,
        muscleGroups: Set<MuscleGroup>,
        exercises: [Exercise],
        createdAt: Date = Date(),
        scheduledDays: Set<DayOfWeek> = []
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.muscleGroups = muscleGroups
        self.exercises = exercises
        self.createdAt = createdAt
        self.scheduledDays = scheduledDays
    }
}

struct Exercise: Identifiable, Codable {
    let id: UUID
    let name: String
    let repInfo: String
    
    init(
        id: UUID = UUID(),
        name: String,
        repInfo: String
    ) {
        self.id = id
        self.name = name
        self.repInfo = repInfo
    }
}

struct CompletedWorkout: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: WorkoutType
    let muscleGroups: Set<MuscleGroup>
    let startedAt: Date
    let completedAt: Date
    let exercises: [CompletedExercise]
    
    var duration: TimeInterval {
        completedAt.timeIntervalSince(startedAt)
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        type: WorkoutType,
        muscleGroups: Set<MuscleGroup>,
        startedAt: Date,
        completedAt: Date,
        exercises: [CompletedExercise]
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.muscleGroups = muscleGroups
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.exercises = exercises
    }
}

struct CompletedExercise: Identifiable, Codable {
    let id: UUID
    let name: String
    let isCompleted: Bool
    let duration: TimeInterval
    let repInfo: String
    
    init(
        id: UUID = UUID(),
        name: String,
        isCompleted: Bool,
        duration: TimeInterval,
        repInfo: String
    ) {
        self.id = id
        self.name = name
        self.isCompleted = isCompleted
        self.duration = duration
        self.repInfo = repInfo
    }
}

struct WorkoutStatistics: Identifiable, Codable {
    let id: UUID
    let totalWorkouts: Int
    let favoriteWorkoutType: WorkoutType
    let mostTargetedMuscle: MuscleGroup
    let workoutStreak: Int
    let lastWorkoutDate: Date
    
    init(
        id: UUID = UUID(),
        totalWorkouts: Int,
        favoriteWorkoutType: WorkoutType,
        mostTargetedMuscle: MuscleGroup,
        workoutStreak: Int,
        lastWorkoutDate: Date
    ) {
        self.id = id
        self.totalWorkouts = totalWorkouts
        self.favoriteWorkoutType = favoriteWorkoutType
        self.mostTargetedMuscle = mostTargetedMuscle
        self.workoutStreak = workoutStreak
        self.lastWorkoutDate = lastWorkoutDate
    }
}

extension WorkoutStatistics {
    // Calculate statistics from a collection of completed workouts
    static func calculate(from completedWorkouts: [CompletedWorkout]) -> WorkoutStatistics {
        let totalWorkouts = completedWorkouts.count
        
        // Find favorite workout type
        let workoutTypeCounts = completedWorkouts.reduce(into: [:]) { counts, workout in
            counts[workout.type, default: 0] += 1
        }
        let favoriteWorkoutType = workoutTypeCounts.max(by: { $0.value < $1.value })?.key ?? .cardio
        
        // Find most targeted muscle
        let muscleGroupCounts = completedWorkouts.reduce(into: [:]) { counts, workout in
            workout.muscleGroups.forEach { muscle in
                counts[muscle, default: 0] += 1
            }
        }
        let mostTargetedMuscle = muscleGroupCounts.max(by: { $0.value < $1.value })?.key ?? .chest
        
        // Calculate workout streak
        let streak = calculateStreak(from: completedWorkouts)
        
        // Get last workout date
        let lastWorkoutDate = completedWorkouts.max(by: { $0.completedAt < $1.completedAt })?.completedAt ?? Date()
        
        return WorkoutStatistics(
            totalWorkouts: totalWorkouts,
            favoriteWorkoutType: favoriteWorkoutType,
            mostTargetedMuscle: mostTargetedMuscle,
            workoutStreak: streak,
            lastWorkoutDate: lastWorkoutDate
        )
    }
    
    // Helper method to calculate current streak
    private static func calculateStreak(from completedWorkouts: [CompletedWorkout]) -> Int {
        guard !completedWorkouts.isEmpty else { return 0 }
        
        // Sort workouts by date, most recent first
        let sortedWorkouts = completedWorkouts.sorted { $0.completedAt > $1.completedAt }
        
        let calendar = Calendar.current
        var streak = 1
        var lastWorkoutDate = calendar.startOfDay(for: sortedWorkouts[0].completedAt)
        
        // Check consecutive days
        for i in 1..<sortedWorkouts.count {
            let currentWorkoutDate = calendar.startOfDay(for: sortedWorkouts[i].completedAt)
            let daysBetween = calendar.dateComponents([.day], from: currentWorkoutDate, to: lastWorkoutDate).day ?? 0
            
            if daysBetween == 1 {
                streak += 1
                lastWorkoutDate = currentWorkoutDate
            } else if daysBetween > 1 {
                break
            }
        }
        
        return streak
    }
    
    // UserDefaults keys
    private static let statisticsKey = "workoutStatistics"
    
    // Save to UserDefaults
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: Self.statisticsKey)
        }
    }
    
    // Load from UserDefaults
    static func load() -> WorkoutStatistics? {
        guard 
            let data = UserDefaults.standard.data(forKey: statisticsKey),
            let statistics = try? JSONDecoder().decode(WorkoutStatistics.self, from: data)
        else {
            return nil
        }
        return statistics
    }
}


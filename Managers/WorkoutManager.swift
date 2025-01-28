//
//  WorkoutManager.swift
//  Workout_App
//
//  Created by Landon Hollis on 1/26/25.
//

import Foundation

// Add this enum at the top of the file, outside the class
enum WorkoutManagerError: Error {
    case encodingFailed
    case decodingFailed
    case dataNotFound
    case invalidData
    
    var description: String {
        switch self {
        case .encodingFailed: return "Failed to encode workout data"
        case .decodingFailed: return "Failed to decode workout data"
        case .dataNotFound: return "No workout data found"
        case .invalidData: return "The workout data is invalid"
        }
    }
}

@MainActor
final class WorkoutManager: ObservableObject {
    // Storage keys with versioning
    private struct StorageKeys {
        static let version = "workoutDataVersion"
        static let savedWorkouts = "savedWorkouts_v1"
        static let completedWorkouts = "completedWorkouts_v1"
        static let statistics = "workoutStatistics_v1"
        static let currentWorkout = "currentWorkout_v1"
    }
    
    // Published properties
    @Published private(set) var savedWorkouts: [Workout] = []
    @Published private(set) var completedWorkouts: [CompletedWorkout] = []
    @Published private(set) var statistics: WorkoutStatistics?
    @Published private(set) var currentWorkout: Workout?
    @Published private(set) var workoutInProgress: Bool = false
    @Published private(set) var currentWorkoutStartTime: Date?
    @Published private(set) var lastError: Error?
    
    init() {
        migrateDataIfNeeded()
        loadWorkouts()
        updateStatistics()
        restoreWorkoutSession()
    }
    
    // MARK: - Active Workout Management
    
    func startWorkout(_ workout: Workout) {
        currentWorkout = workout
        currentWorkoutStartTime = Date()
        workoutInProgress = true
        persistWorkoutSession()
    }
    
    func endWorkout(with completedExercises: [CompletedExercise]) {
        guard let workout = currentWorkout, let startTime = currentWorkoutStartTime else {
            lastError = .invalidData
            return
        }
        
        let completedWorkout = CompletedWorkout(
            workoutType: workout.type,
            muscleGroups: workout.muscleGroups,
            workoutName: workout.title,
            startTime: startTime,
            endTime: Date(),
            completedExercises: completedExercises
        )
        
        completedWorkouts.append(completedWorkout)
        persistCompletedWorkouts()
        clearWorkoutSession()
        updateStatistics()
    }
    
    func cancelWorkout() {
        clearWorkoutSession()
    }
    
    private func clearWorkoutSession() {
        currentWorkout = nil
        currentWorkoutStartTime = nil
        workoutInProgress = false
        UserDefaults.standard.removeObject(forKey: StorageKeys.currentWorkout)
    }
    
    private func persistWorkoutSession() {
        guard let workout = currentWorkout, let startTime = currentWorkoutStartTime else { return }
        
        let sessionData = WorkoutSession(
            workout: workout,
            startTime: startTime
        )
        
        do {
            let encoded = try JSONEncoder().encode(sessionData)
            UserDefaults.standard.set(encoded, forKey: StorageKeys.currentWorkout)
        } catch {
            lastError = error
            // Notify user of save failure
            print("Failed to save workout session: \(error.localizedDescription)")
        }
    }
    
    private func restoreWorkoutSession() {
        guard let data = UserDefaults.standard.data(forKey: StorageKeys.currentWorkout),
              let session = try? JSONDecoder().decode(WorkoutSession.self, from: data) else {
            return
        }
        
        currentWorkout = session.workout
        currentWorkoutStartTime = session.startTime
        workoutInProgress = true
    }
    
    // MARK: - Data Migration
    
    private func migrateDataIfNeeded() {
        let currentVersion = UserDefaults.standard.integer(forKey: StorageKeys.version)
        
        // Add migration logic here when needed
        // Example:
        // if currentVersion < 1 {
        //     migrateToVersion1()
        //     UserDefaults.standard.set(1, forKey: StorageKeys.version)
        // }
    }
    
    // MARK: - Workout Management
    
    func saveWorkout(_ workout: Workout) {
        savedWorkouts.append(workout)
        persistSavedWorkouts()
    }
    
    func deleteWorkout(_ workout: Workout) {
        savedWorkouts.removeAll { $0.id == workout.id }
        persistSavedWorkouts()
    }
    
    // MARK: - Data Persistence
    
    private func loadWorkouts() {
        do {
            savedWorkouts = try loadSavedWorkouts()
            completedWorkouts = try loadCompletedWorkouts()
        } catch {
            lastError = error
            // Initialize with empty arrays if loading fails
            savedWorkouts = []
            completedWorkouts = []
        }
    }
    
    private func loadSavedWorkouts() throws -> [Workout] {
        guard let data = UserDefaults.standard.data(forKey: StorageKeys.savedWorkouts) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([Workout].self, from: data)
        } catch {
            throw WorkoutManagerError.decodingFailed
        }
    }
    
    private func loadCompletedWorkouts() throws -> [CompletedWorkout] {
        guard let data = UserDefaults.standard.data(forKey: StorageKeys.completedWorkouts) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([CompletedWorkout].self, from: data)
        } catch {
            throw WorkoutManagerError.decodingFailed
        }
    }
    
    private func persistSavedWorkouts() {
        do {
            let encoded = try JSONEncoder().encode(savedWorkouts)
            UserDefaults.standard.set(encoded, forKey: StorageKeys.savedWorkouts)
        } catch {
            lastError = error
            // Notify user of save failure
            print("Failed to save workouts: \(error.localizedDescription)")
        }
    }
    
    private func persistCompletedWorkouts() {
        do {
            let encoded = try JSONEncoder().encode(completedWorkouts)
            UserDefaults.standard.set(encoded, forKey: StorageKeys.completedWorkouts)
        } catch {
            lastError = error
            // Notify user of save failure
            print("Failed to save completed workouts: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Error Handling
    
    func clearError() {
        lastError = nil
    }
    
    // MARK: - Data Management
    
    func clearAllData() {
        UserDefaults.standard.removeObject(forKey: StorageKeys.savedWorkouts)
        UserDefaults.standard.removeObject(forKey: StorageKeys.completedWorkouts)
        savedWorkouts = []
        completedWorkouts = []
        statistics = nil
        updateStatistics()
    }
    
    func exportData() throws -> Data {
        let exportData = WorkoutExportData(
            savedWorkouts: savedWorkouts,
            completedWorkouts: completedWorkouts
        )
        return try JSONEncoder().encode(exportData)
    }
    
    func importData(_ data: Data) throws {
        do {
            let importedData = try JSONDecoder().decode(WorkoutExportData.self, from: data)
            savedWorkouts = importedData.savedWorkouts
            completedWorkouts = importedData.completedWorkouts
            persistSavedWorkouts()
            persistCompletedWorkouts()
            updateStatistics()
        } catch {
            throw WorkoutManagerError.invalidData
        }
    }
    
    // MARK: - Statistics
    
    private func updateStatistics() {
        statistics = WorkoutStatistics.calculate(from: completedWorkouts)
        statistics?.save()
    }
}

// Add this struct at the bottom of the file
private struct WorkoutExportData: Codable {
    let savedWorkouts: [Workout]
    let completedWorkouts: [CompletedWorkout]
}

// Add these supporting types at the bottom of the file
private struct WorkoutSession: Codable {
    let workout: Workout
    let startTime: Date
}


//
//  CreateWorkoutView.swift
//  Workout_App
//
//  Created by Landon Hollis on 1/26/25.
//

import SwiftUI

enum CreateWorkoutStep {
    case type
    case muscles
    case schedule
    case details
    case success
}

struct CreateWorkoutView: View {
    @StateObject private var workoutManager = WorkoutManager()
    @State private var workoutData = WorkoutCreationData()
    @State private var currentStep = 0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                switch currentStep {
                case 0:
                    WorkoutTypeView(
                        workoutData: $workoutData,
                        onNext: { currentStep += 1 }
                    )
                case 1:
                    MuscleSelectionView(
                        workoutData: $workoutData,
                        onNext: { currentStep += 1 },
                        onBack: { currentStep -= 1 }
                    )
                case 2:
                    ScheduleSelectionView(
                        workoutData: $workoutData,
                        onNext: { currentStep += 1 },
                        onBack: { currentStep -= 1 }
                    )
                case 3:
                    WorkoutDetailsView(
                        workoutData: $workoutData,
                        onBack: { currentStep -= 1 },
                        onComplete: {
                            saveWorkout()
                            dismiss()
                        }
                    )
                default:
                    EmptyView()
                }
            }
        }
    }
    
    private func saveWorkout() {
        let workout = Workout(
            name: workoutData.name,
            type: workoutData.type,
            muscleGroups: workoutData.muscleGroups,
            exercises: workoutData.exercises,
            scheduledDays: workoutData.scheduledDays
        )
        workoutManager.saveWorkout(workout)
    }
}

// Data model to hold workout creation state
struct WorkoutCreationData {
    var type: WorkoutType = .cardio  // Changed default to .cardio
    var muscleGroups: Set<MuscleGroup> = []
    var scheduledDays: Set<DayOfWeek> = []
    var name: String = ""
    var exercises: [Exercise] = []
    
    var isValid: Bool {
        !name.isEmpty  // Simplified since type will always have a value
    }
}

NavigationLink(destination: WorkoutTypeSelectionView(workoutData: $workoutData)) {
    HStack {
        Text("Workout Type")
        Spacer()
        Text(workoutData.workoutType?.rawValue ?? "Select")
            .foregroundColor(.gray)
    }
}


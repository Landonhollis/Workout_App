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
    @StateObject private var viewModel = CreateWorkoutViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink(destination: WorkoutTypeSelectionView(viewModel: viewModel)) {
                        HStack {
                            Text("Workout Type")
                            Spacer()
                            Text(viewModel.workoutType?.rawValue ?? "Select")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    NavigationLink(destination: MuscleSelectionView(viewModel: viewModel)) {
                        HStack {
                            Text("Muscle Groups")
                            Spacer()
                            Text(viewModel.selectedMuscleGroups.isEmpty ? "Select" : "\(viewModel.selectedMuscleGroups.count) selected")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    NavigationLink(destination: ScheduleSelectionView(viewModel: viewModel)) {
                        HStack {
                            Text("Schedule")
                            Spacer()
                            Text(viewModel.selectedDays.isEmpty ? "Select" : "\(viewModel.selectedDays.count) days")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: WorkoutDetailsView(viewModel: viewModel)) {
                        Text("Review Workout Details")
                    }
                }
            }
            .navigationTitle("Create Workout")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    viewModel.saveWorkout()
                    dismiss()
                }
                .disabled(!viewModel.isValid)
            )
        }
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


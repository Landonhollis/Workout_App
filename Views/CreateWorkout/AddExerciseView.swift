//
//  AddExerciseView.swift
//  Workout_App
//
//  Created by Landon Hollis on 1/26/25.
//

import SwiftUI

struct AddExerciseView: View {
    @ObservedObject var viewModel: CreateWorkoutViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var exerciseName = ""
    @State private var selectedMuscleGroup: MuscleGroup?
    @State private var sets = 3
    @State private var reps = 10
    @State private var weight: Double = 0.0
    
    var body: some View {
        NavigationView {
            Form {
                Section("Exercise Details") {
                    TextField("Exercise Name", text: $exerciseName)
                    
                    Picker("Muscle Group", selection: $selectedMuscleGroup) {
                        Text("Select").tag(nil as MuscleGroup?)
                        ForEach(MuscleGroup.allCases, id: \.self) { group in
                            Text(group.rawValue).tag(group as MuscleGroup?)
                        }
                    }
                }
                
                Section("Sets and Reps") {
                    Stepper("Sets: \(sets)", value: $sets, in: 1...10)
                    Stepper("Reps: \(reps)", value: $reps, in: 1...30)
                }
                
                Section("Weight (lbs)") {
                    TextField("Weight", value: $weight, format: .number)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    saveExercise()
                    dismiss()
                }
                .disabled(!isValid)
            )
        }
    }
    
    private var isValid: Bool {
        !exerciseName.isEmpty && selectedMuscleGroup != nil
    }
    
    private func saveExercise() {
        guard let muscleGroup = selectedMuscleGroup else { return }
        
        let exercise = Exercise(
            name: exerciseName,
            muscleGroup: muscleGroup,
            sets: sets,
            reps: reps,
            weight: weight
        )
        
        viewModel.exercises.append(exercise)
    }
}


//
//  ActiveWorkoutView.swift
//  Workout_App
//
//  Created by Landon Hollis on 1/26/25.
//

import SwiftUI

struct ActiveWorkoutView: View {
    let workout: Workout
    @State private var selectedExercise: Exercise?
    @State private var completedExercises: Set<UUID> = []
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var workoutManager: WorkoutManager
    
    @State private var showingCancelAlert = false
    @State private var showingFinishAlert = false
    @State private var showingSuccessView = false
    @State private var workoutStartTime = Date()
    
    var body: some View {
        ZStack {
            // Main workout view
            VStack(spacing: 0) {
                // Top Section - Navigation
                HStack {
                    Button("Back") {
                        showingCancelAlert = true
                    }
                    Spacer()
                    Button("Workout Finished") {
                        showingFinishAlert = true
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Middle Section - Selected Exercise
                VStack(spacing: 15) {
                    Text(selectedExercise?.name ?? workout.exercises.first?.name ?? "")
                        .font(.title)
                        .padding(.top)
                    
                    Text(selectedExercise?.repInfo ?? workout.exercises.first?.repInfo ?? "")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(height: UIScreen.main.bounds.height * 0.3)
                .frame(maxWidth: .infinity)
                .padding()
                
                // Bottom Section - Exercise List
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(workout.exercises) { exercise in
                            ExerciseRow(
                                exercise: exercise,
                                isCompleted: completedExercises.contains(exercise.id),
                                isSelected: selectedExercise?.id == exercise.id
                            )
                            .onTapGesture {
                                selectedExercise = exercise
                            }
                        }
                    }
                    .padding()
                }
            }
            
            // Success overlay
            if showingSuccessView {
                Color(.systemBackground)
                    .opacity(0.9)
                    .ignoresSafeArea()
                
                WorkoutSuccessView()
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: showingSuccessView)
        // Cancel workout alert
        .alert("Cancel Workout?", isPresented: $showingCancelAlert) {
            Button("Yes", role: .destructive) {
                dismiss()
            }
            Button("No", role: .cancel) {}
        } message: {
            Text("Are you sure you want to cancel this workout?")
        }
        // Finish workout alert
        .alert("Finish Workout?", isPresented: $showingFinishAlert) {
            Button("Yes") {
                completeWorkout()
            }
            Button("No, I accidentally clicked", role: .cancel) {}
        } message: {
            Text("Are you sure you want to finish this workout?")
        }
        .onAppear {
            selectedExercise = workout.exercises.first
        }
    }
    
    private func completeWorkout() {
        let duration = Date().timeIntervalSince(workoutStartTime)
        // Create completed exercises array with duration
        let completedExercisesList = workout.exercises.map { exercise in
            CompletedExercise(
                name: exercise.name,
                isCompleted: completedExercises.contains(exercise.id),
                duration: duration,
                repInfo: exercise.repInfo
            )
        }
        
        workoutManager.completeWorkout(workout, with: completedExercisesList)
        
        // Show success view and dismiss
        withAnimation {
            showingSuccessView = true
        }
        
        // Dismiss after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
}

struct ExerciseRow: View {
    let exercise: Exercise
    let isCompleted: Bool
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isCompleted ? .green : .gray)
            
            VStack(alignment: .leading) {
                Text(exercise.name)
                    .font(.headline)
                Text(exercise.repInfo)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "chevron.right")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}

// Success view component
struct WorkoutSuccessView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
                .padding()
            
            Text("Workout Saved")
                .font(.title2)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}


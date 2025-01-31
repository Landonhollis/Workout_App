import Foundation
import SwiftUI

class CreateWorkoutViewModel: ObservableObject {
    @Published var workoutType: WorkoutType?
    @Published var selectedMuscleGroups: Set<MuscleGroup> = []
    @Published var selectedDays: Set<DayOfWeek> = []
    @Published var exercises: [Exercise] = []
    
    var isValid: Bool {
        workoutType != nil && 
        !selectedMuscleGroups.isEmpty && 
        !selectedDays.isEmpty
    }
    
    func saveWorkout() {
        guard isValid else { return }
        
        let workout = Workout(
            type: workoutType!,
            muscleGroups: selectedMuscleGroups,
            schedule: selectedDays,
            exercises: exercises
        )
        
        // TODO: Add actual save logic here
        print("Saving workout: \(workout)")
    }
    
    func reset() {
        workoutType = nil
        selectedMuscleGroups.removeAll()
        selectedDays.removeAll()
        exercises.removeAll()
    }
} 
import Foundation
import SwiftUI

class CreateWorkoutViewModel: ObservableObject {
    @Published var workoutName: String = ""
    @Published var workoutType: WorkoutType?
    @Published var selectedMuscleGroups: Set<MuscleGroup> = []
    @Published var selectedDays: Set<DayOfWeek> = []
    @Published var exercises: [Exercise] = []
    
    var isValid: Bool {
        !workoutName.isEmpty &&
        workoutType != nil && 
        !selectedMuscleGroups.isEmpty && 
        !selectedDays.isEmpty
    }
    
    func saveWorkout() {
        guard isValid else { return }
        
        let workout = Workout(
            name: workoutName,
            type: workoutType!,
            muscleGroups: selectedMuscleGroups,
            schedule: selectedDays,
            exercises: exercises
        )
        
        // TODO: Add actual save logic here
        print("Saving workout: \(workout)")
    }
    
    func reset() {
        workoutName = ""
        workoutType = nil
        selectedMuscleGroups.removeAll()
        selectedDays.removeAll()
        exercises.removeAll()
    }
} 
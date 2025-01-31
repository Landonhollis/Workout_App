import Foundation

class CreateWorkoutViewModel: ObservableObject {
    @Published var workoutType: WorkoutType?
    @Published var selectedMuscleGroups: Set<MuscleGroup> = []
    @Published var selectedDays: Set<DayOfWeek> = []
    
    var isValid: Bool {
        workoutType != nil && 
        !selectedMuscleGroups.isEmpty && 
        !selectedDays.isEmpty
    }
    
    func saveWorkout() {
        // Your save logic here
    }
} 
class WorkoutProgressViewModel: ObservableObject {
    @Published var completedExercises: Set<UUID> = []  // Exercise IDs
    
    func toggleExercise(_ exerciseId: UUID) {
        if completedExercises.contains(exerciseId) {
            completedExercises.remove(exerciseId)
        } else {
            completedExercises.insert(exerciseId)
        }
    }
    
    func resetProgress() {
        completedExercises.removeAll()
    }
} 
struct WorkoutCreationData {
    var workoutType: WorkoutType?
    var muscleGroups: Set<MuscleGroup> = []
    var schedule: Set<DayOfWeek> = []
    // ... any other properties ...
} 
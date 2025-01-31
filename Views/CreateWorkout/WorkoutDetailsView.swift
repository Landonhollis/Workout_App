import: SwiftUI

struct WorkoutDetailsView: View {
    @Binding var workoutData: WorkoutCreationData
    let onBack: () -> Void
    let onComplete: () -> Void
    
    @State private var exerciseName = ""
    @State private var exerciseRepInfo = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Workout Name", text: $workoutData.name)
                .textFieldStyle(.roundedBorder)
                .font(.title2)
                .padding()
            
            Divider()
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(workoutData.exercises) { exercise in
                        ExerciseRow(exercise: exercise) {
                            workoutData.exercises.removeAll { $0.id == exercise.id }
                        }
                    }
                    
                    AddExerciseSection(
                        name: $exerciseName,
                        repInfo: $exerciseRepInfo,
                        onAdd: {
                            let exercise = Exercise(
                                name: exerciseName,
                                repInfo: exerciseRepInfo
                            )
                            workoutData.exercises.append(exercise)
                            exerciseName = ""
                            exerciseRepInfo = ""
                        }
                    )
                }
                .padding()
            }
            
            Button("Create Workout") {
                onComplete()
            }
            .buttonStyle(.borderedProminent)
            .disabled(workoutData.name.isEmpty)
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back", action: onBack)
            }
        }
    }
}

struct ExerciseRow: View {
    let exercise: Exercise
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(exercise.name)
                    .font(.headline)
                Text(exercise.repInfo)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

struct AddExerciseSection: View {
    @Binding var name: String
    @Binding var repInfo: String
    let onAdd: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            TextField("Exercise Name", text: $name)
                .textFieldStyle(.roundedBorder)
            
            TextField("Reps (e.g., 3x12)", text: $repInfo)
                .textFieldStyle(.roundedBorder)
            
            Button("Add Exercise") {
                onAdd()
            }
            .disabled(name.isEmpty || repInfo.isEmpty)
        }
    }
} 

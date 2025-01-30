struct WorkoutListView: View {
    @EnvironmentObject private var workoutManager: WorkoutManager
    @State private var isEditMode = false
    @State private var workoutToDelete: Workout?
    @State private var showingDeleteAlert = false
    @State private var selectedWorkout: Workout?
    @State private var isShowingStartTransition = false
    @State private var isShowingActiveWorkout = false
    
    var body: some View {
        VStack {
            Text("Workouts")
                .font(.title)
                .padding(.top)
            
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(workoutManager.savedWorkouts) { workout in
                        WorkoutCard(workout: workout)
                            .onTapGesture {
                                if isEditMode {
                                    // Navigate to edit workout
                                } else {
                                    startWorkout(workout)
                                }
                            }
                            .onLongPressGesture {
                                workoutToDelete = workout
                                showingDeleteAlert = true
                            }
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditMode ? "Done" : "Edit") {
                    isEditMode.toggle()
                }
            }
        }
        .alert("Delete Workout", isPresented: $showingDeleteAlert, presenting: workoutToDelete) { workout in
            Button("Delete", role: .destructive) {
                workoutManager.deleteWorkout(workout)
            }
            Button("Cancel", role: .cancel) {}
        } message: { workout in
            Text("Are you sure you want to delete '\(workout.name)'?")
        }
        .fullScreenCover(isPresented: $isShowingStartTransition, content: {
            if let workout = selectedWorkout {
                WorkoutStartView(
                    workout: workout,
                    isShowingWorkout: $isShowingActiveWorkout
                )
            }
        })
        .fullScreenCover(isPresented: $isShowingActiveWorkout) {
            if let workout = selectedWorkout {
                ActiveWorkoutView(workout: workout)
            }
        }
    }
    
    private func startWorkout(_ workout: Workout) {
        selectedWorkout = workout
        isShowingStartTransition = true
    }
}

struct WorkoutCard: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(workout.name)
                .font(.headline)
            
            HStack {
                Label(workout.type.rawValue.capitalized, systemImage: "figure.run")
                Spacer()
                Text(workout.muscleGroups.map { $0.rawValue.capitalized }.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if !workout.scheduledDays.isEmpty {
                Text(formatScheduledDays(workout.scheduledDays))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    
    private func formatScheduledDays(_ days: Set<DayOfWeek>) -> String {
        "Scheduled: " + days.sorted { $0.rawValue < $1.rawValue }
            .map { $0.displayName }
            .joined(separator: ", ")
    }
} 
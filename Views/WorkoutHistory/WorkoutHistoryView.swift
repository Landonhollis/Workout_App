struct WorkoutHistoryView: View {
    @EnvironmentObject private var workoutManager: WorkoutManager
    @State private var selectedWorkout: CompletedWorkout?
    @State private var isShowingWorkoutDetail = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Statistics Section
                StatisticsSection(statistics: workoutManager.statistics)
                    .padding()
                    .background(Color(.systemBackground))
                
                // History List Section
                LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(workoutManager.completedWorkouts.sorted(by: { $0.completedAt > $1.completedAt })) { workout in
                            WorkoutHistoryCard(workout: workout)
                                .onTapGesture {
                                    selectedWorkout = workout
                                    isShowingWorkoutDetail = true
                                }
                        }
                    } header: {
                        Text("Completed Workouts")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.systemBackground))
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Workout History")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingWorkoutDetail) {
            if let workout = selectedWorkout {
                WorkoutDetailView(workout: workout)
            }
        }
    }
}

struct StatisticsSection: View {
    let statistics: WorkoutStatistics?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Statistics")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                StatCard(title: "Total Workouts", value: "\(statistics?.totalWorkouts ?? 0)")
                StatCard(title: "This Month", value: "\(statistics?.workoutsThisMonth ?? 0)")
                StatCard(title: "Streak", value: "\(statistics?.currentStreak ?? 0) days")
                StatCard(title: "Best Streak", value: "\(statistics?.bestStreak ?? 0) days")
            }
            
            // Most common stats
            VStack(alignment: .leading, spacing: 10) {
                if let commonType = statistics?.mostCommonType {
                    Text("Favorite Type: \(commonType.rawValue.capitalized)")
                }
                if let commonMuscle = statistics?.mostCommonMuscleGroup {
                    Text("Most Trained: \(commonMuscle.rawValue.capitalized)")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct WorkoutHistoryCard: View {
    let workout: CompletedWorkout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Date and Duration
            HStack {
                Text(formatDate(workout.completedAt))
                    .font(.headline)
                Spacer()
                Text(formatDuration(workout.duration))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Type and Muscle Groups
            HStack {
                Label(workout.type.rawValue.capitalized, systemImage: "figure.run")
                    .font(.subheadline)
                Spacer()
                Text(workout.muscleGroups.map { $0.rawValue.capitalized }.joined(separator: ", "))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration / 60)
        return "\(minutes) min"
    }
} 
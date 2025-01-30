struct WorkoutTypeSelectionView: View {
    @Binding var workoutData: WorkoutCreationData  // Changed to @Binding
    
    var body: some View {
        List {
            ForEach(WorkoutType.allCases, id: \.self) { type in
                Button(action: {
                    workoutData.workoutType = type
                }) {
                    HStack {
                        Text(type.rawValue)
                        Spacer()
                        if workoutData.workoutType == type {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Workout Type")
    }
} 
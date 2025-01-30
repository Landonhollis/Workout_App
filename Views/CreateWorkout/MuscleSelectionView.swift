struct MuscleSelectionView: View {
    @Binding var workoutData: WorkoutCreationData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Target Muscle Groups")
                .font(.title)
                .padding(.top)
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(MuscleGroup.allCases, id: \.self) { muscle in
                        Toggle(muscle.rawValue.capitalized, isOn: Binding(
                            get: { workoutData.muscleGroups.contains(muscle) },
                            set: { isSelected in
                                if isSelected {
                                    workoutData.muscleGroups.insert(muscle)
                                } else {
                                    workoutData.muscleGroups.remove(muscle)
                                }
                            }
                        ))
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                    }
                }
            }
            
            Button("Continue") { onNext() }
                .buttonStyle(.borderedProminent)
                .padding()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back", action: onBack)
            }
        }
    }
} 
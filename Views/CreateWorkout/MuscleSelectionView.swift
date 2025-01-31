struct MuscleSelectionView: View {
    @ObservedObject var viewModel: CreateWorkoutViewModel
    
    var body: some View {
        List {
            ForEach(MuscleGroup.allCases, id: \.self) { muscleGroup in
                Button(action: {
                    if viewModel.selectedMuscleGroups.contains(muscleGroup) {
                        viewModel.selectedMuscleGroups.remove(muscleGroup)
                    } else {
                        viewModel.selectedMuscleGroups.insert(muscleGroup)
                    }
                }) {
                    HStack {
                        Text(muscleGroup.rawValue)
                        Spacer()
                        if viewModel.selectedMuscleGroups.contains(muscleGroup) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Muscle Groups")
    }
} 

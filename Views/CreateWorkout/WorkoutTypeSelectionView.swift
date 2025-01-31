import SwiftUI

struct WorkoutTypeSelectionView: View {
    @ObservedObject var viewModel: CreateWorkoutViewModel
    
    var body: some View {
        List {
            ForEach(WorkoutType.allCases, id: \.self) { type in
                Button(action: {
                    viewModel.workoutType = type
                }) {
                    HStack {
                        Text(type.rawValue)
                        Spacer()
                        if viewModel.workoutType == type {
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
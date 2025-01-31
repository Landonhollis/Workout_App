import SwiftUI

struct WorkoutDetailsView: View {
    @ObservedObject var viewModel: CreateWorkoutViewModel
    
    var body: some View {
        List {
            Section("Workout Type") {
                Text(viewModel.workoutType?.rawValue ?? "Not Selected")
            }
            
            Section("Muscle Groups") {
                if viewModel.selectedMuscleGroups.isEmpty {
                    Text("No muscle groups selected")
                } else {
                    ForEach(Array(viewModel.selectedMuscleGroups), id: \.self) { muscleGroup in
                        Text(muscleGroup.rawValue)
                    }
                }
            }
            
            Section("Schedule") {
                if viewModel.selectedDays.isEmpty {
                    Text("No days selected")
                } else {
                    ForEach(Array(viewModel.selectedDays), id: \.self) { day in
                        Text(day.rawValue)
                    }
                }
            }
        }
        .navigationTitle("Workout Details")
    }
} 

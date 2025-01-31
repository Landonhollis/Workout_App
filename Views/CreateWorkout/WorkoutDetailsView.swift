import SwiftUI

struct WorkoutDetailsView: View {
    @ObservedObject var viewModel: CreateWorkoutViewModel
    
    var body: some View {
        List {
            Section(header: Text("Workout Type")) {
                Text(viewModel.workoutType?.rawValue ?? "Not Selected")
            }
            
            Section(header: Text("Muscle Groups")) {
                ForEach(Array(viewModel.selectedMuscleGroups), id: \.self) { muscleGroup in
                    Text(muscleGroup.rawValue)
                }
            }
            
            Section(header: Text("Schedule")) {
                ForEach(Array(viewModel.selectedDays), id: \.self) { day in
                    Text(day.rawValue)
                }
            }
        }
        .navigationTitle("Workout Details")
    }
} 

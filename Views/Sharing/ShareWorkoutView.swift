import SwiftUI

struct ShareWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedWorkout: Workout?
    // This would come from your workout storage
    @State private var savedWorkouts: [Workout] = []
    
    var body: some View {
        NavigationView {
            List(savedWorkouts, selection: $selectedWorkout) { workout in
                VStack(alignment: .leading) {
                    Text(workout.name)
                        .font(.headline)
                    Text("\(workout.type.rawValue) • \(workout.muscleGroups.count) muscle groups")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Send to Gymbro")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Share") {
                    if let workout = selectedWorkout {
                        shareWorkout(workout)
                    }
                }
                .disabled(selectedWorkout == nil)
            )
        }
    }
    
    private func shareWorkout(_ workout: Workout) {
        // Get the current window's UIViewController
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let viewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        WorkoutSharingService.shared.shareWithFriend(
            workout: workout,
            from: viewController
        )
        
        dismiss()
    }
} 
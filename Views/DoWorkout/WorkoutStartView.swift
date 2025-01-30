struct WorkoutStartView: View {
    let workout: Workout
    @Binding var isShowingWorkout: Bool
    
    var body: some View {
        VStack {
            Image(systemName: "figure.run")
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .padding()
            
            Text("Workout Started")
                .font(.title)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isShowingWorkout = true
            }
        }
    }
} 
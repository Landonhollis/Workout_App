struct WorkoutSuccessView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
                .padding()
            
            Text("Workout Successfully Created")
                .font(.title2)
                .multilineTextAlignment(.center)
        }
    }
} 
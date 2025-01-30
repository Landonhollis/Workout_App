struct WorkoutTypeView: View {
    @Binding var workoutData: WorkoutCreationData
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Workout Type")
                .font(.title)
                .padding(.top)
            
            Spacer()
            
            ForEach(WorkoutType.allCases, id: \.self) { workoutType in
                Button {
                    workoutData.type = workoutType
                    onNext()
                } label: {
                    Text(workoutType.rawValue.capitalized)
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(false)
    }
} 
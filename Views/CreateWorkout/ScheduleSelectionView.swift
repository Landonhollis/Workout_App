struct ScheduleSelectionView: View {
    @Binding var workoutData: WorkoutCreationData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Schedule Workout")
                .font(.title)
                .padding(.top)
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(DayOfWeek.allCases, id: \.self) { day in
                        Toggle(day.displayName, isOn: Binding(
                            get: { workoutData.scheduledDays.contains(day) },
                            set: { isSelected in
                                if isSelected {
                                    workoutData.scheduledDays.insert(day)
                                } else {
                                    workoutData.scheduledDays.remove(day)
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
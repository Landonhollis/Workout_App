struct ScheduleSelectionView: View {
    @ObservedObject var viewModel: CreateWorkoutViewModel
    
    var body: some View {
        List {
            ForEach(DayOfWeek.allCases, id: \.self) { day in
                Button(action: {
                    if viewModel.selectedDays.contains(day) {
                        viewModel.selectedDays.remove(day)
                    } else {
                        viewModel.selectedDays.insert(day)
                    }
                }) {
                    HStack {
                        Text(day.rawValue)
                        Spacer()
                        if viewModel.selectedDays.contains(day) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Schedule")
    }
} 
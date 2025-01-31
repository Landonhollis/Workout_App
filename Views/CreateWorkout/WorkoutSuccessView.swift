import SwiftUI

struct WorkoutSuccessView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.green)
            
            Text("Workout Created!")
                .font(.title)
                .bold()
            
            Text("Your workout has been successfully created and saved.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            Button("Done") {
                dismiss()
            }
            .padding()
        }
        .padding()
    }
} 
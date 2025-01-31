import Foundation
import UIKit

class WorkoutSharingService {
    static let shared = WorkoutSharingService()
    private init() {}
    
    func shareWorkout(_ workout: Workout) -> String {
        let sharedWorkout = SharedWorkout(
            workout: workout,
            sharedDate: Date(),
            shareId: UUID().uuidString
        )
        
        // In a real app, you'd store this in a backend
        // For now, we'll create a deep link
        return createDeepLink(for: sharedWorkout)
    }
    
    private func createDeepLink(for workout: SharedWorkout) -> String {
        // Replace with your actual app scheme and domain
        return "workoutapp://share/workout/\(workout.shareId)"
    }
    
    func shareWithFriend(workout: Workout, from viewController: UIViewController) {
        let deepLink = shareWorkout(workout)
        let message = """
        Check out this workout I created!
        
        Download the app to view it:
        \(deepLink)
        """
        
        let activityVC = UIActivityViewController(
            activityItems: [message],
            applicationActivities: nil
        )
        
        viewController.present(activityVC, animated: true)
    }
} 
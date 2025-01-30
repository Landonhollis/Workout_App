@MainActor
final class AppManager {
    // Shared managers
    let workoutManager: WorkoutManager
    let userManager: UserManager
    let subscriptionManager: SubscriptionManager
    
    // Singleton instance
    static let shared = AppManager()
    
    private init() {
        // Initialize managers in the correct order
        userManager = UserManager()
        subscriptionManager = SubscriptionManager()
        workoutManager = WorkoutManager()
    }
    
    // MARK: - Manager Coordination
    
    func handleAppLaunch() async {
        // Check subscription status
        await subscriptionManager.checkSubscriptionStatus()
        
        // Load any preloaded workouts if needed
        if workoutManager.savedWorkouts.isEmpty {
            loadPreloadedWorkouts()
        }
    }
    
    private func loadPreloadedWorkouts() {
        // Load default workouts here
        let preloadedWorkouts: [Workout] = [
            // Add your preloaded workouts here
        ]
        
        for workout in preloadedWorkouts {
            workoutManager.saveWorkout(workout)
        }
    }
} 
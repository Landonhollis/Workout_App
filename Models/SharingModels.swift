import Foundation

struct SharedWorkout: Codable {
    let workout: Workout
    let sharedDate: Date
    let shareId: String  // For deep linking
} 
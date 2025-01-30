enum SubscriptionStatus: String, Codable {
    case none
    case trial
    case basic
    case premium
    
    var isSubscribed: Bool {
        self == .basic || self == .premium
    }
}

struct SubscriptionDetails: Codable {
    let status: SubscriptionStatus
    let expirationDate: Date?
    let trialEndDate: Date?
    
    var isTrialActive: Bool {
        guard let trialEnd = trialEndDate else { return false }
        return Date() < trialEnd
    }
} 
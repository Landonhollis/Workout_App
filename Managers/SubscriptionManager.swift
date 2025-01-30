//
//  SubscriptionManager.swift
//  Workout_App
//
//  Created by Landon Hollis on 1/26/25.
//

import Foundation
import StoreKit

@MainActor
final class SubscriptionManager: ObservableObject {
    private struct StorageKeys {
        static let subscriptionDetails = "subscriptionDetails_v1"
        static let lastCheckDate = "lastSubscriptionCheck_v1"
    }
    
    @Published private(set) var subscriptionDetails: SubscriptionDetails
    @Published private(set) var isLoading = false
    @Published private(set) var lastError: Error?
    
    private let calendar = Calendar.current
    private let defaults = UserDefaults.standard
    
    init() {
        // Load saved subscription details or use default
        if let data = defaults.data(forKey: StorageKeys.subscriptionDetails),
           let details = try? JSONDecoder().decode(SubscriptionDetails.self, from: data) {
            subscriptionDetails = details
        } else {
            // Default to no subscription
            subscriptionDetails = SubscriptionDetails(
                status: .none,
                expirationDate: nil,
                trialEndDate: nil
            )
        }
        
        // Check subscription status on launch
        Task {
            await checkSubscriptionStatus()
        }
    }
    
    // MARK: - Subscription Management
    
    func checkSubscriptionStatus() async {
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Implement StoreKit verification here
            // This is a placeholder for the actual implementation
            let status = await verifySubscription()
            subscriptionDetails = status
            saveSubscriptionDetails()
            
            defaults.set(Date(), forKey: StorageKeys.lastCheckDate)
            lastError = nil
        } catch {
            lastError = error
        }
    }
    
    func startTrial() async {
        guard canStartTrial else { return }
        
        do {
            // Set up trial period (30 days from now)
            let trialEnd = calendar.date(byAdding: .day, value: 30, to: Date())
            subscriptionDetails = SubscriptionDetails(
                status: .trial,
                expirationDate: trialEnd,
                trialEndDate: trialEnd
            )
            saveSubscriptionDetails()
            lastError = nil
        } catch {
            lastError = error
        }
    }
    
    func purchaseSubscription(_ type: SubscriptionStatus) async {
        guard type == .basic || type == .premium else { return }
        
        do {
            // Implement StoreKit purchase here
            // This is a placeholder for the actual implementation
            isLoading = true
            // Simulate purchase process
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            // Update subscription status after successful purchase
            let expirationDate = calendar.date(byAdding: .month, value: 1, to: Date())
            subscriptionDetails = SubscriptionDetails(
                status: type,
                expirationDate: expirationDate,
                trialEndDate: subscriptionDetails.trialEndDate
            )
            saveSubscriptionDetails()
            lastError = nil
        } catch {
            lastError = error
        }
        isLoading = false
    }
    
    // MARK: - Helper Methods
    
    private var canStartTrial: Bool {
        subscriptionDetails.status == .none && subscriptionDetails.trialEndDate == nil
    }
    
    private func saveSubscriptionDetails() {
        if let encoded = try? JSONEncoder().encode(subscriptionDetails) {
            defaults.set(encoded, forKey: StorageKeys.subscriptionDetails)
        }
    }
    
    private func verifySubscription() async -> SubscriptionDetails {
        // Implement actual StoreKit verification here
        // This is a placeholder that just returns the current details
        return subscriptionDetails
    }
}


//
//  ContentView.swift
//  Workout_App
//
//  Created by Landon Hollis on 1/26/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var workoutManager: WorkoutManager
    @EnvironmentObject private var userManager: UserManager
    @State private var showingShareSheet = false
    
    var body: some View {
        NavigationView {
            List {
                // Your main menu items
                
                Button(action: {
                    showingShareSheet = true
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Send Workout to Gymbro")
                    }
                }
            }
            .navigationTitle("Workouts")
            .sheet(isPresented: $showingShareSheet) {
                ShareWorkoutView()
            }
        }
    }
}

// Custom grid layout for consistent spacing
struct GridLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = 2
        let columns = 2
        
        // Calculate item size based on available space
        let totalSpacing: CGFloat = 20 // Gap between items
        let availableWidth = proposal.width ?? 0
        let availableHeight = proposal.height ?? 0
        
        let itemWidth = (availableWidth - totalSpacing) / CGFloat(columns)
        let itemHeight = (availableHeight - totalSpacing) / CGFloat(rows)
        
        return CGSize(width: availableWidth, height: availableHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = 2
        let columns = 2
        let spacing: CGFloat = 20
        
        let itemWidth = (bounds.width - spacing) / CGFloat(columns)
        let itemHeight = (bounds.height - spacing) / CGFloat(rows)
        
        for (index, subview) in subviews.enumerated() {
            let row = index / columns
            let column = index % columns
            
            let x = bounds.minX + CGFloat(column) * (itemWidth + spacing/2)
            let y = bounds.minY + CGFloat(row) * (itemHeight + spacing/2)
            
            let point = CGPoint(x: x, y: y)
            subview.place(at: point, proposal: ProposedViewSize(width: itemWidth, height: itemHeight))
        }
    }
}

// Custom button style for menu items
struct MenuButton: View {
    let title: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: systemImage)
                .font(.system(size: 30))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(radius: 5)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
        .environmentObject(WorkoutManager())
        .environmentObject(UserManager())
}

//
//  CalendarStreakView.swift
//  WatchCouchHamsterNew Watch App
//
//  Created by hendra on 22/05/24.
//

import SwiftUI

struct CalendarStreakView: View {
    let markedDates: [Int] = [3, 5, 12, 18, 25]
        let currentMonthDays: [Int] = Array(1...30)
    
    var body: some View {
        ZStack {
            Color.mainOrange.ignoresSafeArea()
            VStack {
                Text("May 2024")
                    .font(.headline)
                    .padding(.bottom, 8)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
                    ForEach(currentMonthDays, id: \.self) { day in
                        ZStack {
//                            if markedDates.contains(day) {
////                                Circle()
////                                    .strokeBorder(Color.red, lineWidth: 2)
////                                    .background(Circle().foregroundColor(Color.clear))
////                                    .frame(width: 20, height: 20)
//                                
//                            }
                            Text("\(day)")
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .background(markedDates.contains(day) ? Color.red.opacity(0.6) : Color.clear)
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    CalendarStreakView()
}

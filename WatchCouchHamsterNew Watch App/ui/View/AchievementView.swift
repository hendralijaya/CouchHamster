//
//  AchievementView.swift
//  WatchCouchHamsterNew Watch App
//
//  Created by hendra on 21/05/24.
//

import SwiftUI

struct AchievementView: View {
    let achievements: [Achievement] = [
        Achievement(title: "First Day", imgSource: "StartAchievement", isCompleted: true),
            Achievement(title: "Second Day", imgSource: "StartAchievement", isCompleted: false)
            
        ]

        var body: some View {
            ZStack {
                Color.mainOrange.ignoresSafeArea()
                List(achievements) { achievement in
                    HStack {
                        Spacer()
                        VStack(alignment: .leading) {
                            Text(achievement.title)
                                .font(.headline)
                                .foregroundStyle(achievement.isCompleted ? .white : .gray)
                            Image(achievement.isCompleted ? "\(achievement.imgSource)Completed" : "\(achievement.imgSource)Uncompleted")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                                    
                }
                .navigationTitle("Achievements")
            }
        }
}

#Preview {
    AchievementView()
}

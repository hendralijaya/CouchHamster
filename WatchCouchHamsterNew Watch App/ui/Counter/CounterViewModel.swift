//
//  CounterViewModel.swift
//  WatchCouchHamsterNew Watch App
//
//  Created by hendra on 27/05/24.
//

import Foundation

class CounterViewModel: ObservableObject {
    @Published var value: Int = 10
    let goalsText: String
    
    init(goalsText: String) {
        self.goalsText = goalsText
        loadMoveGoal()
    }
    
    private func loadMoveGoal() {
        let savedValue = UserDefaults.standard.integer(forKey: DataStore.moveGoalKey)
        value = savedValue > 0 ? savedValue : 10
    }
    
    func saveMoveGoal() {
        UserDefaults.standard.set(value, forKey: DataStore.moveGoalKey)
    }
}

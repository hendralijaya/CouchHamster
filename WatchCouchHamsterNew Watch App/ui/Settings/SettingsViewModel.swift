//
//  SettingsViewModel.swift
//  WatchCouchHamsterNew Watch App
//
//  Created by hendra on 27/05/24.
//

import Foundation

class SettingsViewModel: ObservableObject {
    @Published var footStepsChecked = false
    @Published var kiloCaloriesChecked = false
    @Published var showCounterFootSteps = false
    @Published var showCounterKiloCalories = false
    
    func toggleCheckmark(_ checked: inout Bool, other: inout Bool) {
        if !checked {
            checked.toggle()
            other = false
        }
    }
    
    func initialize() {
        loadGoalType()
    }
    
    func tapCheckmark(for title: String) {
        if title == "Foot Steps" {
            showCounterFootSteps = true
            toggleCheckmark(&footStepsChecked, other: &kiloCaloriesChecked)
            saveGoalType(.steps)
        } else if title == "Kilo Calories" {
            showCounterKiloCalories = true
            toggleCheckmark(&kiloCaloriesChecked, other: &footStepsChecked)
            saveGoalType(.kilocalories)
        }
    }
    
    private func loadGoalType() {
        let savedGoalType = UserDefaults.standard.string(forKey: DataStore.goalTypeKey) ?? "steps"
        if let goalType = GoalType(rawValue: savedGoalType) {
            footStepsChecked = goalType == .steps
            kiloCaloriesChecked = goalType == .kilocalories
        }
    }
        
    private func saveGoalType(_ goalType: GoalType) {
        UserDefaults.standard.set(goalType.rawValue, forKey: DataStore.goalTypeKey)
    }
}

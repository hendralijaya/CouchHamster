//
//  MainViewModel.swift
//  WatchCouchHamsterNew Watch App
//
//  Created by hendra on 27/05/24.
//

import HealthKit

class MainViewModel: ObservableObject {
    @Published var isChecked: Bool = true
    @Published var showAchievements = false
    @Published var showSettings = false
    @Published var quantityCarrot = 2
    @Published var hamsterHealth = 80
    @Published var selectedTab = 0
    @Published var stepCount: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var target = 500
    @Published var goalType: GoalType = .steps
    
    private var healthStore: HKHealthStore
    
    init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
        loadGoalType()
        loadMoveGoal()
        checkAndDeductHealthDaily()
    }
    
    var hamsterImageName: String {
            switch hamsterHealth {
            case ..<40:
                return "SadHamster"
            case 40..<70:
                return "AngryHamster"
            default:
                return "HappyHamster"
            }
        }
    
    private func get24hPredicate() -> NSPredicate {
        let today = Date()
        let startDate = Calendar.current.date(byAdding: .hour, value: -24, to: today)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: today, options: [])
        return predicate
    }
        
    func loadMoveGoal() {
        let savedValue = UserDefaults.standard.integer(forKey: DataStore.moveGoalKey)
        target = savedValue > 0 ? savedValue : 500
    }
    
    func readTotalStepCount() {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            fatalError("*** Unable to get the step count type ***")
        }
        
        let query = HKStatisticsQuery(quantityType: stepCountType,
                                      quantitySamplePredicate: get24hPredicate(),
                                      options: .cumulativeSum) { (query, results, error) in
            DispatchQueue.main.async {
                let totalStepCount = results?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
                self.stepCount = totalStepCount
            }
        }
        
        healthStore.execute(query)
    }
    
    private func readTotalActiveEnergy() {
        guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            fatalError("*** Unable to get the active energy type ***")
        }
        
        let query = HKStatisticsQuery(quantityType: activeEnergyType,
                                      quantitySamplePredicate: get24hPredicate(),
                                      options: .cumulativeSum) { [weak self] (query, results, error) in
            DispatchQueue.main.async {
                let totalActiveEnergy = results?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0
                self?.activeEnergy = totalActiveEnergy
            }
        }
        
        healthStore.execute(query)
    }
    
    func completeDailyTasks() {
        if !UserDefaults.standard.bool(forKey: DataStore.dailyTaskCompletedKey) {
            quantityCarrot += 1
            UserDefaults.standard.set(true, forKey: DataStore.dailyTaskCompletedKey)
        }
    }
    
    private func checkAndDeductHealthDaily() {
        let calendar = Calendar.current
        let lastDeductionDate = UserDefaults.standard.object(forKey: DataStore.lastDeductionDateKey) as? Date ?? Date()
        if !calendar.isDateInToday(lastDeductionDate) {
            hamsterHealth -= 10
            UserDefaults.standard.set(Date(), forKey: DataStore.lastDeductionDateKey)
        }
    }
    
    func useCarrot() {
        if quantityCarrot > 0 {
            quantityCarrot -= 1
            hamsterHealth += 15
            saveValue()
        }
    }
    
    private func saveValue() {
        UserDefaults.standard.set(quantityCarrot, forKey: DataStore.carrotsKey)
        UserDefaults.standard.set(hamsterHealth, forKey: DataStore.healthKey)
    }
    
    func loadValue() {
        hamsterHealth = UserDefaults.standard.integer(forKey: DataStore.healthKey)
        if hamsterHealth == 0 {
            hamsterHealth = 80
        }
        quantityCarrot = UserDefaults.standard.integer(forKey: DataStore.carrotsKey)
    }
    
    private func loadGoalType() {
        let savedGoalType = UserDefaults.standard.string(forKey: DataStore.goalTypeKey) ?? "steps"
        goalType = GoalType(rawValue: savedGoalType) ?? .steps
    }
    
    func readHealthData() {
            if goalType == .steps {
                readTotalStepCount()
            } else if goalType == .kilocalories {
                readTotalActiveEnergy()
            }
        }
        
    func updateGoalType(to newGoalType: GoalType) {
        goalType = newGoalType
        UserDefaults.standard.set(newGoalType.rawValue, forKey: DataStore.goalTypeKey)
        readHealthData()
    }
}

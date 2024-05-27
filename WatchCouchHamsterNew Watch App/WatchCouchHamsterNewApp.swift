//
//  WatchCouchHamsterNewApp.swift
//  WatchCouchHamsterNew Watch App
//
//  Created by hendra on 17/05/24.
//

import SwiftUI
import HealthKit

@main
struct WatchCouchHamsterNew_Watch_AppApp: App {
    
    private let healthStore: HKHealthStore
        
    init() {
        guard HKHealthStore.isHealthDataAvailable() else {  fatalError("This app requires a device that supports HealthKit") }
        healthStore = HKHealthStore()
        requestHealthkitPermissions()
    }
    
    private func requestHealthkitPermissions() {
        let sampleTypesToRead = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ])
        
        healthStore.requestAuthorization(toShare: nil, read: sampleTypesToRead) { (success, error) in
            print("Request Authorization -- Success: ", success, " Error: ", error ?? "nil")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(MainViewModel(healthStore: healthStore))
                .environmentObject(healthStore)
        }
    }
}

extension HKHealthStore: ObservableObject{}

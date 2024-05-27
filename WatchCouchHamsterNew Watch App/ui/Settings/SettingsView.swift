//
//  SettingsView.swift
//  WatchCouchHamsterNew Watch App
//
//  Created by hendra on 22/05/24.
//

import SwiftUI
import HealthKit

struct SettingsView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        ZStack {
            Color.mainOrange.ignoresSafeArea()
            VStack(spacing: 8) {
                HStack {
                    Text("Daily")
                        .font(.title2)
                        .padding(.horizontal)
                        .padding(.leading, 16)
                    Spacer()
                }
                VStack(alignment: .leading) {
                    Spacer()
                    checkmarkRow(title: "Foot Steps", isChecked: $viewModel.footStepsChecked)
                    Spacer()
                    checkmarkRow(title: "Kilo Calories", isChecked: $viewModel.kiloCaloriesChecked)
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.softOrange)
                )
                .padding(.horizontal, 24)
            }
        }
        .navigationTitle("Settings")
        .onAppear {
            viewModel.initialize()
        }
        .navigationDestination(isPresented: $viewModel.showCounterFootSteps, destination: {
            CounterView(goalsText: .constant("FOOT STEPS"))
                .environmentObject(mainViewModel)
        })
        .navigationDestination(isPresented: $viewModel.showCounterKiloCalories, destination: {
            CounterView(goalsText: .constant("KILOCALORIES")).environmentObject(mainViewModel)
        })
    }
    
    func toggleCheckmark(_ checked: inout Bool, other: inout Bool) {
            if !checked {
                checked.toggle()
                other = false
            }
        }
    
    @ViewBuilder
        func checkmarkRow(title: String, isChecked: Binding<Bool>) -> some View {
            HStack {
                Text(title)
                    .font(.callout)
                    .fontWeight(.medium)
                    .onTapGesture {
                        if title == "Foot Steps" {
                            mainViewModel.updateGoalType(to: .steps)
                        } else if title == "Kilo Calories" {
                            mainViewModel.updateGoalType(to: .kilocalories)
                        }
                        viewModel.tapCheckmark(for: title)
                    }
                Spacer()
                if isChecked.wrappedValue {
                    Image(systemName: "checkmark")
                        .font(.callout)
                        .fontWeight(.medium)
                        .padding(.trailing, 8)
                }
            }
            .padding(.leading, 8)
        }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let healthStore = HKHealthStore()
        let mainViewModel = MainViewModel(healthStore: healthStore)
        return SettingsView().environmentObject(mainViewModel)
    }
}

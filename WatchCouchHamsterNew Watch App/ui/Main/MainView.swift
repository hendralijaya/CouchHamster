//
//  MainView.swift
//  WatchCouchHamsterNew Watch App
//
//  Created by hendra on 21/05/24.
//

import SwiftUI
import HealthKit

struct MainView: View {
    
    @EnvironmentObject var healthStore: HKHealthStore
    @EnvironmentObject var viewModel: MainViewModel
        
//    init(healthStore: HKHealthStore) {
//        self._viewModel = EnvironmentObject(wrappedValue: MainViewModel(healthStore: healthStore))
//    }
    
    var body: some View {
        NavigationStack{
            TabView(selection: $viewModel.selectedTab) {
                ZStack {
                    Color.mainOrange.ignoresSafeArea()
                    VStack {
                        HStack {
                            Image(systemName: viewModel.isChecked ? "circle.inset.filled" : "circle")
                                .foregroundColor(.white)
                            Text(viewModel.goalType == .steps ? "\(Int(viewModel.stepCount))/\(viewModel.target) steps" : "\(Int(viewModel.activeEnergy))/\(viewModel.target) kcal")
                                .fontWeight(.medium)
                                .font(.caption)
                        }
                        Image(viewModel.hamsterImageName)
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    .onAppear() {
                        viewModel.readTotalStepCount()
                        viewModel.loadValue()
                    }
                }
                .tag(0)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {}
                    label: {
                        HStack(spacing: 4) {
                            ZStack {
                                Image(systemName: "heart")
                                    .foregroundColor(.red)
                            }
                            Text("\(viewModel.hamsterHealth)/100")
                                .foregroundColor(.red)
                                .font(.headline)
                        }
                    }
                    .controlSize(.large)
                    .buttonStyle(PlainButtonStyle())
                        
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                        } label: {
                            HStack {
                                Image(systemName:"flame")
                                Text("7")
                            }
                            .foregroundStyle(.white)
                        }
                        .controlSize(.large)
                        .buttonStyle(PlainButtonStyle())
                    }
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button {
                            viewModel.showSettings = true
                        } label: {
                            Image(systemName:"gearshape")
                        }
                        
                        Button {
                            viewModel.completeDailyTasks()
                            viewModel.useCarrot()
                        } label: {
                            HStack {
                                Image(systemName:"carrot")
                                Text("\(viewModel.quantityCarrot)")
                            }
                            .frame(width: 64, height: 36)
                            .background(.darkRed, in: Capsule())
                        }
                        .controlSize(.large)
                        .buttonStyle(PlainButtonStyle())
                        
                        Button {
                            viewModel.showAchievements = true
                        } label: {
                            Image(systemName:"trophy")
                        }
                    }
                }
                .navigationDestination(isPresented: $viewModel.showAchievements) {
                    AchievementView()
                }
                .navigationDestination(isPresented: $viewModel.showSettings) {
                    SettingsView()
                }
                VStack {
                    HealthHamsterView(hamsterHealth: $viewModel.hamsterHealth)
                }
                .tag(1)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Text("Health Hamster")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                VStack {
                    CalendarStreakView()
                }
                .tag(2)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Text("Calendar Streak")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
            }
            .environmentObject(viewModel)
            .tabViewStyle(.verticalPage)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let healthStore = HKHealthStore()
        let mainViewModel = MainViewModel(healthStore: healthStore)
        return MainView()
            .environmentObject(mainViewModel)
    }
}

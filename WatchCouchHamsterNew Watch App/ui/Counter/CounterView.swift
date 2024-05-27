//
//  CounterView.swift
//  WatchCouchHamsterNew Watch App
//
//  Created by hendra on 22/05/24.
//

import SwiftUI
import HealthKit

struct CounterView: View {
    @StateObject private var viewModel: CounterViewModel
    @EnvironmentObject var mainViewModel: MainViewModel
    @Environment(\.dismiss) var dismiss
    
    init(goalsText: Binding<String>) {
        _viewModel = StateObject(wrappedValue: CounterViewModel(goalsText: goalsText.wrappedValue))
    }

    var body: some View {
        ZStack {
            Color.mainOrange.ignoresSafeArea()
            VStack {
                Text("MOVE GOAL")
                Stepper("\(viewModel.value)", value: $viewModel.value, in:10...1000, step: 10)
                    .padding()
                    .tint(.red)
                Text(viewModel.goalsText)
                    .fontWeight(.semibold)
                Button {
                    viewModel.saveMoveGoal()
                    mainViewModel.loadMoveGoal()
                    dismiss()
                } label: {
                    Text("Set")
                        .foregroundStyle(.white)
                }
                .tint(.red)
            }
        }
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        let healthStore = HKHealthStore()
        let mainViewModel = MainViewModel(healthStore: healthStore)
        return CounterView(goalsText: .constant("FOOT STEPS")).environmentObject(mainViewModel)
    }
}


//#Preview {
//    CounterView(goalsText: .constant("FOOT STEPS"))
//}

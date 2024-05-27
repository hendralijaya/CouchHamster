//
//  HealthHamsterView.swift
//  WatchCouchHamsterNew Watch App
//
//  Created by hendra on 22/05/24.
//

import SwiftUI

struct HealthHamsterView: View {
    @Binding var hamsterHealth: Int
    var body: some View {
        ZStack {
            Color.mainOrange.ignoresSafeArea()
            VStack (spacing: 8) {
                Text("Hamster Health")
                    .font(.headline)
                    .fontWeight(.bold)
                HStack(spacing: 4) {
                    ZStack {
                        Image(systemName: "heart")
                            .foregroundColor(.red)
                    }
                    Text("\(hamsterHealth)/100")
                        .foregroundColor(.red)
                        .font(.headline)
                }
                Text("Feed your hamster with carrot to keep its health up. Every day, health decreases by 10.")
                    .font(.caption)
            }
        }
    }
}

#Preview {
    HealthHamsterView(hamsterHealth: .constant(100))
}

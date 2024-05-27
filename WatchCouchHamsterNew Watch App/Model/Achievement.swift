//
//  Achievement.swift
//  WatchCouchHamsterNew Watch App
//
//  Created by hendra on 26/05/24.
//

import Foundation

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let imgSource: String
    let isCompleted: Bool
}

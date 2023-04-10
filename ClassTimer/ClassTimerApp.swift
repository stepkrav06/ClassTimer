//
//  ClassTimerApp.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 10.04.2023.
//

import SwiftUI

@main
struct ClassTimerApp: App {
    var body: some Scene {
        let viewModel = AppViewModel()
        WindowGroup {

                TabView()
                .environmentObject(viewModel)
            
        }
    }
}

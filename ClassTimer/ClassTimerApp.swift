//
//  ClassTimerApp.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 10.04.2023.
//

import SwiftUI

@main
struct ClassTimerApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    let viewModel = AppViewModel()
    init(){
        viewModel.pickedColor = viewModel.defaults.colorForKey(key: "AccentColor")

        if let data = UserDefaults.standard.data(forKey: "Classes") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let classes = try decoder.decode([Class].self, from: data)
                viewModel.classes = classes

            } catch {
                print("Unable to Decode classes (\(error))")
            }
        }
        if let data = UserDefaults.standard.data(forKey: "Schedule") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let schedule = try decoder.decode(Schedule.self, from: data)
                viewModel.schedule = schedule

            } catch {
                print("Unable to Decode schedule (\(error))")
            }
        }
    }
    var body: some Scene {


        WindowGroup {
                TabView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environmentObject(viewModel)
            
        }
    }
}

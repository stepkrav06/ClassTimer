//
//  ClassTimerApp.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 10.04.2023.
//

import SwiftUI

@main
struct ClassTimerApp: App {
    let viewModel = AppViewModel()
    init(){
        viewModel.pickedColor = viewModel.defaults.colorForKey(key: "AccentColor")
        if let data = UserDefaults.standard.data(forKey: "Classes") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let classes = try decoder.decode([Class].self, from: data)
                

            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        }
    }
    var body: some Scene {


        WindowGroup {
                TabView()
                .environmentObject(viewModel)
            
        }
    }
}

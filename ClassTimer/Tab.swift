//
//  Tab.swift
//
//  Tab bar structure
//
//

import Foundation
import SwiftUI
let viewModel = AppViewModel()
class AppViewModel: ObservableObject {
    @Published var colors = [Color.c1, Color.c2, Color.c5, Color.c3, Color.c4]
    @Published var pickedColor = Color.c1
}

struct TabItem: Identifiable{
    var id = UUID()
    var text: String
    var icon: String
    var tab: Tab

}
var tabItems = [
    TabItem(text: "Timer", icon: "timer", tab: .timer),
    TabItem(text: "Classes", icon: "list.bullet", tab: .classes),
    TabItem(text: "Settings", icon: "gear", tab: .settings),
]
enum Tab: String {
    case timer
    case classes
    case settings
}


extension Color {
    static let c1 = Color("C1")
    static let c2 = Color("C2")
    static let c3 = Color("C3")
    static let c4 = Color("C4")
    static let c5 = Color("C5")
    static let textC1 = Color("TextC")
}

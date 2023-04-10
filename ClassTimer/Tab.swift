//
//  Tab.swift
//
//  Tab bar structure
//
//

import Foundation
import SwiftUI

struct TabItem: Identifiable{
    var id = UUID()
    var text: String
    var icon: String
    var tab: Tab
    var color: Color
}
var tabItems = [
    TabItem(text: "Timer", icon: "timer", tab: .timer, color: .teal),
    TabItem(text: "Classes", icon: "list.bullet", tab: .classes, color: .teal),
    TabItem(text: "Settings", icon: "gear", tab: .settings, color: .teal),
]
enum Tab: String {
    case timer
    case classes
    case settings
}



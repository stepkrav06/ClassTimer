//
//  Class.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 10.04.2023.
//

import Foundation
struct Class: Identifiable, Equatable {
    public let id = UUID()
    var name: String
    var daysTimes: [String:[String]]
    var dates: [Date]
}

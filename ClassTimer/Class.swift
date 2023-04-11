//
//  Class.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 10.04.2023.
//

import Foundation
struct Class: Identifiable, Equatable, Codable, Hashable {
    public var id = UUID()
    var name: String
    var daysTimes: [String:[String]]
    var description: String

    
}
struct Lesson: Identifiable, Equatable, Codable, Hashable {
    public var id = UUID()
    var name: String
    var timeStart: String
    var timeEnd: String


}
struct Schedule: Identifiable, Equatable, Codable, Hashable {
    public var id = UUID()
    var schedule: [Int:[Lesson]]
}
struct ClassDate: Identifiable, Equatable, Codable, Hashable {
    public var id = UUID()
    var name: String
    var date: Date
}


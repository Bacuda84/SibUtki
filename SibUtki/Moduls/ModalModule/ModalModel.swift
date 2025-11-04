//
//  Model.swift
//  SibUtki
//
//  Created by Bakhtovar Akhmedov on 01.11.2025.
//

import Foundation

struct Group {
    let name: String
    let institute: String
    let course: Int
}

struct Institute: Codable {
    let name: String
    let courses: [Course]
}

struct Course: Codable {
    let courseNumber: Int
    let groups: [String]
}

struct GroupListResponse: Codable {
    let institutes: [Institute]
}

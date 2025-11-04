import Foundation

let calendar = Calendar.current
//let nextDay = calendar.date(byAdding: .day, value: 1, to: Date())!
let nextDay = calendar.date(byAdding: DateComponents(day: 1), to: Date())!
let components = calendar.dateComponents([.day], from: nextDay)

let startDay = Date()
let oneYearAgo = calendar.date(byAdding: .year, value: 1, to: startDay)!
let diff = calendar.dateComponents([.day], from: startDay, to: oneYearAgo)
print(diff.day)
//print(components.day!)

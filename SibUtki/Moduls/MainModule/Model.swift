//
//  Model.swift
//  SibUtki
//
//  Created by Bakhtovar Akhmedov on 28.10.2025.
//

import Foundation

struct Lessson: Codable {
    let id: Int
    let discipline: String
    let teachers: [String]
    let classroom: String?
    let typeOfLesson: String?
    let subGroup: String?
    let beginTime: String
    let endTime: String?
    enum CodingKeys: String, CodingKey {  
        case id
        case discipline
        case teachers
        case classroom
        case typeOfLesson = "type_of_lesson"
        case subGroup = "sub_group"
        case beginTime = "begin_time"
        case endTime = "end_time"
    }
}
struct Schedule: Codable {
    let date: String
    let weekday: String
    let weekType: String
    let lessons: [Lessson]
    
    enum CodingKeys: String,  CodingKey {
        case date
        case weekday = "week_day"
        case weekType = "week_type"
        case lessons
    }
}
struct AnswerForSchedule: Codable {
    let group: String
    let days: [Schedule]
    
}


/* //пример респонса
 {
     "group": "ИВ-777",
     "days": [
         {
             "date": "04.11.2025",
             "week_day": "Вторник",
             "week_type": "Нечетная",
             "lessons": [
                 {
                     "id": 424,
                     "discipline": "Математика",
                     "teachers": [
                         "Замечательный преподаватель"
                     ],
                     "classroom": "а.9 (К.34)",
                     "type_of_lesson": "Практические занятия",
                     "sub_group": null,
                     "begin_time": "08:00",
                     "end_time": null
                 },
                 {
                     "id": 25235,
                     "discipline": "История России",
                     "teachers": [
                        "Замечательный преподаватель"
                     ],
                     "classroom": "а.424 (К.531)",
                     "type_of_lesson": "Практические занятия",
                     "sub_group": null,
                     "begin_time": "09:50",
                     "end_time": null
                 },
                 {
                     "id": 3141,
                     "discipline": "Алгебра и геометрия",
                     "teachers": [
                         "Замечательный преподаватель"
                     ],
                     "classroom": "а.242 (К.15)",
                     "type_of_lesson": "Практические занятия",
                     "sub_group": null,
                     "begin_time": "11:40",
                     "end_time": null
                 },
                 {
                     "id": 1890,
                     "discipline": "Алгебра и геометрия",
                     "teachers": [
                         "Замечательный преподаватель"
                     ],
                     "classroom": "а.425 (К.321)",
                     "type_of_lesson": "Лекционные занятия",
                     "sub_group": null,
                     "begin_time": "13:45",
                     "end_time": null
                 }
             ]
         }
     ]
 }
*/

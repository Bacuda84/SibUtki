//
//  NetworkTests.swift
//  SibUtkiTests
//
//  Created by Bakhtovar Akhmedov on 03.11.2025.
//

import XCTest
@testable import SibUtki

let exampleScheduleJson = """
    {
    "group": "ИВ-521",
    "days": [
        {
            "date": "03.11.2025",
            "week_day": "Понедельник",
            "week_type": "Нечетная",
            "lessons": [
                {
                    "id": 42,
                    "discipline": "Иностранный язык",
                    "teachers": [
                         "Замечательный преподаватель",
                         "Замечательный преподаватель",
                         "Замечательный преподаватель",
                         "Замечательный преподаватель"
                    ],
                    "classroom": null,
                    "type_of_lesson": "Занятия по ин.язу",
                    "sub_group": null,
                    "begin_time": "08:00",
                    "end_time": null
                    
                }
            ]
        }
        ]
    }
    """

let exampleGroupsJson = """
    {
    "institutes": [
        {
            "name": "ИВТ",
            "courses": [
                {
                    "courseNumber": 2,
                    "groups": [
                    ]
                },
                {
                    "courseNumber": 1,
                    "groups": [
                    ]
                },
                {
                    "courseNumber": 3,
                    "groups": [
                    ]
                },
                {
                    "courseNumber": 4,
                    "groups": [
                    ]
                }
            ]
        },
        {
            "name": "ИТ",
            "courses": [
                {
                    "courseNumber": 2,
                    "groups": [
                    ]
                },
                {
                    "courseNumber": 1,
                    "groups": [
                    ]
                },
                {
                    "courseNumber": 3,
                    "groups": [
                    ]
                },
                {
                    "courseNumber": 4,
                    "groups": [
                    ]
                }
            ]
        }]
    }
    """
    

final class NetworkTests: XCTestCase {
    
    var networkService: NetworkProtocol!

    override func setUpWithError() throws {
        networkService = NetworkService()
    }

    override func tearDownWithError() throws {
        networkService = nil
        
        
    }
    //MARK: - Проверяем корректность серилизации модели самих предметов -
    func testDecodableScheduleJson() throws {
        do {
            if let data = exampleScheduleJson.data(using: .utf8) {
                let response = try JSONDecoder().decode(AnswerForSchedule.self, from: data)
            }
        } catch {
            XCTFail("Decodable плохо работает")
        }
    }

    func testEncodableScheduleJson() throws {
        do {
            let newExample = AnswerForSchedule(group: "Baz Bar", days: [.init(date: "01.09.2025", weekday: "Foo", weekType: "Baz", lessons: [.init(id: 1, discipline: "", teachers: ["Bax"], classroom: nil, typeOfLesson: nil, subGroup: nil, beginTime: "", endTime: "")])])
            let newJson = try JSONEncoder().encode(newExample)
            
        } catch {
            XCTFail("Encodable плохо работает")
        }
    }
    
    //MARK: - Проверяем корректность серилизации модели всех групп -
    func testDecodableGroupsJson() throws {
        do {
            if let data = exampleGroupsJson.data(using: .utf8) {
                let response = try JSONDecoder().decode(GroupListResponse.self, from: data)
            }
        } catch {
            XCTFail("Decodable плохо работает")
        }
    }


    func testEncodableGroupsJson() throws {
        do {
            let newExample = GroupListResponse(institutes: [.init(name: "Baz", courses: [.init(courseNumber: 1, groups: ["Bar", "Foo"])])])
            let newJson = try JSONEncoder().encode(newExample)
            
        } catch {
            XCTFail("Encodable плохо работает")
        }
    }

    //MARK: - проверки коректности ссылок-
    func testURLNotEmpty() {
        XCTAssertFalse(networkService.url.isEmpty, "URL пустая!")
    }

}

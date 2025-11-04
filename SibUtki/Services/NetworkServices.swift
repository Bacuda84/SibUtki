//
//  NetworkServices.swift
//  SibUtki
//
//  Created by Bakhtovar Akhmedov on 29.10.2025.
//

import Foundation


protocol NetworkProtocol {
    
    var url: String { get set }
    func getSchedule(_ group: String, dates: [Date] ,completion: @escaping (Result<AnswerForSchedule?, any Error>) -> Void)
    func getGroups(_ completion: @escaping (Result<GroupListResponse?, any Error>) -> Void)
}

class NetworkService {
    
    var url = "https://elidible-idell-hypernaturally.ngrok-free.dev"
    
    enum Requests: String {
        case getSchedule = "/schedule"
        case getGroups = "/groups"
    }
}

extension NetworkService: NetworkProtocol {
 
    func getSchedule(_ group: String, dates: [Date] ,completion: @escaping (Result<AnswerForSchedule?, any Error>) -> Void) {
        guard var newURLWithQuery = URLComponents(string: url+Requests.getSchedule.rawValue) else { return }
        
        let dateForOurFormat = getFormatedDate(From: dates)
        newURLWithQuery.queryItems = [
            URLQueryItem(name: "group", value: group),
            URLQueryItem(name: "date", value: dateForOurFormat)
    
        ]
        let request = URLRequest(url: newURLWithQuery.url!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let answer = try JSONDecoder().decode(AnswerForSchedule.self, from: data!)
                completion(.success(answer))
                return
            } catch {
                completion(.failure(error))
                return
            }
            
        }.resume()
        
    }
    
    func getGroups(_ completion: @escaping (Result<GroupListResponse?, any Error>) -> Void) {
        guard let url = URL(string: url+Requests.getGroups.rawValue) else { return }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let result = try JSONDecoder().decode(GroupListResponse.self, from: data!)
                completion(.success(result))
            } catch {
                completion(.failure(error))
                return
            }
            
            
        }.resume()
    }
    
    private func getFormatedDate(From dates: [Date]) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: dates[0])
    }
}

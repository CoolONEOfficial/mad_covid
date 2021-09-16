//
//  NetworkService.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 16.09.2021.
//

import Foundation
import Alamofire
import SwiftUI

struct SignInResp: Decodable {
    let data: Data?
    
    struct Data: Decodable {
        let token: String
        let id: String
    }
}

struct SymResp: Decodable {
    let data: [Sym]
    
}

struct Sym: Decodable {
    let date: Date
    let probability_infection: Int
}

class NetworkService {
    private init() {}
    
    static let shared: NetworkService = .init()

    let base = "https://wsa2021.mad.hakta.pro/api"
//
//    var token: String? = UserDefaults.standard.string(forKey: "token") {
//        didSet {
//            UserDefaults.standard.set(token, forKey: "token")
//        }
//    }
    
    var userId: String? = UserDefaults.standard.string(forKey: "uid") {
        didSet {
            UserDefaults.standard.set(userId, forKey: "uid")
        }
    }

    func signIn(login: String, password: String, completion: @escaping (Bool) -> Void) {
        
        AF.request(base + "/signin/", method: .post, parameters: ["login": login, "password": password] as [String: String], encoder: JSONParameterEncoder.default).responseDecodable(of: SignInResp.self) { [weak self] result in
            switch result.result {
            case let .success(resp) where resp.data?.token != nil:
               // self?.token = resp.data?.token
                self?.userId = resp.data?.id
                completion(true)

            default:
                completion(false)
            }
        }
    }
    
    func fetchSymts(completion: @escaping ([Sym]) -> Void) {
        guard let userId = userId else {
            completion([])
            return
        }

        
        
        AF.request(base + "/symptoms_history?user_id=\(userId)", method: .get).responseDecodable(of: SymResp.self) { [weak self] result in
            switch result.result {
            case let .success(resp):
                completion(resp.data)

            default:
                completion([])
            }
        }
    }
}

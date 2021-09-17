//
//  NetworkService.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 16.09.2021.
//

import Foundation
import Alamofire
import SwiftUI
import AlamofireNetworkActivityLogger

let reach = NetworkReachabilityManager()!

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

struct QrResp: Decodable {
    let data: String
}

struct CasesResp: Decodable {
    let data: Int
}

struct Sym: Decodable {
    let date: Date
    let probability_infection: Int
}

class NetworkService {
    private init() {
        NetworkActivityLogger.shared.startLogging()
    }
    
    deinit {
        NetworkActivityLogger.shared.stopLogging()
    }
    
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

    func fetchQrImage(_ qrMode: QrMode = .black, completion: @escaping (UIImage?) -> Void) {
        fetchQr(qrMode) { res in
            if let url = res {
                AF.download(url).responseData { imgRes in
                    switch imgRes.result {
                    case let .success(resp):
                        completion(UIImage(data: resp))

                    default:
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
    
    enum QrMode: String {
        case black
        case white
    }

    func fetchQr(_ qrMode: QrMode = .white, completion: @escaping (URL?) -> Void) {
        AF.request(base + "/user_qr?\(qrMode.rawValue)", method: .get).responseDecodable(of: QrResp.self) { [weak self] result in
            switch result.result {
            case let .success(resp):
                completion(.init(string: resp.data))

            default:
                completion(nil)
            }
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
        
        let dec = JSONDecoder()
        let fm = DateFormatter()
        fm.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dec.dateDecodingStrategy = .formatted(fm)
        
        AF.request(base + "/symptoms_history?user_id=\(userId)", method: .get).responseDecodable(of: SymResp.self, decoder: dec) { [weak self] result in
            switch result.result {
            case let .success(resp):
                completion(resp.data)

            default:
                completion([])
            }
        }
    }
    
    func fetchCases(completion: @escaping (Int?) -> Void) {
        AF.request(base + "/cases", method: .get).responseDecodable(of: CasesResp.self) { [weak self] result in
            switch result.result {
            case let .success(resp):
                completion(resp.data)

            default:
                completion(nil)
            }
        }
    }
}

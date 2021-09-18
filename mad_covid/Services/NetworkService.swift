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

struct EmptyResp: Decodable {
    let success: Bool
    let message: String?
}

struct StatsResp: Decodable {
    let data: Stats
    
    struct Stats: Decodable {
        let world: Stat
        let current_city: Stat
        
        struct Stat: Decodable {
            let infected: Int
            let death: Int
            let recovered: Int
            let vaccinated: Int
            let recovered_adults: Int
            let recovered_young: Int
        }
        
    }
    
    static var mock: Self {
        .init(data: .init(world: .init(infected: 0, death: 0, recovered: 0, vaccinated: 0, recovered_adults: 0, recovered_young: 0), current_city: .init(infected: 0, death: 0, recovered: 0, vaccinated: 0, recovered_adults: 0, recovered_young: 0)))
    }
}

struct QrResp: Decodable {
    let data: String
}

struct CasesResp: Decodable {
    let data: Int
}

struct SymListResp: Decodable {
    let data: [Sym]
    
    struct Sym: Decodable {
        let id: Int
        let title: String
    }
}

struct ContactsResp: Decodable {
    let data: Contacts?
    
    struct Contacts: Decodable {
        let cases: Int
        let vaccinated: Int
    }
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
            case let .success(resp) where resp.data?.id != nil:
               // self?.token = resp.data?.token
                self?.userId = resp.data?.id
                completion(true)

            default:
                completion(false)
            }
        }
    }
    
    func postPhoto(_ photo: UIImage, completion: @escaping (Bool) -> Void) {
        //let data: MultipartFormData = .
        
        AF.request(base + "/daily_photo", method: .post, parameters: ["file": photo.pngData()!], encoder: URLEncodedFormParameterEncoder.default).responseDecodable(of: EmptyResp.self) { res in
            switch res.result {
            case let .success(resp):
               // self?.token = resp.data?.token
                //self?.userId = resp.data?.id
                completion(resp.success)

            default:
                completion(false)
            }
        }
        
//        AF.request(base + "/signin/", method: .post, parameters: ["photo": photo.pngData()] as [String: String], encoder: JSONParameterEncoder.default).responseDecodable(of: SignInResp.self) { [weak self] result in
////            switch result.result {
////            case let .success(resp) where resp.data?.id != nil:
////               // self?.token = resp.data?.token
////                self?.userId = resp.data?.id
////                completion(true)
////
////            default:
////                completion(false)
////            }
//        }
    }
    
    func fetchStats(completion: @escaping (StatsResp?) -> Void) {
        AF.request(base + "/stats", method: .get).responseDecodable(of: StatsResp.self) { [weak self] result in
            switch result.result {
            case let .success(resp):
                completion(resp)

            default:
                completion(nil)
            }
        }
    }
    
    struct Contact: Encodable {
        let name: String
        let surname: String
        let tel: String
    }
    
    func uploadContacts(_ contacts: [Contact], completion: @escaping (Bool) -> Void) {
        AF.request(base + "/contacts/", method: .post, parameters: contacts, encoder: JSONParameterEncoder.default).responseDecodable(of: EmptyResp.self) { [weak self] result in
            switch result.result {
            case let .success(resp):
               // self?.token = resp.data?.token
//                self?.userId = resp.data?.id
                completion(resp.success)

            default:
                completion(false)
            }
        }
    }
    
    func getSyms(completion: @escaping ([Int: String]) -> Void) {
        AF.request(base + "/symptom_list", method: .get).responseDecodable(of: SymListResp.self) { [weak self] result in
            switch result.result {
            case let .success(resp):
                
//                var
//                for (key, val) in resp.data.map { ($0.id, $0.title) } {
//
//                }
                completion(resp.data.reduce([Int:String]()) { dict, entry in
                    var dict = dict
                    dict[entry.id] = entry.title
                    return dict
                })
               // self?.token = resp.data?.token
//                self?.userId = resp.data?.id
                //completion(resp.success)

            default:
                completion([:])
            }
        }
    }
    
    func postSyms(_ syms: [Int], completion: @escaping (Bool) -> Void) {
        AF.request(base + "/day_symptoms/", method: .post, parameters: syms, encoder: JSONParameterEncoder.default).responseDecodable(of: EmptyResp.self) { [weak self] result in
            switch result.result {
            case let .success(resp):
               // self?.token = resp.data?.token
//                self?.userId = resp.data?.id
                completion(resp.success)

            default:
                completion(false)
            }
        }
    }
    
    func fetchContactsInfo(completion: @escaping (ContactsResp.Contacts?) -> Void) {
        AF.request(base + "/contacts_info", method: .get).responseDecodable(of: ContactsResp.self) { [weak self] result in
            switch result.result {
            case let .success(resp):
                completion(resp.data)

            default:
                completion(nil)
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
        fm.dateFormat = "yyyy-MM-dd HH:mm:ss"
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

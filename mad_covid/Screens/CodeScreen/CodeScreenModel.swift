//
//  CodeScreenModel.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 16.09.2021.
//

import SwiftUI

class CodeScreenModel: ObservableObject {
    
    let service: NetworkService = .shared
    
    @Published
    var alarm = false
    var alarmText = "" {
        didSet {
            alarm = true
        }
    }

    @Published
    var qrImage: URL?
    
    @Published
    var err = false
    
    init() {
        fetchQr()
    }
    
    func fetchQr() {
        guard reach.isReachable else {
            alarmText = "No internet"
            return
        }
        service.fetchQr { [weak self] image in
            if let image = image {
                self?.qrImage = image
            } else {
                self?.err = true
            }
        }
    }
    
//    func signIn() {
//        guard login.contains("@") else {
//            alarmText = "Invalid email"
//            return
//        }
//        guard reach.isReachable else {
//            alarmText = "No internet"
//            return
//        }
//        withAnimation {
//            err = false
//        }
//        service.signIn(login: login, password: password) { [weak self] res in
//            DispatchQueue.main.async {
//                if res {
//                    self?.mainActive = true
//                } else {
//                    withAnimation {
//                        self?.err = true
//                    }
//                }
//            }
//        }
//    }
}

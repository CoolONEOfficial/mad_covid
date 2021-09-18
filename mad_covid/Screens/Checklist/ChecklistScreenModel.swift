//
//  ChecklistScreenModel.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 18.09.2021.
//

import Foundation

import SwiftUI

class ChecklistScreenModel: ObservableObject {
    @Published
    var selected: [Int] = []

    @Published
    var syms: [Int: String] = [:]
    
//    @Published
//    var login: String = ""
//
//    @Published
//    var password: String = ""
//
//    @Published
//    var mainActive: Bool = false
    
    let service: NetworkService = .shared
    
    @Published
    var alarm = false
    var alarmText = "" {
        didSet {
            alarm = true
        }
    }

    init() {
        service.getSyms { [weak self] dict in
            self?.syms = dict
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

//
//  SigninScreenModel.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 16.09.2021.
//

import SwiftUI

class SigninScreenModel: ObservableObject {
    @Published
    var err: Bool = false
    
    @Published
    var login: String = ""
    
    @Published
    var password: String = ""

    @Published
    var mainActive: Bool = false
    
    let service: NetworkService = .shared
    
    @Published
    var alarm = false
    var alarmText = "" {
        didSet {
            alarm = true
        }
    }

    func signIn() {
        guard login.contains("@") else {
            alarmText = "Invalid email"
            return
        }
        guard reach.isReachable else {
            alarmText = "No internet"
            return
        }
        withAnimation {
            err = false
        }
        service.signIn(login: login, password: password) { [weak self] res in
            DispatchQueue.main.async {
                if res {
                    self?.mainActive = true
                } else {
                    withAnimation {
                        self?.err = true
                    }
                }
            }
        }
    }
}

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
    
    func signIn() {
        guard login.contains("@") else { return }
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

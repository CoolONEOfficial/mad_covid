//
//  MainScreenModel.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 16.09.2021.
//

import Foundation

import SwiftUI

class MainScreenModel: ObservableObject {
    let service: NetworkService = .shared
    
    @Published
    var symts: [Sym] = []
    
    var symToday: Sym? {
//        let df = DateFormatter()
//        df.dateFormat = ISO8601DateFormatter
        return symts.first {
            //if let datee = df.date(from: $0.date) {
            $0.date.day == Date().day
            //}
            return false
        }
    }
    
    init() {
        service.fetchSymts { [weak self] res in
            self?.symts = res
        }
    }
}

extension Date {
    var day: Int? {
        let cal = Calendar.current
        return cal.dateComponents([.day], from: self).day!
    }
}
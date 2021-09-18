//
//  IntDesc.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 18.09.2021.
//

import Foundation

extension Int {
    var desc: String {
        self > 0 ? "+\(self)" : "\(self)"
    }
}

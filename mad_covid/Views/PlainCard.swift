//
//  PlainCard.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 16.09.2021.
//

import SwiftUI

struct PlainCard<T: View>: View {
    internal init(redColor: Bool = false, subview: @escaping () -> (T)) {
        self.subview = subview
        self.redColor = redColor
    }
    
    let subview: () -> (T)

    let redColor: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            subview()
        }.padding(16)
            .backgroundColor(redColor ? Color(hex: 0xD60067) : Color.card)
            .cornerRadius(20)
            
    }
}

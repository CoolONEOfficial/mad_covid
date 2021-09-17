//
//  ErrCard.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 16.09.2021.
//

import SwiftUI


struct ErrCard: View {
    let title: String

    var body: some View {
        HStack(spacing: 16) {
            Text(title).font(.custom(14)).frame(maxWidth: .infinity)
            Spacer()
            Image("err").resizedToFit(16)
        }.padding(16)
            .backgroundColor(.err)
            .cornerRadius(20)
            
    }
}

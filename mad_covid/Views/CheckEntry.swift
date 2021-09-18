//
//  CheckEntry.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 18.09.2021.
//

import SwiftUI

struct CheckEntry: View {
    @Binding
    var isActive: Bool
    
    let text: String
    
    var body: some View {
        HStack(spacing: 11) {
            Image(isActive ? "checkOn" : "checkOff").resizedToFill(23)
            Text(text).font(.custom(18)).multilineTextAlignment(.leading)
            Spacer()
        }.onTapGesture {
            isActive.toggle()
        }
    }
}

//struct CheckEntry_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckEntry()
//    }
//}

//
//  SymCard.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 16.09.2021.
//

import SwiftUI

struct SymCard: View {

    let sym: Sym
    
    var body: some View {
        VStack(spacing: 0) {
            let health = sym.probability_infection <= 0
            Text(health ? "CLEAR" : "CALL TO DOCTOR").font(.system(size: 24, weight: .bold)).height(42).frame(maxWidth: .infinity).backgroundColor(health ? .cardHealth : .cardInfected)
            

            VStack(alignment: .leading, spacing: 0) {
                
                HStack(spacing: 25) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Name").font(.system(size: 12))
                        Text("John Doe").font(.system(size: 24, weight: .bold))
                    }.width(110)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Date and Time").font(.system(size: 12))
                        HStack(spacing: 0) {
                            Text("02/08").font(.system(size: 24, weight: .bold))
                            Text("/2021   06:58AM").font(.system(size: 14)).padding(.top, 4)
                            Spacer()
                        }
                    }
                }.padding(.bottom, 20)
                
                Text(health ? "* Wear mask.  Keep 2m distance.  Wash hands." : "You may be infected with a virus").font(.system(size: 14))
                
            }.padding(16)
            
            Rectangle().fill(.white).opacity(0.2).height(1)
            
            VStack(alignment: .leading, spacing: 0) {
                Button(action: {
                    let str: String
                    let date = Date().formatted(date: .short, time: .none)
                    if health {
                        str = "As of \(date), it is likely that I am healthy (but this is not certain)"
                    } else {
                        str = "As of \(date), there is a possibility that I have a covid"
                    }
                    
                    // TODO: share text
                }) {
                    Image("share").resizedToFit(20)
                }
            }.padding(16)
        }
        .foregroundColor(.white)
        .backgroundColor(.card)
        .cornerRadius(20)
            
    }
}

struct SymCard_Previews: PreviewProvider {
    static var previews: some View {
        SymCard(sym: .init(date: .init(), probability_infection: 12)).width(359)
        SymCard(sym: .init(date: .init(), probability_infection: 92)).width(359)
    }
}


//
//  MainScreen.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 16.09.2021.
//

import SwiftUI

struct MainScreen: View {
    @StateObject
    var vm = MainScreenModel()

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Group {
                ZStack {
                    Text("WSA Care").font(.system(size: 24, weight: .bold))
                    HStack {
                        Spacer()
                        Image("qr").resizedToFit(24)
                    }
                }.padding(.bottom, 31).frame(maxWidth: .infinity)
                
                Text("Aug 2, 2021").font(.system(size: 16, weight: .bold)).padding(.bottom, 18)
                
                PlainCard {
                    HStack {
                        Text("No case").font(.system(size: 14, weight: .bold))
                        Text("in skill area in the last 14 days").font(.system(size: 14))
                        Spacer()
                    }
                }.padding(.bottom, 12)
                
                if let sym = vm.symToday {
                    
                } else {
                    ErrCard(title: "You haven’t report today’s health status.")
                }
            }
            
            Spacer()
            
            if false {
                Group {
                    Text("John,").font(.system(size: 28))
                    Text("How are you feeling today?").font(.system(size: 24, weight: .bold)).padding(.bottom, 20)
                    
                    Button("Check in now") {
                        
                    }.buttonStyle(BS.plain).height(72)
                    
                    Button(action: {}) {
                        VStack(spacing: 0) {
                            Text("Why do this?").font(.system(size: 13)).background(Rectangle().fill(.white).height(1), alignment: .bottom)
                            
                        }
                    }
                }
            } else {
                Group {
                    Spacer()
                    Image("checkmark").resizedToFit(28).padding(.bottom, 8)
                    Text("You have checked in today.").font(.system(size: 18))
                    Text("Re-check in").font(.system(size: 13)).background(Rectangle().fill(.white).height(1), alignment: .bottom).padding(.top, 8)
                }
            }
            Spacer()
        }.padding(.horizontal, 18)
    
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

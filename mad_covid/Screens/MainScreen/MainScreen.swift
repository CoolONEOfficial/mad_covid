//
//  MainScreen.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 16.09.2021.
//

import SwiftUI
import DynamicColor
import PureSwiftUI

struct MainScreen: View {
    @StateObject
    var vm = MainScreenModel()

    @State
    var qrOpen = false
    
    @State
    var checkOpen = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Group {
                ZStack {
                    Text("WSA Care").font(.custom(24).bold())
                    HStack {
                        Spacer()
                        Button(action: {
                            qrOpen = true
                        }) {
                            Image("qr").resizedToFit(24)
                        }
                        NavigationLink("", isActive: $qrOpen) {
                            CodeScreen(opened: $qrOpen).backgroundColor(.bg).foregroundColor(.white)
                        }.hidden()
                    }
                }.padding(.bottom, 31).frame(maxWidth: .infinity)
                
                Text("Aug 2, 2021").font(.custom(16).bold()).padding(.bottom, 18)
                
                let cases = vm.cases ?? 0
                if cases == 0 {
                    PlainCard {
                        HStack {
                            Text("No case").font(.custom(14).bold())
                            Text("in skill area in the last 14 days").font(.custom(14))
                            Spacer()
                        }
                    }.padding(.bottom, 12)
                } else {
                    PlainCard(redColor: true) {
                        HStack {
                            Text("\(cases) cases").font(.custom(14).bold())
                            Text("in skill area in the last 14 days").font(.custom(14))
                            Spacer()
                        }
                    }.padding(.bottom, 12)   
                }
                
                if let sym = vm.symToday {
                    SymCard(sym: sym)
                } else {
                    ErrCard(title: "You haven’t report today’s health status.")
                }
                
                Slider(stats:  vm.stats ??  .mock).padding(.top, 13)
                
                if let syms = vm.symts {
                    Timeline(syms: syms).padding(.top, 17)
                }
            }
            
            Spacer()
            
            if vm.symToday == nil {
                Group {
                    Text("John,").font(.custom(28))
                    Text("How are you feeling today?").font(.custom(24).bold()).padding(.bottom, 20)
                    
                    
//                    Button(action: {
//                        checkOpen = true
//                    }) {
//                        Text("Re-check in").font(.custom(13)).background(Rectangle().fill(.white).height(1), alignment: .bottom).padding(.top, 8)
//                    }
                    NavigationLink("Check in now", isActive: $checkOpen) {
                        ChecklistScreen(opened: $checkOpen).backgroundColor(.bg).foregroundColor(.white)
                    }.buttonStyle(BS.plain).height(72)
                    
//                    Button("Check in now") {
//
//                    }.buttonStyle(BS.plain).height(72)
                    
                    Button(action: {}) {
                        VStack(spacing: 0) {
                            Text("Why do this?").font(.custom(13)).background(Rectangle().fill(.white).height(1), alignment: .bottom)
                            
                        }
                    }
                }
            } else {
                Group {
                    Spacer()
                    Image("checkmark").resizedToFit(28).padding(.bottom, 8)
                    Text("You have checked in today.").font(.custom(18))
                    
                    Button(action: {
                        checkOpen = true
                    }) {
                        Text("Re-check in").font(.custom(13)).background(Rectangle().fill(.white).height(1), alignment: .bottom).padding(.top, 8)
                    }
                    NavigationLink("", isActive: $checkOpen) {
                        ChecklistScreen(opened: $checkOpen).backgroundColor(.bg).foregroundColor(.white)
                    }.hidden()
                    
                    
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

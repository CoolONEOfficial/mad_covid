//
//  ChecklistScreen.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 18.09.2021.
//

import PureSwiftUI
import SwiftUI

struct ChecklistScreen: View {
    
    @StateObject
    var vm = ChecklistScreenModel()
    
    @Binding
    var opened: Bool
    
    @State
    var confirmAlert = false
    
    @State
    var photo: UIImage?
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 0) {
                Group {
                    ZStack {
                        Text("Checklist").font(.custom(24).bold()).padding(.top, 20)
                        HStack {
                            Button(action: {
                                opened = false
                            }) {
                                Image("navBack").resizedToFit(24).padding(.leading, 34).padding(.top, 20)
                            }
                            Spacer()
                        }
                    }.padding(.bottom, 31).frame(maxWidth: .infinity)

    //                if let url = vm.qrImage {
    //                    Text("""
    //Use this QR-code in restaraunts and aerports
    //You can’t give it to anyone else
    //""").align(.center).font(.custom(14))
    //
    //                    WebImage(url: url).resizable()
    //                        .aspectRatio(contentMode: .fit)
    //                        .width(257).height(257)
    //                } else if vm.err {
    //                    ErrCard(title: "You need to have access to internet").padding(.top, 100).padding(.bottom, 20).padding(.horizontal, 18)
    //
    //                    Button(action: {}) {
    //                        VStack(spacing: 0) {
    //                            Text("Try again").font(.custom(13)).background(Rectangle().fill(.white).height(1), alignment: .bottom)
    //
    //                        }
    //                    }
    //                }
                    
                    Text("Aug 2, 2021").font(.custom(16).bold()).padding(.bottom, 39)
                    
                    Text("""
Have you had any of the following symptoms in the last 24 hours ?
""").multilineTextAlignment(.leading).font(.custom(18).bold()).padding(.bottom, 16).padding(.horizontal, 32)
                    
                    Rectangle().fill(.white).height(1).padding(.horizontal, 32).padding(.bottom, 32).opacity(0.2)
                    
                    let syms = Array(vm.syms.enumerated()).map(\.element).sorted { $0.key < $1.key }
                    ForEach(0..<syms.count, id: \.self) { index in
                        let entry = syms[index]
                        
                        CheckEntry(isActive: .init(get: { vm.selected.contains(entry.key) }, set: {
                            if $0 {
                                vm.selected.append(entry.key)
                            } else {
                                vm.selected.remove(at: vm.selected.firstIndex(of: entry.key)!)
                            }
                        }), text: entry.value).padding(.horizontal, 32).padding(.bottom, 14)
                    }
                    
                    ChecklistPhoto(photo: $photo).padding(.bottom, 8).padding(.horizontal, 81)
                    
                    Button("Confirm") {
                        NetworkService.shared.postSyms(vm.selected, completion: {
                            if $0 {
                                if let photo = self.photo {
                                    NetworkService.shared.postPhoto(photo) {
                                        if $0 {
                                            opened = false
                                        }
                                    }
                                } else {
                                    opened = false
                                }
                            }
                        })
                    }.buttonStyle(BS.plainNoRight).padding(.top, 8).alert(isPresented: $confirmAlert) {
                        Alert(title: Text("Are you sure?"), message: nil, primaryButton: Alert.Button.default(Text("Yep")) {}, secondaryButton: Alert.Button.cancel(Text("Nope")) {})
                    }
                    
                    Text("Don’t want to answer for now.").font(.custom(13)).background(Rectangle().fill(.white).height(1), alignment: .bottom).padding(.top, 18)
                }
            }
        }.navigationBarHidden(true)
    }
}

//struct ChecklistScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        ChecklistScreen()
//    }
//}



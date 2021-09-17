//
//  CodeScreen.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 16.09.2021.
//

import PureSwiftUI
import SwiftUI
import DynamicColor
import SwiftUIX
import SDWebImageSwiftUI

struct CodeScreen: View {

    @StateObject
    var vm = CodeScreenModel()
    
    @Binding
    var opened: Bool
    

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Group {
                ZStack {
                    Text("QR code").font(.custom(24).bold()).padding(.top, 20)
                    HStack {
                        Button(action: {
                            opened = false
                        }) {
                            Image("navBack").resizedToFit(24).padding(.leading, 34).padding(.top, 20)
                        }
                        Spacer()
                    }
                }.padding(.bottom, 31).frame(maxWidth: .infinity)

                if let url = vm.qrImage {
                    Text("""
Use this QR-code in restaraunts and aerports
You can’t give it to anyone else
""").align(.center).font(.custom(14))

                    WebImage(url: url).resizable()
                        .aspectRatio(contentMode: .fit)
                        .width(257).height(257)
                } else if vm.err {
                    ErrCard(title: "You need to have access to internet").padding(.top, 100).padding(.bottom, 20).padding(.horizontal, 18)
                    
                    Button(action: {}) {
                        VStack(spacing: 0) {
                            Text("Try again").font(.custom(13)).background(Rectangle().fill(.white).height(1), alignment: .bottom)
                            
                        }
                    }
                }
                
            }
            Spacer()
        }.navigationBarHidden(true)
    }
}

//struct CodeScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        CodeScreen()
//    }
//}

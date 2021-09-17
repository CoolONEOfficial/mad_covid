//
//  SigninScreen.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 16.09.2021.
//

import PureSwiftUI
import SwiftUI
import DynamicColor

struct SigninScreen: View {
    
    @StateObject
    var vm = SigninScreenModel()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 0) {
                Group {
                    Text("Sign in").font(.custom(24)).padding(.vertical, 40)
                    Text("if you don’t have account credentials, you can take it in near hospital in your city after vaccination").font(.custom(14)).padding(.vertical, 27)
                    HStack {
                        Text("Your login").font(.custom(14)).padding(.bottom, 12)
                        Spacer()
                    }
                    TextField("", text: $vm.login).modifier(TFBackground()).padding(.bottom, 45)
                    HStack {
                        Text("Your password").font(.custom(14)).padding(.bottom, 12)
                        Spacer()
                    }
                    SecureField("", text: $vm.password).modifier(TFBackground())
                }
                
                if vm.err {
                    ErrCard(title: "We can’t find account with this credentials").padding(.top, 52)
                }
                
                Button(action: {
                    vm.signIn()
                }, label: {
                    Text("Sign in").width(.infinity)
                }).buttonStyle(BS.plain).padding(.top, 52).fullScreenCover(isPresented: $vm.mainActive, onDismiss: nil, content: {
                    ContentView()
                })
            }.padding(.horizontal, 18)
                .alert(isPresented: $vm.alarm) {
                    Alert(title: Text(vm.alarmText), message: nil, dismissButton: nil)
                }
        }
    }
}

struct TFBackground: ViewModifier {
    func body(content: Content) -> some View {
        content.height(50).backgroundColor(.white).clipRoundedRectangle(20).foregroundColor(.black)
    }
}

struct SigninScreen_Previews: PreviewProvider {
    static var previews: some View {
        SigninScreen()
    }
}


struct BS {
    static let plain = PlainButtonStyle()
}

struct PlainButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label.foregroundColor(.bg)
            Image("right").resizable().frame(width: 16, height: 10)
        }.width(180).padding(16).backgroundColor(.white).clipRoundedRectangle(25)
    }
}

//struct Test: textField {
//
//}

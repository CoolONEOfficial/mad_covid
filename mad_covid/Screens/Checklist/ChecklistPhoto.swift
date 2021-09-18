//
//  ChecklistPhoto.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 18.09.2021.
//

import SwiftUI
import PureSwiftUI
import MediaSwiftUI
import MediaCore

struct ChecklistPhoto: View {
    @Binding var photo: UIImage?
    
    @State var photoOpen = false
    
    @ViewBuilder
    var img: some View {
        if let photo = photo {
            ZStack(alignment: .topTrailing) {
                Image(uiImage: photo).resizedToFill(94)
                Image("removeImg").resizedToFill(29).onTapGesture {
                    self.photo = nil
                }.padding(4)
            }
        } else {
            Image("placeholder").resizedToFit(94).onTapGesture {
                if Media.currentPermission == .authorized {
                    self.photoOpen = true
                } else {
                    Media.requestPermission { res in
                        switch res {
                        case .success:
                            self.photoOpen = true
                            
                        default: break
                        }
                    }
                }
            }.fullScreenCover(isPresented: $photoOpen, onDismiss: nil, content: {
                Photo.browser(isPresented: $photoOpen) { res in
                    if let img = try? res.get() {
                        switch img.first! {
                        case let .media(med):
                             med.uiImage(targetSize: .init(94), contentMode: .default) {
                                 switch $0 {
                                 case let .success(img):
                                     self.photo = img.value
                                     
                                 default: break
                                 }
                                 //self.photo = try? $0.get()
                            }
                            
                        case let .data(dat):
                            self.photo = dat
                        }
                    }
                }
            })
            
            
        }
    }
    
    var body: some View {
        VStack {
            img.width(94).height(94).clipped()
            Text(photo == nil ? """
Add your photo for check you health
with neural networks
""" : "").font(.custom(13)).height(44).multilineTextAlignment(.center)
        }
    }
}

//struct ChecklistPhoto_Previews: PreviewProvider {
//    static var previews: some View {
//        ChecklistPhoto()
//    }
//}

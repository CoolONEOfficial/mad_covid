//
//  Slider.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 17.09.2021.
//

import SwiftUI
import SwiftUIPager
import SwiftUIX

extension Int: Identifiable {
    public var id: Int { self }
}

struct Slider: View {
    @State
    var page: Page = .first()
    
    let pagesCount = 4
    
    @State
    var pageIndex = 0
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 5) {
                Text("144501").font(.custom(32).bold()).adjustsFontSizeToFitWidth(true)
                Text("Infection cases").font(.custom(14)).opacity(0.9)
            }.padding(16)
            Spacer()
            ZStack {
                Image("map").resizedToFill().overlayColor(Color.card.opacity(0.9))
                
                VStack {
                    ZStack(alignment: .trailing) {
                        Pager(page: page, data: 0..<pagesCount) { index in
                            switch index {
                            case 0:
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Over all world").font(.custom(20).bold())
                                    Text("56 cases in your city").font(.custom(14)).opacity(0.9)
                                }
                                
                            case 1:
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Over all world").font(.custom(20).bold())
                                    Text("2 death in your city").font(.custom(14)).opacity(0.9)
                                }
                                
                            case 2:
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("40% - adults").font(.custom(20).bold())
                                    Text("55% - young").font(.custom(20).bold())
                                }
                                
                            default:
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("People vaccinated").font(.custom(20).bold())
                                    Text("""
It’s very bad result
for making world safe
""").font(.custom(14)).opacity(0.9)
                                }
                            }
                            
                        }.vertical().onPageChanged { index in
                            pageIndex = index
                        }
                        VStack(spacing: 5) {
                            ForEach(0..<pagesCount) { index in
                                Circle().fill(.white).opacityIf(index != self.pageIndex, 0.3).frame(width: 5, height: 5)
                            }
                        }
                    }
                    
                }.padding(16)
            }.height(104)
        }
            .backgroundColor(Color.card)
            .cornerRadius(20)
    }
}

struct Slider_Previews: PreviewProvider {
    static var previews: some View {
        Slider().foregroundColor(.white).width(339)
    }
}

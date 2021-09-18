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
    let stats: StatsResp
    
    @State
    var page: Page = .first()
    
    let pagesCount = 4
    
    @State
    var pageIndex = 0
    
    @ViewBuilder
    func content(_ index: Int ) -> some View {
        switch index {
        case 0:
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 5) {
                    Text((stats.data.world.infected ?? 0).desc).font(.custom(32).bold()).adjustsFontSizeToFitWidth(true)
                    Text("Infection cases").font(.custom(14)).opacity(0.9)
                }.padding(16)
                Spacer()
                ZStack(alignment: .leading) {
                    Image("map").resizedToFill().overlayColor(Color.card.opacity(0.9))
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Over all world").font(.custom(20).bold())
                        Text("\((stats.data.current_city.infected ?? 0).desc) cases in your city").font(.custom(14)).opacity(0.9)
                    }.padding(.leading, 16)
                        .padding(.trailing, 32)
                }
            }
        case 1:
            
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 5) {
                    Text((stats.data.world.death ?? 0).desc).font(.custom(32).bold()).adjustsFontSizeToFitWidth(true)
                    Text("Deaths").font(.custom(14)).opacity(0.9)
                }.padding(16)
                Spacer()
                ZStack(alignment: .leading) {
                    Image("map").resizedToFill().overlayColor(Color.card.opacity(0.9))
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Over all world").font(.custom(20).bold())
                        Text("\((stats.data.current_city.death ?? 0).desc) death in your city").font(.custom(14)).opacity(0.9)
                    }.padding(.leading, 16)
                        .padding(.trailing, 32)
                }
            }
            
        case 2:
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text((stats.data.world.recovered ?? 0).desc).font(.custom(32).bold()).adjustsFontSizeToFitWidth(true)
                    Text("Recovered").font(.custom(14)).opacity(0.9)
                }.padding(16)
                Spacer()
                ZStack(alignment: .leading) {
                    Image("map").resizedToFill().overlayColor(Color.card.opacity(0.9))
                    let world = stats.data.world
                    let overall = world.recovered
                    let adults = overall == 0 ? 50 : ( world.recovered_adults / overall * 100)
                    
                    let yung = overall == 0 ? 50 : ( world.recovered_young / overall * 100)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(adults)% - adults").font(.custom(20).bold())
                        Text("\(yung)% - young").font(.custom(20).bold())
                    }.padding(.leading, 16)
                        .padding(.trailing, 32)
                }
            }
            
            
        default:
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("45%").font(.custom(32).bold()).adjustsFontSizeToFitWidth(true)
                    Text("in your country").font(.custom(14)).opacity(0.9)
                }.padding(16)
                Spacer()
                ZStack(alignment: .leading) {
                    Image("map").resizedToFill().overlayColor(Color.card.opacity(0.9))
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("People vaccinated").font(.custom(20).bold())
                        Text("""
        It’s very bad result
        for making world safe
        """).font(.custom(14)).opacity(0.9)
                    }.padding(.leading, 16)
                        .padding(.trailing, 32)
                }
            }
            
        }
    }
    
    var body: some View {
        
        ZStack(alignment: .trailing) {
            Pager(page: page, data: 0..<pagesCount) { index in
                
                content(index).height(104).clipped()
            }.vertical().onPageChanged { index in
                pageIndex = index
            }
            VStack(spacing: 5) {
                ForEach(0..<pagesCount) { index in
                    Circle().fill(.white).opacityIf(index != self.pageIndex, 0.3).frame(width: 5, height: 5)
                }
            }.padding(16)
        }
        .backgroundColor(Color.card)
            .cornerRadius(20).height(104)
        
        
    }
}

struct Slider_Previews: PreviewProvider {
    static var previews: some View {
        Slider(stats: .init(data: .init(world: .init(infected: 0, death: 0, recovered: 0, vaccinated: 0, recovered_adults: 0, recovered_young: 0), current_city: .init(infected: 0, death: 0, recovered: 0, vaccinated: 0, recovered_adults: 0, recovered_young: 0)))).foregroundColor(.white).width(339)
    }
}

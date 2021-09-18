//
//  Slider.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 17.09.2021.
//

import SwiftUI
import SwiftUIPager
import SwiftUIX
import SwiftyContacts

extension Int: Identifiable {
    public var id: Int { self }
}

struct Slider: View {
    let stats: StatsResp
    
    @State
    var page: Page = .first()
    
    let pagesCount = 5
    
    @State
    var pageIndex = 0
    
    @State
    var info: ContactsResp.Contacts?
    
    @ViewBuilder
    func content(_ index: Int ) -> some View {
        switch index {
        case 0:
            if let info = info {
                contactsInfoView(info)
            } else {
            contacts
            }
            
        case 1:
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
        case 2:
            
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
            
        case 3:
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
    
    func contactsInfoView(_ info: ContactsResp.Contacts) -> some View {
        HStack(spacing: 0) {
            VStack(spacing: 5) {
                let num = info.cases
                Text("\(num) cases").font(.custom(32).bold()).adjustsFontSizeToFitWidth(true).foregroundColor(num > 0 ? .init(hex: 0xD60067) : num < 0 ? .init(hex: 0x00D668) : .white)
                Text("in your contacts list").font(.custom(14)).opacity(0.9)
            }
            Spacer()
            VStack(spacing: 5) {
                let num = info.vaccinated
                Text("\(num.desc) person").font(.custom(32).bold()).adjustsFontSizeToFitWidth(true).foregroundColor(num < 0 ? .init(hex: 0xD60067) : num > 0 ? .init(hex: 0x00D668) : .white)
                Text("vaccinated and in safe").font(.custom(14)).opacity(0.9)
            }
        }.padding(.leading, 16)
            .padding(.trailing, 32)
    }
    
    var contacts: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Be sure").font(.custom(32).bold()).adjustsFontSizeToFitWidth(true)
                Text("That you in safe").font(.custom(14)).opacity(0.9)
            }.padding(16)
            Spacer()
            ZStack(alignment: .leading) {
                Image("map").resizedToFill().overlayColor(Color.card.opacity(0.9))
                
                VStack(alignment: .leading, spacing: 0) {
                    //Text("People vaccinated").font(.custom(20).bold())
                    Text("""
    Upload your contacts
    to our server and we will keep you in touch about infection cases
    """).font(.custom(14)).opacity(0.9)
                }.padding(.leading, 16)
                    .padding(.trailing, 32)
            }
        }.onTapGesture {
            requestAccess { access in
                guard access else { return }
                
                fetchContacts { res in
                    switch res {
                    case let .success(contacts):
                        let contactsNew: [NetworkService.Contact] = contacts.compactMap {
                            guard let num = $0.phoneNumbers.first?.value.stringValue else { return nil }
                            return NetworkService.Contact.init(name: $0.givenName, surname: $0.familyName, tel: num)
                            
                        }
                        
                        
                        NetworkService.shared.uploadContacts(contactsNew, completion: { res in
                            guard res else { return }
                            
                            getContacts()
                        })
                    default:
                        break
                    }
                    
                }
            }
        }
    }
    
    func getContacts() {
        NetworkService.shared.fetchContactsInfo { info in
            guard let info = info else { return }
            
            self.info = info
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

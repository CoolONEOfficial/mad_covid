//
//  Timeline.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 17.09.2021.
//

import SwiftUI
import SwiftUIX
import DynamicColor

struct Timeline: View {
    let syms: [Sym]
    
    func color(_ sym: Sym?) -> Color {
        let color: Color
        if let sym = sym {
            color = sym.probability_infection > 60 ? Color.cardInfected : Color.timelineTitle
        } else {
            color = .init(hex: 0xDBDBDB)
        }
        return color
    }

    
    
    var hstack: some View {
        HStack(spacing: 0) {
//            let todayIndex = syms.suffix(7).firstIndex { $0.date.day == Date().day }
            let startWeek = Calendar.current.date(byAdding: .day, value: -Date().weekDay, to: .init())!
            ForEach(0..<7) { index in
                
                let weekday = Date().weekDay
                let isToday = weekday == index
                
                let date = Calendar.current.date(byAdding: .day, value: index, to: startWeek)!
                //let isToday = false
                let sym = syms.first { $0.date.year == date.year && $0.date.month == date.month && $0.date.day == date.day }//.suffix(7).indices.contains(index) ? syms[index] : nil
                let color = color(sym)
                
                if index != 0 {
                   // let lineColor: Color
//                    if let todayIndex = todayIndex {
//
//                    } else {
//                        lineColor = .init(hex: 0x0055D6)
//                    }
                    Rectangle().fillColor(color).height(1.5).width(16)
                }
                
                ZStack {
                    if color == .init(hex: 0xDBDBDB) {
                        Circle().fill(.white).strokeCircle(color, lineWidth: 1.5)
                    } else {
                    Circle().fill(color)
                    
                    Circle().fill(color).strokeCircle(.white, lineWidth: 1.5).padding(2)
                    }
                    
                }.frame(width: isToday ? 18 : 12, height: isToday ? 18 : 12)
                
                
            }
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            Text("Current week").foregroundColor(.timelineTitle).font(.custom(14))
            Spacer()
            hstack
        }.padding(.vertical, 12).padding(.horizontal, 16).backgroundFill(.white).cornerRadius(16)
    }
}

extension Date {
    var weekDay: Int {
        let comps = Calendar.current.dateComponents([.weekday], from: self)
        var weekday = comps.weekday! - Calendar.current.firstWeekday
        if weekday < 0 {
            weekday += 7
        }
        return weekday - 1
    }

    var month: Int {
        let comps = Calendar.current.dateComponents([.month], from: self)
        return comps.month!
    }
    
    var year: Int {
        let comps = Calendar.current.dateComponents([.year], from: self)
        return comps.year!
    }
}

struct Timeline_Previews: PreviewProvider {
    static var previews: some View {
        Timeline(syms: [ .init(date: .init(), probability_infection: 10), .init(date: .init(), probability_infection: 90) ]).width(337).padding(100).backgroundFill(.black)
    }
}

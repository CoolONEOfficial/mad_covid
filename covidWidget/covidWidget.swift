//
//  covidWidget.swift
//  covidWidget
//
//  Created by Nickolay Truhin on 17.09.2021.
//

import WidgetKit
import SwiftUI
import SDWebImageSwiftUI

struct Provider: TimelineProvider {
    
    static let qrBig: UIImage = {
        
        let im = UIImage(named: "qrBig")
        debugPrint("im \(im)")
        return im!
    }()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), qr: Provider.qrBig, stats: .init(data: .init(world: .init(infected: 0, death: 0, recovered: 0, vaccinated: 0, recovered_adults: 0, recovered_young: 0), current_city: .init(infected: 0, death: 0, recovered: 0, vaccinated: 0, recovered_adults: 0, recovered_young: 0))))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        if context.isPreview {
            let entry = SimpleEntry(date: Date(), qr: Provider.qrBig, stats: .init(data: .init(world: .init(infected: 0, death: 0, recovered: 0, vaccinated: 0, recovered_adults: 0, recovered_young: 0), current_city: .init(infected: 0, death: 0, recovered: 0, vaccinated: 0, recovered_adults: 0, recovered_young: 0))))
                
            completion(entry)
        } else {
            NetworkService.shared.fetchStats { stats in
                NetworkService.shared.fetchQrImage { qr in
                    let entry = SimpleEntry(date: Date(), qr: qr, stats: stats)
                    completion(entry)
                }
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        NetworkService.shared.fetchStats { stats in
            NetworkService.shared.fetchQrImage { qr in
                var entries: [SimpleEntry] = []

                // Generate a timeline consisting of five entries an hour apart, starting from the current date.
                let currentDate = Date()
                for hourOffset in 0 ..< 5 {
                    let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset * 4, to: currentDate)!
                    let entry = SimpleEntry(date: entryDate, qr: qr, stats: stats)
                    entries.append(entry)
                }

                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        }
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let qr: UIImage?
    let stats: StatsResp?
}

struct covidWidgetEntryView : View {
    @Environment(\.widgetFamily) var family

    var entry: Provider.Entry

    @ViewBuilder
    var qrCode: some View {
        let _ = debugPrint("entry: \(entry.qr)")
        if let image = entry.qr {
            Image("qrBig").resizable().padding(16)
        }
    }
    
    var stats: some View {
        VStack(alignment: .leading, spacing: 6) {
            VStack(alignment: .leading, spacing: 0) {
                Text("\((entry.stats?.data.current_city.infected ?? 0).desc) cases").font(.custom(20).bold())
                Text("in your city").font(.custom(20))
                
            }
            Text("\((entry.stats?.data.current_city.vaccinated ?? 0).desc) vaccinated").font(.custom(20))
            Text("\((entry.stats?.data.current_city.recovered ?? 0).desc) recovered").font(.custom(20))
            Spacer()
        }.padding(.vertical, 10).padding(.horizontal, 16).frame(maxWidth: .infinity, maxHeight: .infinity).foregroundColor(.white).background(Color.cardHealth).cornerRadius(22)
    }
    
    var body: some View {
        
        switch family {
        case .systemSmall:
            qrCode
            
        default:
            HStack(spacing: 0) {
                qrCode.frame(maxWidth: .infinity)
                stats
            }
        }
    }
}



@main
struct covidWidget: Widget {
    let kind: String = "covidWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            covidWidgetEntryView(entry: entry)
            
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium, .systemSmall])
    }
}

struct covidWidget_Previews: PreviewProvider {
    static var previews: some View {
        covidWidgetEntryView(entry: SimpleEntry(date: Date(), qr: .init(), stats: .init(data: .init(world: .init(infected: 0, death: 0, recovered: 0, vaccinated: 0, recovered_adults: 0, recovered_young: 0), current_city: .init(infected: 0, death: 0, recovered: 0, vaccinated: 0, recovered_adults: 0, recovered_young: 0)))))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        covidWidgetEntryView(entry: SimpleEntry(date: Date(), qr: .init(), stats: .init(data: .init(world: .init(infected: 0, death: 0, recovered: 0, vaccinated: 0, recovered_adults: 0, recovered_young: 0), current_city: .init(infected: 0, death: 0, recovered: 0, vaccinated: 0, recovered_adults: 0, recovered_young: 0)))))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

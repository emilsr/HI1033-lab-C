//
//  ActivityGraphScreen.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-03.
//

import SwiftUI
import SQLite3

struct ActivityGraphScreen: View {
    @State private var activityData: [ActivityData] = []

    var body: some View {
        VStack {
            Text("Activity Graph")
                .font(.largeTitle)
                .padding()

            if activityData.isEmpty {
                Text("No data available")
                    .foregroundColor(.gray)
            } else {
                ActivityGraphView(data: activityData)
                    .frame(height: 300)
                    .padding()
            }

            Spacer()
        }
        .onAppear(perform: fetchActivityData)
    }

    func fetchActivityData() {
        activityData.removeAll()

        if let db = Database.shared.db {
            let query = "SELECT Month, activityType, value FROM activities;"
            var statement: OpaquePointer?

            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    if let month = sqlite3_column_text(statement, 0),
                       let activityType = sqlite3_column_text(statement, 1) {
                        let monthString = String(cString: month)
                        let activityTypeString = String(cString: activityType)
                        let value = sqlite3_column_int(statement, 2)

                        let data = ActivityData(month: monthString, activityType: activityTypeString, value: Int(value))
                        activityData.append(data)
                    }
                }
            }

            sqlite3_finalize(statement)
        }
    }
}

struct ActivityGraphView: View {
    let data: [ActivityData]

    var body: some View {
        GeometryReader { geometry in
            let groupedData = Dictionary(grouping: data, by: { $0.activityType })
            let colors: [Color] = [.red, .blue, .green, .orange, .purple]
            let maxValue = data.map { $0.value }.max() ?? 1
            let months = Array(Set(data.map { $0.month })).sorted()

            ZStack {
                ForEach(Array(groupedData.keys.enumerated()), id: \..element) { index, activityType in
                    if let activityEntries = groupedData[activityType] {
                        Path { path in
                            for (i, month) in months.enumerated() {
                                if let entry = activityEntries.first(where: { $0.month == month }) {
                                    let xPosition = geometry.size.width / CGFloat(months.count) * CGFloat(i) + geometry.size.width / CGFloat(months.count) / 2
                                    let yPosition = geometry.size.height - (geometry.size.height * CGFloat(entry.value) / CGFloat(maxValue))

                                    if i == 0 {
                                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                                    } else {
                                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                                    }
                                }
                            }
                        }
                        .stroke(colors[index % colors.count], lineWidth: 2)
                    }
                }
            }
        }
    }
}

struct ActivityData {
    let month: String
    let activityType: String
    let value: Int
}

struct ActivityGraphScreen_Previews: PreviewProvider {
    static var previews: some View {
        ActivityGraphScreen()
    }
}

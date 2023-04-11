//
//  TimerView.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 10.04.2023.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State var progress: Double = 0.15
    let dateNow = Date()
    let targetDate = Date(timeIntervalSinceNow: TimeInterval(120))
    @State var dateDiff = Date(timeIntervalSinceNow: TimeInterval(1000)) - Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func calculateTimeLeft(interval: TimeInterval) -> String {
        var roundedInterval = Int(round(interval))
        var timeString = ""
        var dayString = ""

        let days = String((roundedInterval - roundedInterval % 86400)/86400)
        roundedInterval = roundedInterval % 86400
        if days == "1"{
            dayString = "day"
        } else {
            dayString = "days"
        }
        let hours = String((roundedInterval - roundedInterval % 3600)/3600)
        roundedInterval = roundedInterval % 3600
        let minutes = String((roundedInterval - roundedInterval % 60)/60)
        let seconds = String(roundedInterval % 60)
        timeString = "\(days) \(dayString) \(hours):\(minutes):\(seconds)"

        return timeString
    }
    

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .trim(from: 0.15, to: 0.85)
                    .stroke(
                        viewModel.pickedColor.opacity(0.5),
                        style: StrokeStyle(
                            lineWidth: 30,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(90))
                    .padding(32)
                Circle()
                    .trim(from: 0.15, to: progress)
                    .stroke(
                        viewModel.pickedColor,
                        // 1
                        style: StrokeStyle(
                            lineWidth: 30,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(90))
                    .animation(.easeOut, value: progress)

                    .padding(32)
                VStack{
                    Text("Time until next class:")
                        .font(.system(size: 24))
                        .bold()
                        .fontDesign(.rounded)
                    Text(calculateTimeLeft(interval:dateDiff))
                        .font(.system(size: 24))
                        .bold()
                        .fontDesign(.rounded)
                        .padding(4)

                }

            }
            Button(action: {
                UserDefaults.standard.removeObject(forKey: "Classes")
                UserDefaults.standard.removeObject(forKey: "Schedule")
            }){
                Text("go")
            }
        }
        .navigationTitle("Timer")

        .onReceive(timer) { time in
            if progress < 0.85 {
                progress = progress + 0.7/(dateDiff)
                dateDiff = dateDiff - 1
            }
        }

    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}

extension Date {
    func dayNumberOfWeek() -> Int? {
        let ret = Calendar.current.dateComponents([.weekday], from: self).weekday
        if ret != 1{
            return ret! - 1
        } else {
            return 7
        }
    }
}

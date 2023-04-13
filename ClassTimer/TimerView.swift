//
//  TimerView.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 10.04.2023.
//

import SwiftUI
import UserNotifications

struct TimerView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State var progress: Double = 0.15

    @State var timeToNextClass: Double = 100

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func calculateTimeToNextClass() {

        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "en_US")
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm"
        formatter2.locale = Locale(identifier: "en_US")
        let timeNow = formatter2.string(from: today)
        let todayWeekday = dayToDayNumber[formatter.string(from: today)]!
        var nextWeekday = todayWeekday
        var nextTime = ""
        var nextName = ""
        print(todayWeekday)

        while nextTime == ""{
            print(nextWeekday)
            print(nextTime)

            if viewModel.schedule.schedule == [1:[],2:[],3:[],4:[],5:[],6:[],7:[]]{
                break
            }


            if !viewModel.schedule.schedule[nextWeekday]!.isEmpty {
                let lessons  = viewModel.schedule.schedule[nextWeekday]!.sorted(by: {
                    let formatter1 = DateFormatter()
                    formatter1.dateFormat = "HH:mm"
                    return formatter1.date(from: $0.timeStart)! < formatter1.date(from: $1.timeStart)!

                })
                for lesson in lessons {
                    let time = lesson.timeStart
                    if time > timeNow || nextWeekday != todayWeekday{
                        nextTime = time
                        nextName = lesson.name
                        break

                    }
                }


            }
            if nextTime == ""{
                nextWeekday = (nextWeekday) % 7 + 1
            }
        }



        



        var intervalToNextClass: Int = 0
        if nextTime != ""{
            if nextWeekday == todayWeekday{
                let intr: Int = Int(formatter2.date(from: nextTime)! - formatter2.date(from: timeNow)!)
                intervalToNextClass += intr
            } else if nextWeekday > todayWeekday {
                let intr: Int = 60 * 60 * 24 * (nextWeekday - todayWeekday)
                let otherIntr: Int = Int(formatter2.date(from: nextTime)! - formatter2.date(from: timeNow)!)
                intervalToNextClass += intr + otherIntr
            } else {
                let intr: Int = 60 * 60 * 24 * (nextWeekday - todayWeekday + 7)
                let otherIntr: Int = Int(formatter2.date(from: nextTime)! - formatter2.date(from: timeNow)!)
                intervalToNextClass += intr + otherIntr

            }
        }
        if viewModel.countdownStartTime == viewModel.countdownStartClassTime || Date() > viewModel.countdownStartClassTime{
            viewModel.countdownStartTime = Date()
            viewModel.countdownStartClassTime = Date(timeIntervalSinceNow: TimeInterval(intervalToNextClass))
            viewModel.countdownTimeLength = Double(intervalToNextClass)
            viewModel.defaults.set(viewModel.countdownStartTime, forKey: "countdownStartTime")
            viewModel.defaults.set(viewModel.countdownTimeLength, forKey: "countdownTimeLength")
            viewModel.defaults.set(viewModel.countdownStartClassTime, forKey: "countdownStartClassTime")
            print("bebe")

        } else {
            viewModel.countdownStartClassTime = Date(timeIntervalSinceNow: TimeInterval(intervalToNextClass))
            viewModel.defaults.set(viewModel.countdownStartClassTime, forKey: "countdownStartClassTime")
            print(viewModel.countdownStartClassTime)
        }
        print(nextName)
        print(nextTime)
        print(Date() - viewModel.countdownStartTime)
        print(((Date() - viewModel.countdownStartTime)/viewModel.countdownTimeLength))
        timeToNextClass = Double(intervalToNextClass)
        if viewModel.countdownTimeLength != 0 {
            progress += (Date() - viewModel.countdownStartTime) * 0.7/viewModel.countdownTimeLength
        }

    }
    func intervalToString(intervalToNextClass: Double) -> String {
        if intervalToNextClass == 0{
            return "No classes planned"
        } else {
            var roundedInterval = Int(intervalToNextClass)
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
            var minutes = String((roundedInterval - roundedInterval % 60)/60)
            if Int(minutes)! < 10 {
                minutes = "0" + minutes
            }
            var seconds = String(roundedInterval % 60)
            if Int(seconds)! < 10{
                seconds = "0" + seconds
            }
            timeString = "\(days) \(dayString) \(hours):\(minutes):\(seconds)"

            return timeString
        }
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
                    Text(intervalToString(intervalToNextClass: timeToNextClass))
                        .font(.system(size: 24))
                        .bold()
                        .fontDesign(.rounded)
                        .padding(4)

                }

            }
            Button(action: {

                UserDefaults.standard.removeObject(forKey: "Classes")
                viewModel.classes = []
                viewModel.schedule = Schedule(schedule: [1:[],2:[],3:[],4:[],5:[],6:[],7:[]])
                viewModel.countdownStartTime = Date()
                viewModel.countdownStartClassTime = Date()
                viewModel.countdownTimeLength = 0
                UserDefaults.standard.removeObject(forKey: "Schedule")
                UserDefaults.standard.removeObject(forKey: "countdownStartTime")
                UserDefaults.standard.removeObject(forKey: "countdownStartClassTime")
                UserDefaults.standard.removeObject(forKey: "countdownTimeLength")
                UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {requests in

                    print(requests.count)
                })
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            }){
                Text("go")
            }
        }
        .onAppear{
            calculateTimeToNextClass()


        }
        .navigationTitle("Timer")

        .onReceive(timer) { time in
            if progress < 0.85 && timeToNextClass != 0 {
                progress = progress + 0.7/(timeToNextClass)
                timeToNextClass = timeToNextClass - 1
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

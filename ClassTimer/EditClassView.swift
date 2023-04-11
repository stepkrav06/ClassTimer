//
//  EditClassView.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 11.04.2023.
//

import SwiftUI

struct EditClassView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.dismiss) var dismiss
    var classToEdit: Class
    @State var name: String = ""
    @State var daysPicked: [String] = []
    @State var pickedDay: String = ""
    @State var dateTimes: [String:[String]] = [:]
    @State var chosenStartTime: Date = Date()
    @State var chosenEndTime: Date = Date()
    // Alerts
    @State private var emptyFieldsAlert = false
    @State private var incorrectTimesAlert = false
    @State private var createClassAlert = false
    var body: some View {
        VStack{
            Group{
                Text("Name")
                    .fontWeight(.thin)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.top)
                    .padding(.horizontal)
                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .frame(height: 2)
                    .padding(.horizontal)
                TextField("", text: $name)
                    .textFieldStyle(OvalTextFieldStyle())
                    .padding()

                Text("Days")
                    .fontWeight(.thin)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.top)
                    .padding(.horizontal)
                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .frame(height: 2)
                    .padding(.horizontal)
            }
            HStack(spacing:20){
                ForEach(days, id: \.self){ day in
                    ZStack{

                        Circle()
                            .frame(width: 36)
                            .foregroundColor(daysPicked.contains(day) || pickedDay == day ? viewModel.pickedColor.opacity(0.4) :.clear)
                            .overlay{
                                Text(day)
                                    .font(.system(size: 12))
                                    .onTapGesture {
                                        pickedDay = day
                                    }
                            }



                    }

                }
            }
            .frame(maxWidth: .infinity)
            .padding()

            Group{
                Text("Time" + " (\(pickedDay))")
                    .fontWeight(.thin)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.top)
                    .padding(.horizontal)
                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .frame(height: 2)
                    .padding(.horizontal)
            }
            Group{
                if pickedDay != ""{
                    HStack{
                        HStack{

                            DatePicker("", selection: $chosenStartTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)

                            Text("-")
                            DatePicker("", selection: $chosenEndTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.trailing)
                        }

                        Button {
                            guard chosenStartTime != chosenEndTime, chosenEndTime>chosenStartTime else {
                                incorrectTimesAlert.toggle()
                                return
                            }
                            if !daysPicked.contains(pickedDay){
                                daysPicked.append(pickedDay)
                            }
                            let formatter = DateFormatter()
                            formatter.dateFormat = "HH:mm"
                            let startString = formatter.string(from: chosenStartTime)
                            let endString = formatter.string(from: chosenEndTime)
                            let timeStr = startString + " - " + endString
                            var times = dateTimes[pickedDay] ?? []
                            if !times.contains(timeStr){
                                times.append(timeStr)
                            }
                            times = times.sorted(by: {
                                let formatter1 = DateFormatter()
                                formatter1.dateFormat = "HH:mm"
                                return formatter1.date(from: $0.components(separatedBy: " - ")[0])! < formatter1.date(from: $1.components(separatedBy: " - ")[0])!
                            })
                            dateTimes[pickedDay] = times



                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.gray, lineWidth: 1)
                                Text("Add time")
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 18))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                        .padding()
                    }
                }
            }
            Group{
                Text("Times added")
                    .fontWeight(.thin)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.top)
                    .padding(.horizontal)
                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .frame(height: 2)
                    .padding(.horizontal)
            }
            List{
                ForEach(daysPicked, id:\.self){ day in
                    ForEach(dateTimes[day] ?? [], id:\.self){
                        time in
                        HStack{
                            Text(day)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(time)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                let ind = dateTimes[day]!.firstIndex(of: time)!
                                dateTimes[day]!.remove(at: ind)
                                if dateTimes[day] == [] {
                                    dateTimes[day] = nil
                                    let dayInd = daysPicked.firstIndex(of: day)!
                                    daysPicked.remove(at: dayInd)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                    }
                }
            }
            Button {
                guard name != "", dateTimes != [:] else {
                    emptyFieldsAlert.toggle()
                    return
                }
                createClassAlert.toggle()
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.gray, lineWidth: 1)
                    Text("Save class")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 18))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .padding()
        }
        .onAppear{
            name = classToEdit.name
            dateTimes = classToEdit.daysTimes
            daysPicked = Array(classToEdit.daysTimes.keys) as [String]
        }
        .alert("Some fields are empty or no times were added. Cannot proceed.", isPresented: $emptyFieldsAlert) {
                    Button("OK", role: .cancel) { }
                }
        .alert("The chosen times are incorrect. Please choose different times.", isPresented: $incorrectTimesAlert) {
                    Button("OK", role: .cancel) { }
                }
        .alert("Are you sure you want to save this class?", isPresented: $createClassAlert) {
            Button("OK", role: .cancel) {
                viewModel.removeClass(cl: classToEdit)
                var classDescription = ""
                var times: [String] = []
                for arr in dateTimes.values {
                    times.append(contentsOf: arr)
                }
                times = times.unique()
                for time in times {
                    for day in dateTimes.keys {
                        if dateTimes[day]!.contains(time) {
                            classDescription += daysShort[dayToDayNumber[day]!-1]
                        }
                    }
                    classDescription += " " + time
                    classDescription += "\n"

                }
                classDescription.removeLast()


                let class1 = Class(name: name, daysTimes: dateTimes, description: classDescription)
                var classes = viewModel.classes
                classes.append(class1)
                viewModel.classes = classes
                viewModel.encodeClasses(objects: classes)
                for day in dateTimes.keys {
                    let times = dateTimes[day]!
                    var lessonsDay: [Lesson] = []
                    for time in times {
                        let strAr = time.components(separatedBy: " - ")
                        let startTime = strAr[0]
                        let endTime = strAr[1]
                        let lesson = Lesson(name: name, timeStart: startTime, timeEnd: endTime)
                        lessonsDay.append(lesson)
                    }
                    viewModel.schedule.schedule[dayToDayNumber[day]!]!.append(contentsOf: lessonsDay)
                    viewModel.encodeSchedule(object: viewModel.schedule)



                }
                dismiss()
            }
            Button("Cancel") {}
                }

        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct EditClassView_Previews: PreviewProvider {
    static var previews: some View {
        EditClassView(classToEdit: Class(name: "", daysTimes: [:], description: ""))
    }
}
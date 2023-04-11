//
//  ClassAddView.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 10.04.2023.
//

import SwiftUI

struct ClassAddView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State var name: String = ""
    @State var daysPicked: [String] = []
    @State var pickedDay: String = ""
    @State var dateTimes: [String:[String]] = [:]
    @State var chosenStartTime: Date = Date()
    @State var chosenEndTime: Date = Date()
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
                Text("Time")
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
                            Text(pickedDay)
                                .fontWeight(.medium)
                                .italic()
                                .frame(maxWidth: .infinity, alignment: .topLeading)

                                .padding(.leading)
                            DatePicker("", selection: $chosenStartTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("-")
                            DatePicker("", selection: $chosenEndTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.trailing)
                        }

                        Button {

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
                    }
                }
            }
            Button {
                let class1 = Class(name: name, daysTimes: dateTimes, dates: [])
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

                




            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.gray, lineWidth: 1)
                    Text("Create class")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 18))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .padding()
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct ClassAddView_Previews: PreviewProvider {
    static var previews: some View {
        ClassAddView()
    }
}

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            .shadow(color: .gray, radius: 2)
    }
}

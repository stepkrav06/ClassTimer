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
    @State var chosenTime: Date = Date()
    var body: some View {
        VStack{
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

                            DatePicker("", selection: $chosenTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.trailing, 32)
                        }

                        Button {
                            print(chosenTime)
                            if !daysPicked.contains(pickedDay){
                                daysPicked.append(pickedDay)
                            }
                            let formatter = DateFormatter()
                            formatter.dateFormat = "HH:mm"
                            var times = dateTimes[pickedDay] ?? []
                            if !times.contains(formatter.string(from: chosenTime)){
                                times.append(formatter.string(from: chosenTime))
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
            ForEach(daysPicked, id:\.self){ day in
                ForEach(dateTimes[day] ?? [], id:\.self){
                    time in
                    Text(day + ", \(time)")
                }
            }
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

//
//  DayView.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 10.04.2023.
//

import SwiftUI

struct DayView: View {
    var lessons: [Lesson]
    var body: some View {
        VStack(spacing: 5){
            ForEach(lessons) { lesson in
                HStack{
                    Text(lesson.name)
                        .padding(.horizontal)
                    Spacer()
                    Text(lesson.time)
                        .padding(.horizontal)

                }

                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .frame(height: 1)
                    .padding(.vertical, 4)
                    .padding(.horizontal)
            }

            

        }
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(lessons: [Lesson(name: "Math", time: "10:30"),Lesson(name: "Math", time: "10:30"),Lesson(name: "Math", time: "10:30")])
    }
}

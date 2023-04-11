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
            List{
                ForEach(lessons) { lesson in
                    HStack{
                        VStack{
                            Text(lesson.timeStart)
                                .fontWeight(.thin)
                                .font(.system(size: 12))
                                .padding(.leading, 4)

                            Text(lesson.timeEnd)
                                .fontWeight(.thin)
                                .font(.system(size: 12))
                                .padding(.leading, 4)

                        }
                        RoundedRectangle(cornerRadius: 50, style: .continuous)
                            .frame(width: 1)
                            .padding(.trailing)
                        Text(lesson.name)
                            .fontWeight(.thin)
                        Spacer()


                    }
                }


            }



        }
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(lessons: [])
    }
}

//
//  SwiftUIView.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 12.04.2023.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.15, to: 0.85)
                .stroke(
                    Color.c3.opacity(0.5),
                    style: StrokeStyle(
                        lineWidth: 30,
                        lineCap: .round
                    )
                )

                .rotationEffect(.degrees(90))
                .padding(32)
            Circle()
                .trim(from: 0.15, to: 0.6)
                .stroke(
                    Color.c3,
                    // 1
                    style: StrokeStyle(
                        lineWidth: 30,
                        lineCap: .round
                    )
                )
                .shadow(color: Color.c3, radius: 5)
                .shadow(color: Color.c3, radius: 5)

                .rotationEffect(.degrees(90))


                .padding(32)
//            VStack{
//                Text("9:00")
//                    .foregroundColor(.white)
//                    .font(.system(size: 64))
//                    .bold()
//                    .fontDesign(.rounded)
//                    .frame(maxWidth: 150,alignment: .trailing)
//                Text("10:20")
//                    .foregroundColor(.white.opacity(0.6))
//                    .font(.system(size: 44))
//                    .bold()
//                    .fontDesign(.rounded)
//                    .frame(maxWidth: 150,alignment: .trailing)
//                    .offset(x:0,y:-10)
//            }
//            .frame(maxWidth: 150)
//            .offset(x:-10,y:8)
            


        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(.black)
        .ignoresSafeArea()

    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

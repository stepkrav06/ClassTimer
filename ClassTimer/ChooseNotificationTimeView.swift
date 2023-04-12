//
//  ChooseNotificationTimeView.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 12.04.2023.
//

import SwiftUI

struct ChooseNotificationTimeView: View {
    var notificationNumber: Int
    var body: some View {
        VStack(spacing: 5){
            Group{
                Text("Time for")
                    .fontWeight(.thin)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.top)
                    .padding(.horizontal)
                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .frame(height: 2)
                    .padding(.horizontal)
            }
        }
    }
}

struct ChooseNotificationTimeView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseNotificationTimeView(notificationNumber: 0)
    }
}

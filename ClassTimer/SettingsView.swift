//
//  SettingsView.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 10.04.2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
        VStack{

                Text("Theme color")
                    .font(.system(size: 22))
                    .fontDesign(.rounded)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(minWidth: 130)
                    .padding(.horizontal, 20)

                HStack {
                    ForEach(viewModel.colors, id: \.self){ color in
                        ZStack {
                            Circle().fill(color).frame(width: 22).padding(4)
                                .onTapGesture {
                                    viewModel.pickedColor = color
                                }
                            if viewModel.pickedColor == color{
                                Circle()
                                    .stroke(Color.textC1, lineWidth: 2)
                                    .frame(width: 22).padding(4)
                            }
                        }
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            Spacer()




        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static let viewModel = AppViewModel()
    static var previews: some View {
        SettingsView()
            .environmentObject(viewModel)
    }
}

//
//  SettingsView.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 10.04.2023.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject var viewModel: AppViewModel
    @State private var customColor =
    Color(.sRGB, red: 0, green: 0, blue: 0)


    var body: some View {
        VStack(spacing: 5){
            Group{
                Text("Theme color")
                    .fontWeight(.thin)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.top)
                    .padding(.horizontal)
                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .frame(height: 2)
                    .padding(.horizontal)
            }

                HStack {
                    ForEach(viewModel.colors, id: \.self){ color in
                        ZStack {
                            Circle().fill(color).frame(width: 22).padding(4)
                                .onTapGesture {
                                    viewModel.pickedColor = color
                                    viewModel.defaults.setColor(color: UIColor(color), forKey: "AccentColor")
                                }
                            if UIColor(viewModel.pickedColor).cgColor.components == UIColor(color).cgColor.components{
                                Circle().fill(color).frame(width: 28)
                            }
                        }
                    }
                    ColorPicker("", selection: $viewModel.pickedColor)
                        .frame(maxWidth:20)
                        



                }.frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            Group{
                Text("Notifications")
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
                Text("Appearance")
                    .fontWeight(.thin)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.top)
                    .padding(.horizontal)
                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .frame(height: 2)
                    .padding(.horizontal)
                
            }

            Toggle(isOn: $isDarkMode){
                Text("Dark mode")
                    .fontWeight(.medium)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .topLeading)


            }
            .padding(.top)
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

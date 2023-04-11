//
//  SettingsView.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 10.04.2023.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @Environment(\.scenePhase) private var phase
    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject var viewModel: AppViewModel
    @State private var customColor =
    Color(.sRGB, red: 0, green: 0, blue: 0)
    @State var notificationStatus = false
    

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
            HStack{
                Text("Notifications")
                    .fontWeight(.medium)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .topLeading)


                if notificationStatus {
                    Text("Active")
                        .fontWeight(.medium)
                        .italic()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                } else {
                    Text("Not active")
                        .fontWeight(.medium)
                        .italic()
                        .frame(maxWidth: .infinity, alignment: .trailing)

                }

            }
            .padding(.top)
            .padding(.horizontal)
            Button("Request Permission") {
                let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
                if !isRegisteredForRemoteNotifications {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
                }

                Button("Schedule Notification") {
                    let date = Date().addingTimeInterval(30)
                    let content = UNMutableNotificationContent()
                    content.title = "You have a class soon!"
                    content.subtitle = "It looks hungry"
                    content.sound = UNNotificationSound.default

                    // show this notification five seconds from now
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSince(Date()), repeats: false)

                    // choose a random identifier
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                    // add our notification request
                   // UNUserNotificationCenter.current().add(request)
                    UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {requests in
                        var arr: [Bool] = []
                        for oldRequest in requests {
                            print(request.content == oldRequest.content)
                            arr.append(request.content == oldRequest.content)
                        }
                        for index in arr.indices {
                            arr[index] = !arr[index]


                        }

                        if arr.allSatisfy({$0}) {

                            UNUserNotificationCenter.current().add(request)
                        }
                    })
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
        .onAppear(){
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
                if settings.authorizationStatus == .denied {
                    notificationStatus = false
                } else if settings.authorizationStatus == .authorized {
                    notificationStatus = true
                }
            })
        }
        .onChange(of: phase) { newPhase in
                    switch newPhase {
                    case .active :
                        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
                            if settings.authorizationStatus == .denied {
                                notificationStatus = false
                            } else if settings.authorizationStatus == .authorized {
                                notificationStatus = true
                            }
                        })

                    default: break
                    }
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

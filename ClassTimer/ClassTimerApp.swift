//
//  ClassTimerApp.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 10.04.2023.
//

import SwiftUI
import BackgroundTasks
import UserNotifications

@main
struct ClassTimerApp: App {
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("isDarkMode") private var isDarkMode = false
    let viewModel = AppViewModel()
    init(){
        viewModel.pickedColor = viewModel.defaults.colorForKey(key: "AccentColor")

        if let data = UserDefaults.standard.data(forKey: "Classes") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let classes = try decoder.decode([Class].self, from: data)
                viewModel.classes = classes

            } catch {
                print("Unable to Decode classes (\(error))")
            }
        }
        if let data = UserDefaults.standard.data(forKey: "Schedule") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let schedule = try decoder.decode(Schedule.self, from: data)
                viewModel.schedule = schedule
                var lessons: [Lesson] = []
                for day in schedule.schedule.keys {
                    lessons.append(contentsOf: schedule.schedule[day]!)
                }
                viewModel.lessons = lessons

            } catch {
                print("Unable to Decode schedule (\(error))")
            }
        }
    }


    func scheduleNotificationsForWeek() {
        print("scheduling notifications")
        let dateClasses = viewModel.findDatesForWeek()
        let notificationTimes: [TimeInterval] = []
        for time in notificationTimes {
            let time = "15 minutes"
            for dateClass in dateClasses {
                let content = UNMutableNotificationContent()
                content.title = "Class notification"
                content.subtitle = "\(dateClass.name) is in \(time)"
                content.sound = UNNotificationSound.default
                
                // show this notification five seconds from now
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (dateClass.date - 60 * 15).timeIntervalSince(Date()), repeats: false)
                
                // choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                // add our notification request
                // UNUserNotificationCenter.current().add(request)
                UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {requests in
                    var arr: [Bool] = []
                    for oldRequest in requests {
                        print(oldRequest.content)
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
        }
    }
    var body: some Scene {


        WindowGroup {
                TabView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environmentObject(viewModel)
            
        }
        .onChange(of: phase) { newPhase in
                    switch newPhase {
                    case .background: scheduleNotificationsForWeek()
                    default: break
                    }
                }

    }
}
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {


        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNs)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        return true
    }
    

}

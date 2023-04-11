
import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var colors = [Color.c1, Color.c2, Color.c5, Color.c3, Color.c4]
    @Published var pickedColor = Color.c1
    @Published var schedule: Schedule = Schedule(schedule: [1:[],2:[],3:[],4:[],5:[],6:[],7:[]])
    @Published var classes: [Class] = []

    @Published var dayPickedForSchedule: String = "Mon"

    let defaults = UserDefaults.standard

    func encodeClasses(objects: [Class]){
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(objects)
            UserDefaults.standard.set(data, forKey: "Classes")

        } catch {
            print("Unable to Encode Classes (\(error))")
        }
    }
    func encodeSchedule(object: Schedule){
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(object)
            UserDefaults.standard.set(data, forKey: "Schedule")

        } catch {
            print("Unable to Encode Schedule (\(error))")
        }
    }
}

struct TabItem: Identifiable{
    var id = UUID()
    var text: String
    var icon: String
    var tab: Tab

}
var tabItems = [
    TabItem(text: "Timer", icon: "timer", tab: .timer),
    TabItem(text: "Classes", icon: "list.bullet", tab: .classes),
    TabItem(text: "Settings", icon: "gear", tab: .settings),
]
enum Tab: String {
    case timer
    case classes
    case settings
}


extension Color {
    static let c1 = Color("C1")
    static let c2 = Color("C2")
    static let c3 = Color("C3")
    static let c4 = Color("C4")
    static let c5 = Color("C5")
    static let textC1 = Color("TextC")
    static let darkG = Color("darkG")
}
public let dayToDayNumber = ["Mon":1, "Tue":2, "Wed":3, "Thu":4, "Fri":5, "Sat":6, "Sun":7]
public let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

extension UserDefaults {
  func colorForKey(key: String) -> Color {
    var colorReturnded: UIColor?
    if let colorData = data(forKey: key) {
      do {
          if let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
          colorReturnded = color
              
        }
      } catch {
        print("Error UserDefaults")
      }
    }
      return Color(colorReturnded ?? UIColor(Color.c1))
  }

  func setColor(color: UIColor?, forKey key: String) {
    var colorData: NSData?
    if let color = color {
      do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
        colorData = data
      } catch {
        print("Error UserDefaults")
      }
    }
    set(colorData, forKey: key)
  }
}

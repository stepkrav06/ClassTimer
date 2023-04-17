//
//  ScheduleWidgetBundle.swift
//  ScheduleWidget
//
//  Created by Степан Кравцов on 17.04.2023.
//

import WidgetKit
import SwiftUI

@main
struct ScheduleWidgetBundle: WidgetBundle {
    var body: some Widget {
        ScheduleWidget()
        ScheduleWidgetLiveActivity()
    }
}

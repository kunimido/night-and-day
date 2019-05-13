//
//  SunWatcher.swift
//  Night and Day
//
//  Created by Dominique on 12/05/2019.
//  Copyright © 2019 Dominique. All rights reserved.
//

import Foundation

class SkyWatcher {
    func isDark() -> Bool {
        let dayTime = DateInterval(fromHour: 7, toHour: 19)
        return !dayTime.contains(Date())
    }
}

extension DateInterval {
    init(fromHour: Int, toHour: Int) {
        let calendar = Calendar(identifier: Calendar.Identifier.iso8601)
        var components = calendar.dateComponents(in: TimeZone.current, from: Date())
        components.hour = fromHour
        (components.minute, components.second, components.nanosecond) = (0, 0, 0)
        let start = components.date!
        components.hour = toHour
        let end = components.date!
        self.init(start: start, end: end)
    }
}

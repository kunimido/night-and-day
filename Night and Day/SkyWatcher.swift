//
//  SunWatcher.swift
//  Night and Day
//
//  Created by Dominique on 12/05/2019.
//  Copyright © 2019 Dominique. All rights reserved.
//

import Foundation
import CoreLocation

class SkyWatcher: NSObject, CLLocationManagerDelegate {

    var currentLocation: CLLocation?

    func isDark() -> Bool {
        currentLocation = nil
        if CLLocationManager.locationServicesEnabled() {
            let lm = CLLocationManager()
            lm.delegate = self
            lm.requestLocation()
            CFRunLoopRun()
        }
        return !dayInterval().contains(Date())
    }

    private func dayInterval() -> DateInterval {
        let noon = localNoon()
        let halfDay = Int(dayDuration() / 2.0)
        let calendar = Calendar(identifier: .iso8601)
        let sunrise = calendar.date(byAdding: .second, value: -halfDay, to: noon)!
        let sunset = calendar.date(byAdding: .second, value: halfDay, to: noon)!
        return DateInterval(start: sunrise, end: sunset)
    }

    private func localNoon() -> Date {
        let calendar = Calendar(identifier: .iso8601)
        let result : Date
        if currentLocation == nil {
            var noon = calendar.dateComponents(in: .current, from: Date())
            (noon.hour, noon.minute, noon.second, noon.nanosecond) = (12, 0, 0, 0)
            result = noon.date!
        } else {
            var noonUTC = calendar.dateComponents(in: TimeZone(identifier: "UTC")!, from: Date())
            (noonUTC.hour, noonUTC.minute, noonUTC.second, noonUTC.nanosecond) = (12, 0, 0, 0)
            result = calendar.date(byAdding: .second,
                                   value: Int(-currentLocation!.coordinate.longitude * 240.0), to: noonUTC.date!)!
        }
        return result
    }

    private func dayDuration() -> TimeInterval {
        let result: Double
        if currentLocation == nil {
            result = 43200.0
        } else {
            let calendar = Calendar(identifier: .iso8601)
            let day = Double(10 + calendar.ordinality(of: .day, in: .year, for: Date())!) / 365.0
            let declination = (.pi / 180.0 * -23.44) * cos(2.0 * .pi * day)
            let corrections = .pi / 180.0 * (-0.83 - 2.076 * sqrt(currentLocation!.altitude) / 60.0)
            let latitude = .pi / 180.0 * currentLocation!.coordinate.latitude
            let hourAngle = acos((sin(corrections) - sin(latitude) * sin(declination))
                / cos(latitude) * cos(declination))
            result = 86400.0 / .pi * hourAngle
        }
        return result
    }

    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last
        CFRunLoopStop(CFRunLoopGetCurrent())
    }

    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        CFRunLoopStop(CFRunLoopGetCurrent())
    }

}

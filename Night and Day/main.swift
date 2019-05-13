//
//  main.swift
//  Night and Day
//
//  Created by Dominique on 09/05/2019.
//  Copyright © 2019 Dominique. All rights reserved.
//

import Foundation

let dark = SkyWatcher().isDark()
var errors: NSDictionary?
NSAppleScript(source: """
    tell application "System Events"
        if dark mode of appearance preferences is not \(dark) then
            set dark mode of appearance preferences to \(dark)
        end if
    end tell
    """)?.executeAndReturnError(&errors)

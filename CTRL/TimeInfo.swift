//
//  TimeInfo.swift
//  CTRL
//
//  Created by Ali Apple on 21/11/2018.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

import Foundation

class TimeInfo: NSObject {
    
    static let sharedInstance = TimeInfo()
    
    var currentTimeZone = String(TimeZone.current.identifier)
    
    var gameStartTime = 0
    var gameStopTime = 0
    
    var pickUpTime = 0
    var putDownTime = 0
    var currentPickDuration = 0
    var allPickDurations = 0
    var pickUpNumber = 0
    
    var hours:Int = 0
    var minutes:Int = 0
    var seconds:Int = 0
    var timerStarted = false
    var currentHours: Int = 0
    var currentMinutes: Int = 0
    var currentSeconds: Int = 0
    var currentMilliSeconds: Int = 0
    var isTutorialScreenLoadable: Bool = true
    var screenLock = false
    
    var yourName: String = ""
    var gameName: String = ""
    var logs: String = """
                       """
//    var lockscreenCount: Int = 0
//    var foregroundCount: Int = 0
    var state: Int = 0
}

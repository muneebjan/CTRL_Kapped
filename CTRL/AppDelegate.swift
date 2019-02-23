//
//  AppDelegate.swift
//  CTRL
//
//  Created by Ali Apple on 20/11/2018.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var pickUpNumber = UserDefaults.standard.integer(forKey: "pickUpNumber")
    var window: UIWindow?
    var diffHrs = 0
    var diffMins: Int = 0
    var diffSecs = 0
    var bootTime: Int  = 0
    var didTurnOff = false
    var didEnterBackground = false
    let timeInstance = TimeInfo.sharedInstance
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        UserDefaults.standard.set(1, forKey: "state")
//        UserDefaults.standard.synchronize()
        var boottime = timeval()
        var size = MemoryLayout<timeval>.stride
        sysctlbyname("kern.boottime", &boottime, &size, nil, 0)
        print("Boot Time: \(boottime.tv_sec * 1000)")
        bootTime = Int(boottime.tv_sec * 1000)
        UserDefaults.standard.set(bootTime, forKey: "bootTime")
        UserDefaults.standard.set(String(TimeZone.current.identifier),forKey: "timeZone")
        UserDefaults.standard.synchronize()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["timerDone"])
//        timeInstance.currentTimeZone =  String(TimeZone.current.identifier)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: UserDefaults.standard.string(forKey: "timeZone")!)! as TimeZone
        formatter.dateFormat = "hh:mm:ss a"
        self.timeInstance.hours = UserDefaults.standard.integer(forKey: "hours")
        self.timeInstance.minutes = UserDefaults.standard.integer(forKey: "minutes")
        self.timeInstance.seconds = UserDefaults.standard.integer(forKey: "seconds")
        self.timeInstance.logs = UserDefaults.standard.string(forKey: "logs")!
        self.timeInstance.logs += "didFinishLaunchingWithOptions \n\n"
        if UserDefaults.standard.integer(forKey: "state") == 1 || UserDefaults.standard.integer(forKey: "state") == 0{
            AppDelegate.pickUpNumber = 0
            self.timeInstance.logs += "didFinishLaunchingWithOptions state 1\n\n"
            window?.rootViewController = UINavigationController(rootViewController: ViewController())
        }
        
        if UserDefaults.standard.integer(forKey: "state") == 2{
            self.timeInstance.logs += "didFinishLaunchingWithOptions state 2\n"
            let time = Date().millisecondsSince1970
            if bootTime >= UserDefaults.standard.integer(forKey: "putDownTime") {
                self.didTurnOff = true
                self.timeInstance.logs += "didFinishLaunchingWithOptions did booted bootTime \(bootTime) putDownTime \(UserDefaults.standard.integer(forKey: "putDownTime"))\n"
                if time >= UserDefaults.standard.integer(forKey: "timerShouldStopAtMilliSeconds"){
                    self.timeInstance.logs += "didFinishLaunchingWithOptions restarted & time exceeded: current time \(time)\n"
                    if (UserDefaults.standard.integer(forKey: "timerShouldStopAtMilliSeconds") - bootTime) > 30000{
                        timeInstance.currentPickDuration = UserDefaults.standard.integer(forKey: "timerShouldStopAtMilliSeconds") - UserDefaults.standard.integer(forKey: "putDownTime")
                        self.timeInstance.logs += "didFinishLaunchingWithOptions did pickup after 20 sec putdown time \(UserDefaults.standard.integer(forKey: "putDownTime"))\n"
                        timeInstance.pickUpTime = UserDefaults.standard.integer(forKey: "timerShouldStopAtMilliSeconds")
                        print("time exceeded pick count")
                        let date = NSDate(timeIntervalSince1970: Double(self.timeInstance.pickUpTime) / 1000)
                        self.timeInstance.currentSeconds = UserDefaults.standard.integer(forKey: "currentSeconds")
                        self.timeInstance.currentMinutes = UserDefaults.standard.integer(forKey: "currentMinutes")
                        self.timeInstance.currentHours = UserDefaults.standard.integer(forKey: "currentHours")
                        self.msToTime(duration: UserDefaults.standard.integer(forKey: "timerShouldStopAtMilliSeconds"))
                        if UserDefaults.standard.integer(forKey: "putDownTime")  == 0{
                            window?.rootViewController = UINavigationController(rootViewController: PickUpViewController())
                            return true
                        }
                        print(self.timeInstance.pickUpTime - UserDefaults.standard.integer(forKey: "timerStartedTime"))
                        self.timeInstance.allPickDurations = UserDefaults.standard.integer(forKey: "pickDuration")
                        self.timeInstance.allPickDurations += self.timeInstance.currentPickDuration
                        UserDefaults.standard.set(self.timeInstance.allPickDurations, forKey: "pickDuration")
                        let date2 = NSDate(timeIntervalSince1970: Double(UserDefaults.standard.integer(forKey: "putDownTime") + 5000) / 1000)
                        UserDefaults.standard.set(formatter.string(from: date2 as Date), forKey: "putDownTimeDisplay")
                        UserDefaults.standard.synchronize()
                        self.timeInstance.logs += "didFinishLaunchingWithOptions did booted putDownTime \(UserDefaults.standard.integer(forKey: "putDownTimeDisplay"))\n"
                        let myTimings = Timings()
                        AppDelegate.pickUpNumber += 1
                        UserDefaults.standard.set(AppDelegate.pickUpNumber, forKey: "pickUpNumber")
                        UserDefaults.standard.synchronize()
                        myTimings.pickUpNumber = "Pickup \(UserDefaults.standard.integer(forKey: "pickUpNumber"))"
                        myTimings.pickUpTime = "\(formatter.string(from: date as Date))"
                        myTimings.dropDownTime = "\(UserDefaults.standard.string(forKey: "putDownTimeDisplay") ?? "00:00:00 PM")"
                        self.timeInstance.logs += "didFinishLaunchingWithOptions putdownTime in database \(myTimings.dropDownTime)\n"
                        let realm = try! Realm()
                        print("About to write into Realm")
                        try! realm.write {
                            print("writing into Realm: \(myTimings)")
                            realm.add(myTimings)
                        }
                        window?.rootViewController = UINavigationController(rootViewController: PickUpViewController())
                    }
                    else{
                        msToTime(duration: UserDefaults.standard.integer(forKey: "timerShouldStopAtMilliSeconds"))
                        print("time exceded pick not count")
                        window?.rootViewController = UINavigationController(rootViewController: PickUpViewController())
                    }
                }
                else{
                    self.timeInstance.logs += "didFinishLaunchingWithOptions restart not exceed putDownTime \(UserDefaults.standard.integer(forKey: "putDownTime"))\n"
                    if (time - bootTime) > 30000{
                        timeInstance.currentPickDuration = time - UserDefaults.standard.integer(forKey: "putDownTime")
                        self.timeInstance.logs += "didFinishLaunchingWithOptions if time-bootTime>29 sec then current time \(time)\n"
                        self.timeInstance.pickUpTime = time
                        print("time not exceded pick count")
                        let date = NSDate(timeIntervalSince1970: Double(self.timeInstance.pickUpTime) / 1000)
                        self.timeInstance.currentSeconds = UserDefaults.standard.integer(forKey: "currentSeconds")
                        self.timeInstance.currentMinutes = UserDefaults.standard.integer(forKey: "currentMinutes")
                        self.timeInstance.currentHours = UserDefaults.standard.integer(forKey: "currentHours")
                        self.msToTime(duration: (time - UserDefaults.standard.integer(forKey: "timerStartedTime")))
                        if UserDefaults.standard.integer(forKey: "putDownTime")  == 0{
                            window?.rootViewController = UINavigationController(rootViewController: PickUpViewController())
                            return true
                        }
                        print(self.timeInstance.pickUpTime - UserDefaults.standard.integer(forKey: "timerStartedTime"))
                        self.timeInstance.allPickDurations = UserDefaults.standard.integer(forKey: "pickDuration")
                        self.timeInstance.allPickDurations += self.timeInstance.currentPickDuration
                        UserDefaults.standard.set(self.timeInstance.allPickDurations, forKey: "pickDuration")
                        let date2 = NSDate(timeIntervalSince1970: Double(UserDefaults.standard.integer(forKey: "putDownTime") + 5000) / 1000)
                        self.timeInstance.logs += "didFinishLaunchingWithOptions if time-bootTime>5sec then putdown time \(UserDefaults.standard.integer(forKey: "putDownTime"))\n"
                        UserDefaults.standard.set(formatter.string(from: date2 as Date), forKey: "putDownTimeDisplay")
                        AppDelegate.pickUpNumber += 1
                        UserDefaults.standard.set(AppDelegate.pickUpNumber, forKey: "pickUpNumber")
                        UserDefaults.standard.synchronize()
                        let myTimings = Timings()
                        myTimings.pickUpNumber = "Pickup \(UserDefaults.standard.integer(forKey: "pickUpNumber"))"
                        myTimings.pickUpTime = "\(formatter.string(from: date as Date))"
                        myTimings.dropDownTime = "\(UserDefaults.standard.string(forKey: "putDownTimeDisplay") ?? "00:00:00 PM")"
                        self.timeInstance.logs += "didFinishLaunchingWithOptions database putDownTime \(myTimings.dropDownTime)\n"
                        let realm = try! Realm()
                        print("About to write into Realm")
                        try! realm.write {
                            print("writing into Realm: \(myTimings)")
                            realm.add(myTimings)
                        }
                        window?.rootViewController = UINavigationController(rootViewController: PickUpViewController())
                    }
                    else{
                        msToTime(duration: (time - UserDefaults.standard.integer(forKey: "timerStartedTime")))
                        print("time not exceded pick not count")
                        window?.rootViewController = UINavigationController(rootViewController: PickUpViewController())
                    }
                }

            }
            else{
                self.timeInstance.logs += "didFinishLaunchingWithOptions no restart putDownTime \(UserDefaults.standard.integer(forKey: "putDownTime"))\n"
                if time >= UserDefaults.standard.integer(forKey: "timerShouldStopAtMilliSeconds"){
                    self.timeInstance.logs += "didFinishLaunchingWithOptions no restart time exceeded current time \(time)\n"
                    if (UserDefaults.standard.integer(forKey: "timerShouldStopAtMilliSeconds") - UserDefaults.standard.integer(forKey: "putDownTime")) > 1000{
                        self.timeInstance.logs += "didFinishLaunchingWithOptions no restart did pick after 5 sec\n"
                        timeInstance.currentPickDuration = UserDefaults.standard.integer(forKey: "timerShouldStopAtMilliSeconds") - UserDefaults.standard.integer(forKey: "putDownTime")
                        timeInstance.pickUpTime = UserDefaults.standard.integer(forKey: "timerShouldStopAtMilliSeconds")
                        print("time exceded pick count")
                        let date = NSDate(timeIntervalSince1970: Double(self.timeInstance.pickUpTime) / 1000)
                        self.timeInstance.currentSeconds = UserDefaults.standard.integer(forKey: "currentSeconds")
                        self.timeInstance.currentMinutes = UserDefaults.standard.integer(forKey: "currentMinutes")
                        self.timeInstance.currentHours = UserDefaults.standard.integer(forKey: "currentHours")
                        self.msToTime(duration: UserDefaults.standard.integer(forKey: "putDownTime"))
                        if UserDefaults.standard.integer(forKey: "putDownTime")  == 0{
                            window?.rootViewController = UINavigationController(rootViewController: PickUpViewController())
                            return true
                        }
                        print(self.timeInstance.pickUpTime - UserDefaults.standard.integer(forKey: "timerStartedTime"))
                        self.timeInstance.allPickDurations = UserDefaults.standard.integer(forKey: "pickDuration")
                        self.timeInstance.allPickDurations += self.timeInstance.currentPickDuration
                        UserDefaults.standard.set(self.timeInstance.allPickDurations, forKey: "pickDuration")
                        UserDefaults.standard.synchronize()
                        let myTimings = Timings()
                        AppDelegate.pickUpNumber += 1
                        UserDefaults.standard.set(AppDelegate.pickUpNumber, forKey: "pickUpNumber")
                        UserDefaults.standard.synchronize()
                        myTimings.pickUpNumber = "Pickup \(UserDefaults.standard.integer(forKey: "pickUpNumber"))"
                        myTimings.pickUpTime = "\(formatter.string(from: date as Date))"
                        myTimings.dropDownTime = "\(UserDefaults.standard.string(forKey: "putDownTimeDisplay") ?? "00:00:00 PM")"
                        self.timeInstance.logs += "didFinishLaunchingWithOptions no restart database putDownTime \(myTimings.dropDownTime)\n"
                        let realm = try! Realm()
                        print("About to write into Realm")
                        try! realm.write {
                            print("writing into Realm: \(myTimings)")
                            realm.add(myTimings)
                        }
                        window?.rootViewController = UINavigationController(rootViewController: PickUpViewController())
                    }
                    else{
                        msToTime(duration: UserDefaults.standard.integer(forKey: "putDownTime"))
                        print("time exceded pick not count")
                        window?.rootViewController = UINavigationController(rootViewController: PickUpViewController())
                    }
                }
                else{
                    self.timeInstance.logs += "didFinishLaunchingWithOptions no restart not exceed \(UserDefaults.standard.integer(forKey: "putDownTime"))\n"
                    if (time - UserDefaults.standard.integer(forKey: "putDownTime")) > 1000{
                        self.timeInstance.logs += "didFinishLaunchingWithOptions no restart not exceed pick after 5 sec)\n"
                        timeInstance.currentPickDuration = time - UserDefaults.standard.integer(forKey: "putDownTime")
                        self.timeInstance.pickUpTime = time
                        print("time not exceded pick count")
                        let date = NSDate(timeIntervalSince1970: Double(self.timeInstance.pickUpTime) / 1000)
                        self.timeInstance.currentSeconds = UserDefaults.standard.integer(forKey: "currentSeconds")
                        self.timeInstance.currentMinutes = UserDefaults.standard.integer(forKey: "currentMinutes")
                        self.timeInstance.currentHours = UserDefaults.standard.integer(forKey: "currentHours")
                        self.msToTime(duration: self.timeInstance.pickUpTime - UserDefaults.standard.integer(forKey: "timerStartedTime"))
                        if UserDefaults.standard.integer(forKey: "putDownTime")  == 0{
                            window?.rootViewController = UINavigationController(rootViewController: PickUpViewController())
                            return true
                        }
                        print(self.timeInstance.pickUpTime - UserDefaults.standard.integer(forKey: "timerStartedTime"))
                        self.timeInstance.allPickDurations = UserDefaults.standard.integer(forKey: "pickDuration")
                        self.timeInstance.allPickDurations += self.timeInstance.currentPickDuration
                        UserDefaults.standard.set(self.timeInstance.allPickDurations, forKey: "pickDuration")
                        UserDefaults.standard.synchronize()
                        let myTimings = Timings()
                        AppDelegate.pickUpNumber += 1
                        UserDefaults.standard.set(AppDelegate.pickUpNumber, forKey: "pickUpNumber")
                        UserDefaults.standard.synchronize()
                        myTimings.pickUpNumber = "Pickup \(UserDefaults.standard.integer(forKey: "pickUpNumber"))"
                        myTimings.pickUpTime = "\(formatter.string(from: date as Date))"
                        myTimings.dropDownTime = "\(UserDefaults.standard.string(forKey: "putDownTimeDisplay") ?? "00:00:00 PM")"
                        self.timeInstance.logs += "didFinishLaunchingWithOptions no restart putDownTime \(myTimings.dropDownTime)\n"
                        let realm = try! Realm()
                        print("About to write into Realm")
                        try! realm.write {
                            print("writing into Realm: \(myTimings)")
                            realm.add(myTimings)
                        }
                        window?.rootViewController = UINavigationController(rootViewController: PickUpViewController())
                    }
                    else{
                        self.timeInstance.pickUpTime = time
                        msToTime(duration: self.timeInstance.pickUpTime - UserDefaults.standard.integer(forKey: "timerStartedTime"))
                        print("time not exceded pick not count")
                        window?.rootViewController = UINavigationController(rootViewController: PickUpViewController())
                    }
                }

            }
        }
        if UserDefaults.standard.integer(forKey: "state") == 3{
            self.timeInstance.logs += "didFinishLaunchingWithOptions state 3\n"
            AppDelegate.pickUpNumber = 0
            timeInstance.hours = UserDefaults.standard.integer(forKey: "hours")
            timeInstance.minutes = UserDefaults.standard.integer(forKey: "minutes")
            timeInstance.seconds = UserDefaults.standard.integer(forKey: "seconds")
            window?.rootViewController = UINavigationController(rootViewController: EndViewController())
        }
        if UserDefaults.standard.integer(forKey: "state") == 4{
            AppDelegate.pickUpNumber = 0
            self.timeInstance.logs += "didFinishLaunchingWithOptions state 4\n"
            timeInstance.hours = UserDefaults.standard.integer(forKey: "hours")
            timeInstance.minutes = UserDefaults.standard.integer(forKey: "minutes")
            timeInstance.seconds = UserDefaults.standard.integer(forKey: "seconds")
            window?.rootViewController = UINavigationController(rootViewController: ReceiptViewController())
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("Will Resign Active is Called")
        self.timeInstance.logs += "applicationWillResignActive\n"
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        self.timeInstance.logs += "applicationDidEnterBackground\n\n"
        let time = Date().millisecondsSince1970 + 5000
        let date = NSDate(timeIntervalSince1970: Double(time) / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: UserDefaults.standard.string(forKey: "timeZone")!)! as TimeZone
        formatter.dateFormat = "hh:mm:ss a"
        print("Current Time: \(formatter.string(from: date as Date))")
        if UserDefaults.standard.bool(forKey: "timerStarted") == true {
            self.timeInstance.logs += "applicationDidEnterBackground timer was started\n"
            if(UIScreen.main.brightness > 0){
//                print("true >> \(DidUserPressLockButton())")
                timeInstance.screenLock = false
                UserDefaults.standard.set(time, forKey: "putDownTime")
                UserDefaults.standard.set("\(formatter.string(from: date as Date))", forKey: "putDownTimeDisplay")
                UserDefaults.standard.synchronize()
                self.timeInstance.logs += "applicationDidEnterBackground with screen NOT lock \n"
                self.timeInstance.logs += "applicationDidEnterBackground time \(time)\n"
                self.timeInstance.logs += "applicationDidEnterBackground userdefaults \(UserDefaults.standard.integer(forKey: "putDownTime"))\n"
                self.timeInstance.logs += "applicationDidEnterBackground display time \(String(describing: UserDefaults.standard.string(forKey: "putDownTimeDisplay")))\n"
                let content = UNMutableNotificationContent()
                content.title = "YOU'VE LEFT KAPPER!"
                content.body = "Follow this notification back inside app before your activity-clock starts counting!"
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
                let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                print("\(timeInstance.screenLock) times screen was background")
            }
            else{
//                print("false >> \(DidUserPressLockButton())")
                UserDefaults.standard.set(0, forKey: "putDownTime")
                UserDefaults.standard.synchronize()
                self.timeInstance.logs += "applicationDidEnterBackground with screen lock \n"
                timeInstance.screenLock = true
                print("\(timeInstance.screenLock) times screen was lock screen")
            }
            print("brightness value: \(UIScreen.main.brightness)")
        }
        else {
            self.timeInstance.logs += "applicationDidEnterBackground but timer not started \n"
            timeInstance.putDownTime = 0
            UserDefaults.standard.set(0, forKey: "putDownTime")
            UserDefaults.standard.set(0, forKey: "putDownTimeDisplay")
            UserDefaults.standard.synchronize()
        }
        self.timeInstance.logs += "application exiting Background \n"
        UserDefaults.standard.set(self.timeInstance.logs, forKey: "logs")
        UserDefaults.standard.synchronize()
    }
    
//    func DidUserPressLockButton() -> Bool {
//        let oldBrightness = UIScreen.main.brightness
//        UIScreen.main.brightness = oldBrightness + (oldBrightness <= 0.01 ? (0.01) : (-0.01))
//        print("old brightness \(oldBrightness)")
//        print("UIScreen brightness \(UIScreen.main.brightness)")
//        return oldBrightness != UIScreen.main.brightness
//    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Will Enter Foreground")
        self.timeInstance.logs = UserDefaults.standard.string(forKey: "logs")!
        self.timeInstance.logs += "applicationWillEnterForeground entering\n\n"
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["timerDone"])
        self.timeInstance.hours = UserDefaults.standard.integer(forKey: "hours")
        self.timeInstance.minutes = UserDefaults.standard.integer(forKey: "minutes")
        self.timeInstance.seconds = UserDefaults.standard.integer(forKey: "seconds")
        timeInstance.pickUpTime = Date().millisecondsSince1970
        self.timeInstance.logs += "applicationWillEnterForeground pickup time \(timeInstance.pickUpTime)\n"
        self.timeInstance.logs += "applicationWillEnterForeground dropDownTime userdefaults \(UserDefaults.standard.integer(forKey: "putDownTime"))\n"
        if UserDefaults.standard.bool(forKey: "timerStarted") == false{
            AppDelegate.pickUpNumber = 0
            self.timeInstance.logs += "applicationWillEnterForeground but timer not started\n"
            return
        }
        
        if timeInstance.screenLock == false{
            self.timeInstance.logs += "applicationWillEnterForeground screen NOT locked\n"
            if timeInstance.pickUpTime >= UserDefaults.standard.integer(forKey: "timerShouldStopAtMilliSeconds"){
                self.timeInstance.logs += "applicationWillEnterForeground NOT locked, time exceeded\n"
                if (UserDefaults.standard.integer(forKey: "timerShouldStopAtMilliSeconds") - UserDefaults.standard.integer(forKey: "putDownTime")) > 1000{
                    self.timeInstance.logs += "applicationWillEnterForeground NOT locked, time exceeded, picked after 5 sec\n"
                    timeInstance.currentPickDuration = UserDefaults.standard.integer(forKey: "timerShouldStopAtMilliSeconds") - UserDefaults.standard.integer(forKey: "putDownTime")
                    timeInstance.pickUpTime = UserDefaults.standard.integer(forKey: "timerShouldStopAtMilliSeconds")
                    print("time exceded pick count")
                }
                else{
                    self.timeInstance.logs += "applicationWillEnterForeground NOT locked, picked before 5 sec not counting pickup\n"
                    msToTime(duration: UserDefaults.standard.integer(forKey: "putDownTime"))
                    print("time exceded pick not count")
                    return
                }
            }
            else{
                self.timeInstance.logs += "applicationWillEnterForeground NOT locked, time NOT exceeded\n\n"
                if (timeInstance.pickUpTime - UserDefaults.standard.integer(forKey: "putDownTime")) > 1000{
                    self.timeInstance.logs += "applicationWillEnterForeground NOT locked, time exceeded, picked after 5 sec\n"
                    timeInstance.currentPickDuration = timeInstance.pickUpTime - UserDefaults.standard.integer(forKey: "putDownTime")
                    print("time not exceded pick count")
                }
                else{
                    self.timeInstance.logs += "applicationWillEnterForeground NOT locked, time NOT exceeded, picked less than 5\n"
                    msToTime(duration: timeInstance.pickUpTime - UserDefaults.standard.integer(forKey: "timerStartedTime"))
                    print("time not exceded pick not count")
                    return
                }
            }
            timeInstance.allPickDurations = UserDefaults.standard.integer(forKey: "pickDuration")
            timeInstance.allPickDurations += timeInstance.currentPickDuration
            UserDefaults.standard.set(timeInstance.allPickDurations, forKey: "pickDuration")
            let time = timeInstance.pickUpTime
            let date = NSDate(timeIntervalSince1970: Double(time) / 1000)
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone(name: UserDefaults.standard.string(forKey: "timeZone")!)! as TimeZone
            formatter.dateFormat = "hh:mm:ss a"
            let myTimings = Timings()
            AppDelegate.pickUpNumber += 1
            UserDefaults.standard.set(AppDelegate.pickUpNumber, forKey: "pickUpNumber")
            UserDefaults.standard.synchronize()
            myTimings.pickUpNumber = "Pickup \(UserDefaults.standard.integer(forKey: "pickUpNumber"))"
            myTimings.pickUpTime = "\(formatter.string(from: date as Date))"
            myTimings.dropDownTime = "\(UserDefaults.standard.string(forKey: "putDownTimeDisplay")!)"
            self.timeInstance.logs += "applicationWillEnterForeground database pickup count \(myTimings.pickUpNumber) \n"
            self.timeInstance.logs += "applicationWillEnterForeground database dropDownTime \(myTimings.dropDownTime) \n\n"
            print("About to write into Realm")
            let realm = try! Realm()
            try! realm.write {
                print("writing into Realm: \(myTimings)")
                realm.add(myTimings)
            }
            msToTime(duration: timeInstance.pickUpTime - UserDefaults.standard.integer(forKey: "timerStartedTime"))
            print(self.timeInstance.pickUpTime - UserDefaults.standard.integer(forKey: "timerStartedTime"))
        }
        else{
            self.timeInstance.logs += "applicationWillEnterForeground but screen was lock\n"
            msToTime(duration: timeInstance.pickUpTime - UserDefaults.standard.integer(forKey: "timerStartedTime"))
            print(self.timeInstance.pickUpTime - UserDefaults.standard.integer(forKey: "timerStartedTime"))
        }
        timeInstance.screenLock = false

        if UserDefaults.standard.bool(forKey: "timerStarted") == false {
            self.timeInstance.logs += "applicationWillEnterForeground but timer not started\n"
            timeInstance.pickUpTime = 0
            timeInstance.currentPickDuration = 0
            UserDefaults.standard.set(nil, forKey: "pickDuration")
            UserDefaults.standard.set(nil, forKey: "putDownTime")
            UserDefaults.standard.set(nil, forKey: "putDownTimeDisplay")
            UserDefaults.standard.synchronize()
        }
        self.timeInstance.logs += "application exiting Foreground\n"

    }
    
    func msToTime(duration: Int){
        timeInstance.currentSeconds = (duration/1000)%60
        timeInstance.currentMinutes = (duration/(1000*60))%60
        timeInstance.currentHours = (duration/(1000*60*60))%24
        print(self.timeInstance.currentHours, self.timeInstance.currentMinutes, self.timeInstance.currentSeconds)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Become Active is Called")
        self.timeInstance.logs += "applicationDidBecomeActive\n"
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("Will Terminate is Called")
        self.timeInstance.logs += "applicationWillTerminate\n\n"
        print(UserDefaults.standard.integer(forKey: "pickDuration"))
        let time = Date().millisecondsSince1970 + 5000
        if UserDefaults.standard.bool(forKey: "timerStarted") == true {
            if timeInstance.screenLock == true{
                UserDefaults.standard.set(0, forKey: "putDownTime")
                UserDefaults.standard.synchronize()
                return
            }
            self.timeInstance.logs += "applicationWillTerminate timer started\n"
            let content = UNMutableNotificationContent()
            content.title = "YOU'VE LEFT KAPPER!"
            content.body = "Follow this notification back inside app before your activity-clock starts counting!"
            //        content.body = "Do you really know?"
            //        content.badge = 1
            let date = NSDate(timeIntervalSince1970: Double(time) / 1000)
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone(name: UserDefaults.standard.string(forKey: "timeZone")!)! as TimeZone
            formatter.dateFormat = "hh:mm:ss a"
            UserDefaults.standard.set(formatter.string(from: date as Date), forKey: "putDownTimeDisplay")
            UserDefaults.standard.set(time, forKey: "putDownTime")
            UserDefaults.standard.set(self.timeInstance.logs, forKey: "logs")
            UserDefaults.standard.synchronize()
            self.timeInstance.logs += "applicationWillTerminate putDownTime \(UserDefaults.standard.integer(forKey: "putDownTime"))\n"
            self.timeInstance.logs += "applicationWillTerminate putDownTime \(String(describing: UserDefaults.standard.string(forKey: "putDownTimeDisplay")))\n"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
            let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        self.timeInstance.logs += "application exiting Termination \n"
    }
    
}

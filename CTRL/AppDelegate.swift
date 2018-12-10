//
//  AppDelegate.swift
//  CTRL
//
//  Created by Ali Apple on 20/11/2018.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var pickUpNumber = UserDefaults.standard.integer(forKey: "pickUpNumber")
    var window: UIWindow?
    let timeInstance = TimeInfo.sharedInstance
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        UserDefaults.standard.set(1, forKey: "state")
//        UserDefaults.standard.synchronize()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if UserDefaults.standard.integer(forKey: "state") == 1 || UserDefaults.standard.integer(forKey: "state") == 0{
            AppDelegate.pickUpNumber = 0
            window?.rootViewController = UINavigationController(rootViewController: ViewController())
        }
        if UserDefaults.standard.integer(forKey: "state") == 2{
            if UserDefaults.standard.bool(forKey: "timerStarted") == false{
                AppDelegate.pickUpNumber = 0
                window?.rootViewController = UINavigationController(rootViewController: ViewController())
            }
            DispatchQueue.main.async {
                let time = Date().millisecondsSince1970
                let date = NSDate(timeIntervalSince1970: Double(time) / 1000)
                let formatter = DateFormatter()
                formatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                formatter.dateFormat = "hh:mm:ss a"
                //            print("Current Time: \(formatter.string(from: date as Date))")
                self.timeInstance.currentSeconds = UserDefaults.standard.integer(forKey: "currentSeconds")
                self.timeInstance.currentMinutes = UserDefaults.standard.integer(forKey: "currentMinutes")
                self.timeInstance.currentHours = UserDefaults.standard.integer(forKey: "currentHours")
                self.timeInstance.hours = UserDefaults.standard.integer(forKey: "hours")
                self.timeInstance.minutes = UserDefaults.standard.integer(forKey: "minutes")
                self.timeInstance.seconds = UserDefaults.standard.integer(forKey: "seconds")
                //            print("Current Seconds Stored: \(self.timeInstance.currentSeconds)")
                self.timeInstance.pickUpTime = Date().millisecondsSince1970
                self.timeInstance.currentPickDuration = self.timeInstance.pickUpTime - UserDefaults.standard.integer(forKey: "putDownTime")
                self.msToTime(duration: self.timeInstance.currentPickDuration)
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
                let realm = try! Realm()
                try! realm.write {
                    realm.add(myTimings)
                }
            }
            window?.rootViewController = UINavigationController(rootViewController: PickUpViewController())
        }
        if UserDefaults.standard.integer(forKey: "state") == 3{
            AppDelegate.pickUpNumber = 0
            timeInstance.hours = UserDefaults.standard.integer(forKey: "hours")
            timeInstance.minutes = UserDefaults.standard.integer(forKey: "minutes")
            timeInstance.seconds = UserDefaults.standard.integer(forKey: "seconds")
            window?.rootViewController = UINavigationController(rootViewController: EndViewController())
        }
        if UserDefaults.standard.integer(forKey: "state") == 4{
            AppDelegate.pickUpNumber = 0
            timeInstance.hours = UserDefaults.standard.integer(forKey: "hours")
            timeInstance.minutes = UserDefaults.standard.integer(forKey: "minutes")
            timeInstance.seconds = UserDefaults.standard.integer(forKey: "seconds")
            window?.rootViewController = UINavigationController(rootViewController: ReceiptViewController())
        }
        
        //        UINavigationBar.appearance().barTintColor = UIColor(white: 1, alpha: 0.0)
        //        UINavigationBar.appearance().tintColor = UIColor(white: 1, alpha: 0.0)
        let lagFreeField: UITextField = UITextField()
        window?.addSubview(lagFreeField)
        lagFreeField.becomeFirstResponder()
        lagFreeField.resignFirstResponder()
        lagFreeField.removeFromSuperview()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        //        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        let currentBrightness = UIScreen.main.brightness
        let time = Date().millisecondsSince1970
        let date = NSDate(timeIntervalSince1970: Double(time) / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        formatter.dateFormat = "hh:mm:ss a"
        print("Current Time: \(formatter.string(from: date as Date))")
        print("brightness value: \(currentBrightness)")
//        if timeInstance.timerStarted == true && timeInstance.lockscreenCount == 0{
//            timeInstance.lockscreenCount  += 1
//            return
//        }
        
        if(currentBrightness <= 0){
//            timeInstance.lockscreenCount += 1
            UserDefaults.standard.set(Date().millisecondsSince1970, forKey: "putDownTime")
            UserDefaults.standard.set("\(formatter.string(from: date as Date))", forKey: "putDownTimeDisplay")
            UserDefaults.standard.synchronize()
//            print("\(timeInstance.lockscreenCount) times screen was lock screen")
        }
        else{
//            timeInstance.lockscreenCount += 1
            UserDefaults.standard.set(Date().millisecondsSince1970, forKey: "putDownTime")
            UserDefaults.standard.set("\(formatter.string(from: date as Date))", forKey: "putDownTimeDisplay")
            UserDefaults.standard.synchronize()
//            print("\(timeInstance.lockscreenCount) times screen was lock screen")
        }
        
        if UserDefaults.standard.bool(forKey: "timerStarted") == false {
//            timeInstance.lockscreenCount = 0
            timeInstance.putDownTime = 0
            UserDefaults.standard.set(nil, forKey: "pickDuration")
            UserDefaults.standard.set(nil, forKey: "putDownTime")
            UserDefaults.standard.set(nil, forKey: "putDownTimeDisplay")
            UserDefaults.standard.synchronize()
        }

    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("App Launched in Foreground")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        if timeInstance.timerStarted == true && timeInstance.foregroundCount == 0{
//            timeInstance.foregroundCount  += 1
//            return
//        }
        if UserDefaults.standard.bool(forKey: "timerStarted") == false{
            AppDelegate.pickUpNumber = 0
            return
        }
        timeInstance.pickUpTime = Date().millisecondsSince1970
        timeInstance.currentPickDuration = timeInstance.pickUpTime - UserDefaults.standard.integer(forKey: "putDownTime")
//        timeInstance.foregroundCount  += 1
        print("Pick Duration: \(timeInstance.currentPickDuration)")
//        print("\(timeInstance.foregroundCount) times app came in foreground")
        timeInstance.allPickDurations = UserDefaults.standard.integer(forKey: "pickDuration")
        timeInstance.allPickDurations += timeInstance.currentPickDuration
        print("All Pick Durations: \(timeInstance.allPickDurations)")
        UserDefaults.standard.set(timeInstance.allPickDurations, forKey: "pickDuration")
        UserDefaults.standard.synchronize()
        let time = Date().millisecondsSince1970
        let date = NSDate(timeIntervalSince1970: Double(time) / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        formatter.dateFormat = "hh:mm:ss a"
        print("Current Time: \(formatter.string(from: date as Date))")
        let myTimings = Timings()
        AppDelegate.pickUpNumber += 1
        UserDefaults.standard.set(AppDelegate.pickUpNumber, forKey: "pickUpNumber")
        UserDefaults.standard.synchronize()
        myTimings.pickUpNumber = "Pickup \(UserDefaults.standard.integer(forKey: "pickUpNumber"))"
        myTimings.pickUpTime = "\(formatter.string(from: date as Date))"
        myTimings.dropDownTime = "\(UserDefaults.standard.string(forKey: "putDownTimeDisplay")!)"
        let realm = try! Realm()
        try! realm.write {
            realm.add(myTimings)
        }
        msToTime(duration: timeInstance.currentPickDuration)
//        print("Current Pick Duration: \(msToTime(duration: timeInstance.allPickDurations))")
        if UserDefaults.standard.bool(forKey: "timerStarted") == false {
//            timeInstance.foregroundCount = 0
            timeInstance.pickUpTime = 0
            timeInstance.currentPickDuration = 0
            UserDefaults.standard.set(nil, forKey: "pickDuration")
            UserDefaults.standard.set(nil, forKey: "putDownTime")
            UserDefaults.standard.set(nil, forKey: "putDownTimeDisplay")
            UserDefaults.standard.synchronize()
        }
    }
    
    func msToTime(duration: Int){
        if timeInstance.currentSeconds + (duration/1000)%60 < 60{
            timeInstance.currentSeconds += (duration/1000)%60
        }
        else {
            timeInstance.currentSeconds += (duration/1000)%60 - 60
            timeInstance.currentMinutes += 1
        }
        
        if timeInstance.currentMinutes + (duration/(1000*60))%60 < 60{
            timeInstance.currentMinutes += (duration/(1000*60))%60
        }
        else {
            timeInstance.currentMinutes += (duration/(1000*60))%60 - 60
            timeInstance.currentHours += 1
        }
        if timeInstance.currentHours + (duration/(1000*60*60))%24 < 24{
            timeInstance.currentHours += (duration/(1000*60*60))%24
        }
        else{
            timeInstance.currentSeconds = 24
            timeInstance.currentMinutes = 60
            timeInstance.currentHours = 60
        }
//        return "\(hour):\(minute):\(second)"
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let time = Date().millisecondsSince1970
        let date = NSDate(timeIntervalSince1970: Double(time) / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        formatter.dateFormat = "hh:mm:ss a"
        print("Current Time: \(formatter.string(from: date as Date))")
        UserDefaults.standard.set(formatter.string(from: date as Date), forKey: "putDownTimeDisplay")
        UserDefaults.standard.set(Date().millisecondsSince1970, forKey: "putDownTime")
        UserDefaults.standard.synchronize()
    }
    
}


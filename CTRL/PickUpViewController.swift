//
//  PickUpViewController.swift
//  CTRL
//
//  Created by Ali Apple on 21/11/2018.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

import UIKit

class PickUpViewController: UIViewController {
    
    let timeInstance = TimeInfo.sharedInstance
    var format : DateFormatter!
    
    let mainContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let timeContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor(r: 142, g: 142, b: 142).cgColor
        return view
    }()
    
    lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: String(format: "%02d : %02d : %02d", timeInstance.currentHours, timeInstance.currentMinutes, timeInstance.currentSeconds),
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(r: 50,g: 97,b: 152)
//        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
//
    let hoursLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "Hours",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(r: 50,g: 97,b: 152)
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let minutesLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "Minutes",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(r: 50,g: 97,b: 152)
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let secondsLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "Seconds",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(r: 50,g: 97,b: 152)
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var yourNameLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: UserDefaults.standard.string(forKey: "yourName")!,
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 3
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    lazy var institutionNameLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: UserDefaults.standard.string(forKey: "gameName")!,
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 3
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    let logoImageView: UIImageView = {
        var bi = UIImageView()
        let screenSize: CGRect = UIScreen.main.bounds
        bi.translatesAutoresizingMaskIntoConstraints = false
        //        bi.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        bi.image = UIImage(named: "kapped.png")
        //        bi.contentMode = .scaleAspectFit
        return bi
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(2, forKey: "state")
        var timerShouldStopAt = UserDefaults.standard.integer(forKey: "timerStartedTime")
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        formatter.dateFormat = "hh:mm:ss a"
        print("Timer Should Stop At: \(timerShouldStopAt)")
        timerShouldStopAt += (UserDefaults.standard.integer(forKey: "hours") * 3600000 )+(UserDefaults.standard.integer(forKey: "minutes") * 60000)+(UserDefaults.standard.integer(forKey: "seconds") * 1000)
        print(timerShouldStopAt)
        let date2 = NSDate(timeIntervalSince1970: Double(timerShouldStopAt) / 1000)
        UserDefaults.standard.set(formatter.string(from: date2 as Date), forKey: "timerShouldStopAt")
        UserDefaults.standard.synchronize()
        print(UserDefaults.standard.string(forKey: "timerShouldStopAt")!)
        startTimer()
        view.backgroundColor = .white
//        let backBarButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(handleBackButton))
//        backBarButton.tintColor = .gray
//        self.navigationItem.leftBarButtonItem = backBarButton
        setupViews()
    }
    
    var timerTest : Timer?
    
    func startTimer() {
        if timerTest == nil {
            timerTest =  Timer.scheduledTimer(
                timeInterval: TimeInterval(1),
                target      : self,
                selector    : #selector(updateClock),
                userInfo    : nil,
                repeats     : true)
        }
    }

    @objc func updateClock(){

        if timeInstance.currentHours >= timeInstance.hours  && timeInstance.currentMinutes >= timeInstance.minutes && timeInstance.currentSeconds >= timeInstance.seconds-1 {
            startTimeLabel.text = String(format: "%02d : %02d : %02d", timeInstance.hours, timeInstance.minutes, timeInstance.seconds)
            stopTimerTest()
            let time = Date().millisecondsSince1970
            let date = NSDate(timeIntervalSince1970: Double(time) / 1000)
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
            formatter.dateFormat = "hh:mm:ss a"
            print("Current Time: \(formatter.string(from: date as Date))")
//            UserDefaults.standard.set(3, forKey: "state")
            UserDefaults.standard.set(formatter.string(from: date as Date), forKey: "timerStoppedOn")
            UserDefaults.standard.set(3, forKey: "state")
            UserDefaults.standard.set(false, forKey: "timerStarted")
            UserDefaults.standard.synchronize()
            let endViewController = EndViewController()
            let aObjNavi = UINavigationController(rootViewController: endViewController)
            let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
            appDelegate.window?.rootViewController = aObjNavi
        }
            
        else{
            if timeInstance.currentSeconds != 59{
                timeInstance.currentSeconds += 1
                startTimeLabel.text = String(format: "%02d : %02d : %02d", timeInstance.currentHours, timeInstance.currentMinutes, timeInstance.currentSeconds)
                startTimeLabel.textAlignment = .center
            }
            else{
                timeInstance.currentSeconds = 0
                timeInstance.currentMinutes += 1
                startTimeLabel.text = String(format: "%02d : %02d : %02d", timeInstance.currentHours, timeInstance.currentMinutes, timeInstance.currentSeconds)
                startTimeLabel.textAlignment = .center
            }
            
            if timeInstance.currentMinutes == 60{
                timeInstance.currentMinutes = 0
                timeInstance.currentHours += 1
                startTimeLabel.text = String(format: "%02d : %02d : %02d", timeInstance.currentHours, timeInstance.currentMinutes, timeInstance.currentSeconds)
                startTimeLabel.textAlignment = .center
            }
            
            if timeInstance.currentHours == 24{
                timeInstance.currentHours = 0
                timeInstance.currentMinutes = 0
                timeInstance.currentSeconds = 0
                startTimeLabel.text = String(format: "%02d : %02d : %02d", timeInstance.currentHours, timeInstance.currentMinutes, timeInstance.currentSeconds)
                startTimeLabel.textAlignment = .center
            }
            print(startTimeLabel.text!)
            UserDefaults.standard.set(startTimeLabel.text!, forKey: "currentTimer")
            UserDefaults.standard.set(timeInstance.currentHours, forKey: "currentHours")
            UserDefaults.standard.set(timeInstance.currentMinutes, forKey: "currentMinutes")
            UserDefaults.standard.set(timeInstance.currentSeconds, forKey: "currentSeconds")
            print(UserDefaults.standard.integer(forKey: "currentSeconds"))
//            print(UserDefaults.standard.integer(forKey: "seconds"))
            UserDefaults.standard.synchronize()
        }
    }
    
    func stopTimerTest() {
        if timerTest != nil {
            timerTest!.invalidate()
            timerTest = nil
        }
    }
    
//    @objc func handleBackButton(){
//        stopTimerTest()
//        let viewController = ViewController()
//        let aObjNavi = UINavigationController(rootViewController: viewController)
//        let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
//        appDelegate.window?.rootViewController = aObjNavi
//    }
    
    func setupViews(){
        
        view.addSubview(mainContainerView)
        mainContainerView.heightAnchor.constraint(equalToConstant: 667.0).isActive = true
        mainContainerView.widthAnchor.constraint(equalToConstant: 375.0).isActive = true
        mainContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        mainContainerView.addSubview(timeContainerView)
        timeContainerView.topAnchor.constraint(equalTo: mainContainerView.topAnchor, constant: 100).isActive = true
        timeContainerView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor).isActive = true
        timeContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        timeContainerView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        
        timeContainerView.addSubview(startTimeLabel)
        startTimeLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
        startTimeLabel.centerXAnchor.constraint(equalTo: timeContainerView.centerXAnchor).isActive = true
        //        startTimeLabel.backgroundColor = .orange
        startTimeLabel.centerYAnchor.constraint(equalTo: timeContainerView.centerYAnchor, constant: -11).isActive = true
        startTimeLabel.widthAnchor.constraint(equalToConstant: 240).isActive = true
        
        timeContainerView.addSubview(hoursLabel)
        hoursLabel.leadingAnchor.constraint(equalTo: startTimeLabel.leadingAnchor, constant: 20).isActive = true
        hoursLabel.topAnchor.constraint(equalTo: startTimeLabel.bottomAnchor, constant: 5).isActive = true
        
        timeContainerView.addSubview(minutesLabel)
        minutesLabel.centerXAnchor.constraint(equalTo: timeContainerView.centerXAnchor).isActive = true
        minutesLabel.topAnchor.constraint(equalTo: startTimeLabel.bottomAnchor, constant: 5).isActive = true
        
        timeContainerView.addSubview(secondsLabel)
        secondsLabel.trailingAnchor.constraint(equalTo: startTimeLabel.trailingAnchor, constant: -10).isActive = true
        secondsLabel.topAnchor.constraint(equalTo: startTimeLabel.bottomAnchor, constant: 5).isActive = true
        
        mainContainerView.addSubview(yourNameLabel)
        yourNameLabel.topAnchor.constraint(equalTo: timeContainerView.bottomAnchor, constant: 50).isActive = true
        yourNameLabel.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        yourNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        yourNameLabel.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -100).isActive = true
        
        mainContainerView.addSubview(institutionNameLabel)
        institutionNameLabel.topAnchor.constraint(equalTo: yourNameLabel.bottomAnchor, constant: 25).isActive = true
        institutionNameLabel.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        institutionNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        institutionNameLabel.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -100).isActive = true
        
        mainContainerView.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -80).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -20).isActive = true
        
    }
    
}

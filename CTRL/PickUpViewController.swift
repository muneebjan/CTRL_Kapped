//
//  PickUpViewController.swift
//  CTRL
//
//  Created by Ali Apple on 21/11/2018.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

import UIKit
import RealmSwift

class PickUpViewController: UIViewController {
    
    let timeInstance = TimeInfo.sharedInstance
    var format : DateFormatter!
    var hours = 0
    var minutes = 0
    var seconds = 0
    
    let mainContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    lazy var sessionTimeLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: String(format: "%02d : %02d : %02d", timeInstance.hours, timeInstance.minutes, timeInstance.seconds),
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(r: 38,g: 126,b: 193), NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    let timeImageView: UIImageView = {
        var bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.layer.masksToBounds = false
        bi.backgroundColor = .orange
        bi.image = UIImage(named: "timer.png")
        bi.layer.cornerRadius = 60/2
        bi.layer.borderWidth = 1
        bi.layer.borderColor = UIColor(r: 142, g: 142, b: 142).cgColor
        return bi
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 170, g:196, b:237)
        button.setTitle("EDIT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(r: 142, g: 142, b: 142).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        button.addTarget(self, action: #selector(handleEditButton), for:.touchUpInside)
        return button
    }()
    
    @objc func handleEditButton(){
        self.timePicker.selectRow(UserDefaults.standard.integer(forKey: "hours"), inComponent: 0, animated: true)
        self.timePicker.selectRow(UserDefaults.standard.integer(forKey: "minutes"), inComponent: 1, animated: true)
        self.timePicker.selectRow(UserDefaults.standard.integer(forKey: "seconds"), inComponent: 2, animated: true)
        mainContainerView.addSubview(fieldsContainerView)
        fieldsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90).isActive = true
        fieldsContainerView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        fieldsContainerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        fieldsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        fieldsContainerView.addSubview(timePicker)
        timePicker.centerYAnchor.constraint(equalTo: fieldsContainerView.centerYAnchor, constant: -10).isActive = true
        timePicker.centerXAnchor.constraint(equalTo: fieldsContainerView.centerXAnchor, constant: 20).isActive = true
        timePicker.heightAnchor.constraint(equalToConstant: 40).isActive = true
        timePicker.widthAnchor.constraint(equalToConstant: 160).isActive = true

        fieldsContainerView.addSubview(timeImageView2)
        timeImageView2.widthAnchor.constraint(equalToConstant: 60).isActive = true
        timeImageView2.heightAnchor.constraint(equalToConstant: 60).isActive = true
        timeImageView2.leftAnchor.constraint(equalTo: timePicker.leftAnchor, constant: -45).isActive = true
        timeImageView2.centerYAnchor.constraint(equalTo: timePicker.centerYAnchor).isActive = true

        timePicker.addSubview(timeSeparator1)
        timeSeparator1.centerYAnchor.constraint(equalTo: timePicker.centerYAnchor).isActive = true
        timeSeparator1.widthAnchor.constraint(equalToConstant: 2).isActive = true
        timeSeparator1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeSeparator1.leftAnchor.constraint(equalTo: timeImageView2.rightAnchor, constant: 40).isActive = true

        timePicker.addSubview(timeSeparator2)
        timeSeparator2.centerYAnchor.constraint(equalTo: timePicker.centerYAnchor).isActive = true
        timeSeparator2.widthAnchor.constraint(equalToConstant: 2).isActive = true
        timeSeparator2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeSeparator2.leftAnchor.constraint(equalTo: timeSeparator1.rightAnchor, constant: 50).isActive = true
        
        fieldsContainerView.addSubview(hLabel)
        hLabel.leftAnchor.constraint(equalTo: timePicker.leftAnchor, constant: 28).isActive = true
        hLabel.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 10).isActive = true
        
        fieldsContainerView.addSubview(mLabel)
        mLabel.centerXAnchor.constraint(equalTo: timePicker.centerXAnchor, constant: 5).isActive = true
        mLabel.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 10).isActive = true
        
        fieldsContainerView.addSubview(sLabel)
        sLabel.rightAnchor.constraint(equalTo: timePicker.rightAnchor, constant: -20).isActive = true
        sLabel.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 10).isActive = true
        
        fieldsContainerView.addSubview(continueButton)
        continueButton.leftAnchor.constraint(equalTo: fieldsContainerView.leftAnchor).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: fieldsContainerView.bottomAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: 145).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        continueButton.layer.opacity = 1.0
        
        fieldsContainerView.addSubview(cancelButton)
        cancelButton.rightAnchor.constraint(equalTo: fieldsContainerView.rightAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: fieldsContainerView.bottomAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 145).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        cancelButton.layer.opacity = 1.0
    }
    
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
    
    let timeLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "Time",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "Hours",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
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
    
    lazy var sessionNameLabel: UILabel = {
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
    
    let zeroActivityLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "ZERO ACTIVITY",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(r: 108,g: 221,b: 56)
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.layer.masksToBounds = false
//        label.layer.cornerRadius = 7
//        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor(r: 142, g: 142, b: 142).cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 5)
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.5
        return label
    }()
    
    lazy var keepAppOnLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "KEEP APP OPEN",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-Bold", size: 35.0)
        return label
    }()
    
    let logoImageView: UIImageView = {
        var bi = UIImageView()
        let screenSize: CGRect = UIScreen.main.bounds
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.image = UIImage(named: "kapped.png")
        return bi
    }()
    
    let fieldsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 190, g: 190, b: 190).withAlphaComponent(0.9)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
//        view.layer.opacity = 0.9
        view.clipsToBounds = true
        return view
    }()
    
    lazy var timePicker: UIPickerView = {
        let tp = UIPickerView()
        tp.backgroundColor = .white
        tp.layer.masksToBounds = false
        tp.layer.cornerRadius = 7
        tp.layer.borderWidth = 2
        tp.layer.borderColor = UIColor(r: 142, g: 142, b: 142).cgColor
        tp.layer.shadowOffset = CGSize(width: 0, height: 5)
        tp.layer.shadowRadius = 2
        tp.layer.shadowOpacity = 0.5
        tp.translatesAutoresizingMaskIntoConstraints = false
        return tp
    }()
    
    let timeImageView2: UIImageView = {
        var bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.layer.masksToBounds = false
        bi.backgroundColor = .orange
        bi.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        bi.image = UIImage(named: "timer.png")
        bi.layer.cornerRadius = 60/2
        bi.layer.borderColor = UIColor(r: 142, g: 142, b: 142).cgColor
        bi.layer.shadowOffset = CGSize(width: 0, height: 7)
        bi.layer.shadowRadius = 2
        bi.layer.shadowOpacity = 0.5
        return bi
    }()
    
    let timeSeparator1: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let timeSeparator2: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let hLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "H",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let mLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "M",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let sLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "S",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let buttonsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.alpha = 1.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 216, g:216, b:216)
        button.setTitle("CONTINUE", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(r:51, g:51, b:51), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(handleContinueButton), for:.touchUpInside)
        return button
    }()
    
    @objc func handleContinueButton(){
        let str = self.startTimeLabel.text!
        let titleHours = pickerView(self.timePicker, titleForRow: timePicker.selectedRow(inComponent: 0), forComponent: 0)
        let titleMinutes = pickerView(self.timePicker, titleForRow: timePicker.selectedRow(inComponent: 1), forComponent: 1)
        let titleSeconds = pickerView(self.timePicker, titleForRow: timePicker.selectedRow(inComponent: 2), forComponent: 2)
        let substrHours = Int(str[0..<2])
        let substrMinutes = Int(str[5..<7])
        let substrSeconds = Int(str[10..<12])
        print(self.hours, self.minutes, self.seconds)
        print(substrHours!, substrMinutes!, substrSeconds!)
        if Int(titleHours!)! < substrHours!{
            ToastView.shared.short(self.view, txt_msg: "Time Entered is not allowed!")
            return
        }
        if Int(titleHours!)! == substrHours! && Int(titleMinutes!)! < substrMinutes! + 2{
            ToastView.shared.short(self.view, txt_msg: "Time Entered is not allowed!")
            return
        }
        timeInstance.hours = Int(titleHours!)!
        timeInstance.minutes = Int(titleMinutes!)!
        timeInstance.seconds = Int(titleSeconds!)!
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        DispatchQueue.main.async{
            self.sessionTimeLabel.attributedText = NSAttributedString(string: String(format: "%02d : %02d : %02d", self.timeInstance.hours, self.timeInstance.minutes, self.timeInstance.seconds),
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(r: 38,g: 126,b: 193), NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        }
        var timerShouldStopAt = UserDefaults.standard.integer(forKey: "timerStartedTime")
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: UserDefaults.standard.string(forKey: "timeZone")!)! as TimeZone
        formatter.dateFormat = "hh:mm:ss a"
        timerShouldStopAt += (timeInstance.hours * 3600000 )+(timeInstance.minutes * 60000)+(timeInstance.seconds * 1000)
        let date2 = NSDate(timeIntervalSince1970: Double(timerShouldStopAt) / 1000)
        UserDefaults.standard.set(self.timeInstance.hours, forKey: "hours")
        UserDefaults.standard.set(self.timeInstance.minutes, forKey: "minutes")
        UserDefaults.standard.set(self.timeInstance.seconds, forKey: "seconds")
        UserDefaults.standard.set(timerShouldStopAt, forKey: "timerShouldStopAtMilliSeconds")
        UserDefaults.standard.set(formatter.string(from: date2 as Date), forKey: "timerShouldStopAt")
        UserDefaults.standard.synchronize()
        self.fieldsContainerView.removeFromSuperview()
    }
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 216, g:216, b:216)
        button.setTitle("CANCEL", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(r:51, g:51, b:51), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(handleCancelButton), for:.touchUpInside)
        return button
    }()
    
    @objc func handleCancelButton(){
        self.fieldsContainerView.removeFromSuperview()
    }
    
    var results: Results<Timings>!
    var dateFormatter = DateFormatter()
    var timeFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        timePicker.dataSource = self
        timePicker.delegate = self
        UserDefaults.standard.set(2, forKey: "state")
        var timerShouldStopAt = UserDefaults.standard.integer(forKey: "timerStartedTime")
        let formatter = DateFormatter()
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        dateFormatter.timeZone = NSTimeZone(name: UserDefaults.standard.string(forKey: "timeZone")!)! as TimeZone
        dateLabel.text = dateFormatter.string(from: NSDate() as Date)
        timeFormatter = DateFormatter()
        timeFormatter.timeZone = NSTimeZone(name: UserDefaults.standard.string(forKey: "timeZone")!)! as TimeZone
        timeFormatter.dateFormat = "hh:mm a"
        timeLabel.text = timeFormatter.string(from: NSDate() as Date)
//        print("Current Date: \(dateInFormat)")
        formatter.timeZone = NSTimeZone(name: UserDefaults.standard.string(forKey: "timeZone")!)! as TimeZone
        formatter.dateFormat = "hh:mm:ss a"
        timerShouldStopAt += (UserDefaults.standard.integer(forKey: "hours") * 3600000 )+(UserDefaults.standard.integer(forKey: "minutes") * 60000)+(UserDefaults.standard.integer(forKey: "seconds") * 1000)
        print(timerShouldStopAt)
        let date2 = NSDate(timeIntervalSince1970: Double(timerShouldStopAt) / 1000)
        UserDefaults.standard.set(timerShouldStopAt, forKey: "timerShouldStopAtMilliSeconds")
        UserDefaults.standard.set(formatter.string(from: date2 as Date), forKey: "timerShouldStopAt")
        UserDefaults.standard.synchronize()
        print(UserDefaults.standard.string(forKey: "timerShouldStopAt")!)
        startTimer()
        view.backgroundColor = .white
        let realm = try! Realm()
        results = realm.objects(Timings.self)
        print("Results: \(String(describing: results))")
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
        self.timeLabel.text = timeFormatter.string(from: NSDate() as Date)
        self.dateLabel.text = dateFormatter.string(from: NSDate() as Date)
        if results.count != 0{
            self.zeroActivityLabel.isHidden = true
        }
        if Date().millisecondsSince1970 >= UserDefaults.standard.integer(forKey: "timerShouldStopAtMilliSeconds"){
            startTimeLabel.text = String(format: "%02d : %02d : %02d", timeInstance.hours, timeInstance.minutes, timeInstance.seconds)
            stopTimerTest()
            let time = Date().millisecondsSince1970
            let date = NSDate(timeIntervalSince1970: Double(time) / 1000)
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone(name: UserDefaults.standard.string(forKey: "timeZone")!)! as TimeZone
            formatter.dateFormat = "hh:mm:ss a"
            UserDefaults.standard.set(formatter.string(from: date as Date), forKey: "timerStoppedOn")
            UserDefaults.standard.synchronize()
            let endViewController = EndViewController()
            let aObjNavi = UINavigationController(rootViewController: endViewController)
            let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
            appDelegate.window?.rootViewController = aObjNavi
        }
            
        else{
            if (timeInstance.currentSeconds == 59) {
                timeInstance.currentMinutes += 1
                timeInstance.currentSeconds = 0
                if (timeInstance.currentMinutes == 60) {
                    timeInstance.currentHours += 1
                    timeInstance.currentMinutes = 0
                }
            } else {
                timeInstance.currentSeconds += 1
            }
            startTimeLabel.text = String(format: "%02d : %02d : %02d", timeInstance.currentHours, timeInstance.currentMinutes, timeInstance.currentSeconds)
            startTimeLabel.textAlignment = .center
        }
    }
    
    func stopTimerTest() {
        if timerTest != nil {
            timerTest!.invalidate()
            timerTest = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View Will Appear")
        let realm = try! Realm()
        let results = realm.objects(Timings.self)
        print("Results: \(results)")
        if results.count != 0{
            self.zeroActivityLabel.isHidden = true
        }
    }
    
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
        
        mainContainerView.addSubview(sessionTimeLabel)
        sessionTimeLabel.bottomAnchor.constraint(equalTo: timeContainerView.topAnchor, constant: -20).isActive = true
        sessionTimeLabel.leftAnchor.constraint(equalTo: mainContainerView.leftAnchor, constant: 60).isActive = true
        sessionTimeLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        sessionTimeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        mainContainerView.addSubview(timeImageView)
        timeImageView.topAnchor.constraint(equalTo: mainContainerView.topAnchor, constant: 30).isActive = true
        timeImageView.rightAnchor.constraint(equalTo: sessionTimeLabel.leftAnchor, constant: 7).isActive = true
        timeImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        timeImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        mainContainerView.addSubview(editButton)
        editButton.bottomAnchor.constraint(equalTo: timeContainerView.topAnchor, constant: -20).isActive = true
        editButton.rightAnchor.constraint(equalTo: mainContainerView.rightAnchor, constant: -15).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
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
        
        mainContainerView.addSubview(timeLabel)
        timeLabel.leadingAnchor.constraint(equalTo: yourNameLabel.leadingAnchor, constant: 10).isActive = true
        timeLabel.topAnchor.constraint(equalTo: timeContainerView.bottomAnchor, constant: 15).isActive = true
        
        mainContainerView.addSubview(dateLabel)
        dateLabel.trailingAnchor.constraint(equalTo: yourNameLabel.trailingAnchor, constant: -10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: timeContainerView.bottomAnchor, constant: 15).isActive = true
        
        mainContainerView.addSubview(sessionNameLabel)
        sessionNameLabel.topAnchor.constraint(equalTo: yourNameLabel.bottomAnchor, constant: 25).isActive = true
        sessionNameLabel.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        sessionNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sessionNameLabel.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -100).isActive = true
        
        mainContainerView.addSubview(zeroActivityLabel)
        zeroActivityLabel.topAnchor.constraint(equalTo: sessionNameLabel.bottomAnchor, constant: 25).isActive = true
        zeroActivityLabel.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        zeroActivityLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        zeroActivityLabel.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -100).isActive = true
        
        mainContainerView.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -80).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -30).isActive = true
        
        mainContainerView.addSubview(keepAppOnLabel)
        keepAppOnLabel.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        keepAppOnLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        keepAppOnLabel.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -20).isActive = true
        keepAppOnLabel.bottomAnchor.constraint(equalTo: logoImageView.topAnchor, constant: -15).isActive = true
//        keepAppOnLabel.backgroundColor = .orange
    }
}

extension PickUpViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1,2:
            return 60
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 45
    }
    
    //    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    //        return pickerView.frame.size.height
    //    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row)"
        case 1:
            return "\(row)"
        case 2:
            return "\(row)"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.hours = row
        case 1:
            self.minutes = row
        case 2:
            self.seconds = row
        default:
            break;
        }
    }
}

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}

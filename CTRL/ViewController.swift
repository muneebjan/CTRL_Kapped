//
//  ViewController.swift
//  CTRL
//
//  Created by Ali Apple on 20/11/2018.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITextFieldDelegate {
    
    let timeInstance = TimeInfo.sharedInstance

    let mainContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
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
    
    let fieldsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 207,g: 226,b: 243)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 40
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(r: 142,g: 142,b: 142).cgColor
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 7)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.5
        return view
    }()
    
    let yourNameTextField: UITextField = {
        let tf = UITextField()
        tf.font = .boldSystemFont(ofSize: 16)
        tf.placeholder = "Your Name"
        //        tf.text = "Shami@hotmail.com"
        tf.autocorrectionType = .no
        tf.backgroundColor = .white
        tf.layer.borderWidth = 2
        tf.textAlignment = .center
        tf.layer.borderColor = UIColor(r: 58, g: 58, b: 58).cgColor
        tf.layer.masksToBounds = false
        tf.clipsToBounds = true
        //        tf.textColor = UIColor(r: 28, g:168, b:261)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let gameNameTextField: UITextField = {
        let tf = UITextField()
        tf.font = .boldSystemFont(ofSize: 16)
        tf.placeholder = "Institution Name"
        //        tf.text = "Shami@hotmail.com"
        tf.autocorrectionType = .no
        tf.backgroundColor = .white
        tf.layer.borderWidth = 2
        tf.textAlignment = .center
        tf.layer.borderColor = UIColor(r: 58, g: 58, b: 58).cgColor
        tf.layer.masksToBounds = false
        tf.clipsToBounds = true
        //        tf.textColor = UIColor(r: 28, g:168, b:261)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    //TODO: DataPicker
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
        //        tp.clipsToBounds = true
        tp.translatesAutoresizingMaskIntoConstraints = false
        return tp
    }()
    
    let timeImageView: UIImageView = {
        var bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.layer.masksToBounds = false
        bi.backgroundColor = .orange
        bi.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        bi.image = UIImage(named: "timer.png")
        bi.layer.cornerRadius = 60/2
//        bi.clipsToBounds = true
//        bi.layer.borderWidth = 1
        bi.layer.borderColor = UIColor(r: 142, g: 142, b: 142).cgColor
        bi.layer.shadowOffset = CGSize(width: 0, height: 7)
        bi.layer.shadowRadius = 2
        bi.layer.shadowOpacity = 0.5
        //        bi.contentMode = .scaleAspectFit
        return bi
    }()
    
    let hoursLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "Hour",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(r: 38,g: 126,b: 193)
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let minutesLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "Min",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(r: 38,g: 126,b: 193)
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let secondsLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "Sec",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(r: 38,g: 126,b: 193)
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
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
    
    lazy var clockInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 109, g:158, b:235)
        button.setTitle("Clock In", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 45)
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(r: 142, g: 142, b: 142).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        button.addTarget(self, action: #selector(handleStartButton), for:.touchUpInside)
        return button
    }()
    
    let visitWebsiteButton: UIButton = {
        var button = UIButton()
        let myUIImage = UIImage(named: "web.png")
        button.setImage(myUIImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: Selector(("handleVisitWebsiteButton")), for:.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleVisitWebsiteButton(){
        if let url = NSURL(string: "https://www.rehapp.io/kapped"){
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    @objc func handleStartButton(){
        if !(yourNameTextField.text?.isEmpty)! && !(gameNameTextField.text?.isEmpty)!{
            if timeInstance.seconds == 0 && timeInstance.minutes == 0 && timeInstance.hours == 0{
                ToastView.shared.short(self.view, txt_msg: "Enter time limit!")
            }
            else{
                timeInstance.yourName = yourNameTextField.text!
                timeInstance.gameName = gameNameTextField.text!
                let gameStartTime = Date().millisecondsSince1970
                timeInstance.gameStartTime = gameStartTime
                let todaysDate:Date = Date()
                let dateFormatter:DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let todayString:String = dateFormatter.string(from: todaysDate)
                UserDefaults.standard.set(2, forKey: "state")
                UserDefaults.standard.set(todayString, forKey: "date")
                print("PickUp View Controller Called")
                let time = Date().millisecondsSince1970
                let date = NSDate(timeIntervalSince1970: Double(time) / 1000)
                let formatter = DateFormatter()
                formatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                formatter.dateFormat = "hh:mm:ss a"
                print("Current Time: \(formatter.string(from: date as Date))")
                UserDefaults.standard.set(formatter.string(from: date as Date), forKey: "timerStartedOn")
                UserDefaults.standard.set(true, forKey: "timerStarted")
                UserDefaults.standard.set(Date().millisecondsSince1970, forKey: "timerStartedTime")
                UserDefaults.standard.set(timeInstance.hours, forKey: "hours")
                UserDefaults.standard.set(timeInstance.minutes, forKey: "minutes")
                UserDefaults.standard.set(timeInstance.seconds, forKey: "seconds")
                UserDefaults.standard.set(timeInstance.yourName, forKey: "yourName")
                UserDefaults.standard.set(timeInstance.gameName, forKey: "gameName")
                UserDefaults.standard.synchronize()
                
                let pickUpViewController = PickUpViewController()
                let aObjNavi = UINavigationController(rootViewController: pickUpViewController)
                let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
                appDelegate.window?.rootViewController = aObjNavi
            }
        }
        else {
            ToastView.shared.short(self.view, txt_msg: "Enter all fields!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UserDefaults.standard.integer(forKey: "state"))
        UserDefaults.standard.set(0, forKey: "pickDuration")
        UserDefaults.standard.set(0, forKey: "putDownTime")
        UserDefaults.standard.set(1, forKey: "state")
        UserDefaults.standard.set(0, forKey: "currentHours")
        UserDefaults.standard.set(0, forKey: "currentMinutes")
        UserDefaults.standard.set(0, forKey: "currentSeconds")
        UserDefaults.standard.set(0, forKey: "hours")
        UserDefaults.standard.set(0, forKey: "yourName")
        UserDefaults.standard.set(0, forKey: "gameName")
        UserDefaults.standard.set(0, forKey: "timerStartedTime")
        UserDefaults.standard.set(0, forKey: "timerShouldStopAt")
        UserDefaults.standard.set(0, forKey: "putDownTimeDisplay")
        UserDefaults.standard.set(0, forKey: "minutes")
        UserDefaults.standard.set(0, forKey: "date")
        UserDefaults.standard.set(0, forKey: "seconds")
        UserDefaults.standard.set(0, forKey: "pickUpNumber")
        UserDefaults.standard.set(false, forKey: "timerStarted")
        UserDefaults.standard.set(nil, forKey: "timerStartedOn")
        UserDefaults.standard.set(0, forKey: "timerStoppedOn")
        UserDefaults.standard.synchronize()
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let myurl = NSURL(fileURLWithPath: path)
        if let pathComponent = myurl.appendingPathComponent("file.pdf") {
            let filePath = pathComponent.path
            do {
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    try fileManager.removeItem(atPath: filePath)
                } else {
                    print("File does not exist")
                }
                
            }
            catch let error as NSError {
                print("An error took place: \(error)")
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        timeInstance.gameStartTime = 0
        timeInstance.gameStopTime = 0
        
        timeInstance.pickUpTime = 0
        timeInstance.putDownTime = 0
        timeInstance.currentPickDuration = 0
        timeInstance.allPickDurations = 0
        
        timeInstance.hours = 0
        timeInstance.minutes = 0
        timeInstance.seconds = 0
        timeInstance.currentHours = 0
        timeInstance.currentMinutes = 0
        timeInstance.currentSeconds = 0
        
        timeInstance.yourName = ""
        timeInstance.gameName = ""
        
//        timeInstance.lockscreenCount = 0
//        timeInstance.foregroundCount = 0
        timeInstance.state = 0
        
        view.backgroundColor = .white
        timePicker.dataSource = self
        timePicker.delegate = self
        yourNameTextField.delegate = self
        gameNameTextField.delegate = self
        //        setupNavigationBar()
        setupKeyboard()
        setupViews()
    }

    func setupKeyboard(){
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (notification) in
            self.keyboardWillChange(notification: notification as Notification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (notification) in
            self.keyboardWillChange(notification: notification as Notification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { (notification) in
            self.keyboardWillChange(notification: notification as Notification)
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func keyboardWillChange(notification: Notification){
        //        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
        //            return
        //        }
        if notification.name.rawValue == "UIKeyboardWillChangeFrameNotification" || notification.name.rawValue == "UIKeyboardWillShowNotification"{
            view.frame.origin.y = -100
        }
        else{
            view.frame.origin.y = 0
        }
    }
    
    func setupViews(){
        
        view.addSubview(mainContainerView)
        mainContainerView.heightAnchor.constraint(equalToConstant: 667.0).isActive = true
        mainContainerView.widthAnchor.constraint(equalToConstant: 375.0).isActive = true
        mainContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        mainContainerView.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -80).isActive = true
        logoImageView.topAnchor.constraint(equalTo: mainContainerView.topAnchor, constant: 40).isActive = true
        
        mainContainerView.addSubview(fieldsContainerView)
        fieldsContainerView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 35).isActive = true
        fieldsContainerView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        fieldsContainerView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -40).isActive = true
        fieldsContainerView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        
        fieldsContainerView.addSubview(yourNameTextField)
        yourNameTextField.topAnchor.constraint(equalTo: fieldsContainerView.topAnchor, constant: 10).isActive = true
        yourNameTextField.centerXAnchor.constraint(equalTo: fieldsContainerView.centerXAnchor).isActive = true
        yourNameTextField.widthAnchor.constraint(equalTo: fieldsContainerView.widthAnchor, constant: -80).isActive = true
        yourNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        fieldsContainerView.addSubview(gameNameTextField)
        gameNameTextField.topAnchor.constraint(equalTo: yourNameTextField.bottomAnchor, constant: 10).isActive = true
        gameNameTextField.centerXAnchor.constraint(equalTo: fieldsContainerView.centerXAnchor).isActive = true
        gameNameTextField.widthAnchor.constraint(equalTo: fieldsContainerView.widthAnchor, constant: -80).isActive = true
        gameNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        fieldsContainerView.addSubview(timePicker)
        timePicker.topAnchor.constraint(equalTo: gameNameTextField.bottomAnchor, constant: 20).isActive = true
        timePicker.centerXAnchor.constraint(equalTo: fieldsContainerView.centerXAnchor, constant: 20).isActive = true
        timePicker.heightAnchor.constraint(equalToConstant: 40).isActive = true
        timePicker.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        mainContainerView.addSubview(timeImageView)
        timeImageView.leftAnchor.constraint(equalTo: timePicker.leftAnchor, constant: -45).isActive = true
        timeImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        timeImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        timeImageView.centerYAnchor.constraint(equalTo: timePicker.centerYAnchor).isActive = true
        
        timePicker.addSubview(timeSeparator1)
        timeSeparator1.centerYAnchor.constraint(equalTo: timePicker.centerYAnchor).isActive = true
        timeSeparator1.widthAnchor.constraint(equalToConstant: 2).isActive = true
        timeSeparator1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeSeparator1.leftAnchor.constraint(equalTo: timeImageView.rightAnchor, constant: 40).isActive = true
        
        timePicker.addSubview(timeSeparator2)
        timeSeparator2.centerYAnchor.constraint(equalTo: timePicker.centerYAnchor).isActive = true
        timeSeparator2.widthAnchor.constraint(equalToConstant: 2).isActive = true
        timeSeparator2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeSeparator2.leftAnchor.constraint(equalTo: timeSeparator1.rightAnchor, constant: 50).isActive = true
        
        mainContainerView.addSubview(hoursLabel)
        hoursLabel.leadingAnchor.constraint(equalTo: timePicker.leadingAnchor, constant: 15).isActive = true
        hoursLabel.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 10).isActive = true
        
        mainContainerView.addSubview(minutesLabel)
        minutesLabel.centerXAnchor.constraint(equalTo: timePicker.centerXAnchor, constant: 5).isActive = true
        minutesLabel.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 10).isActive = true
        
        mainContainerView.addSubview(secondsLabel)
        secondsLabel.trailingAnchor.constraint(equalTo: timePicker.trailingAnchor, constant: -10).isActive = true
        secondsLabel.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 10).isActive = true
        
        
        mainContainerView.addSubview(clockInButton)
        clockInButton.topAnchor.constraint(equalTo: fieldsContainerView.bottomAnchor, constant: 50).isActive = true
        clockInButton.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        clockInButton.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -60).isActive = true
        clockInButton.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        mainContainerView.addSubview(visitWebsiteButton)
        visitWebsiteButton.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -20).isActive = true
        visitWebsiteButton.rightAnchor.constraint(equalTo: mainContainerView.rightAnchor, constant: -20).isActive = true
        visitWebsiteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        visitWebsiteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

extension UIColor {
    
    convenience init (r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}

extension ViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 25
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
            timeInstance.hours = row
        case 1:
            timeInstance.minutes = row
        case 2:
            timeInstance.seconds = row
        default:
            break;
        }
    }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

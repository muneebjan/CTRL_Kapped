//
//  ReceiptViewController.swift
//  CTRL
//
//  Created by Ali Apple on 22/11/2018.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI
import WebKit

class ReceiptViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, WKNavigationDelegate{

    let timeInstance = TimeInfo.sharedInstance
    var format : DateFormatter!
    let cellId = "cellId"
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    var topBarHeight: CGFloat = 0.0
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    
    let mainContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let lineSeparator1: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let lineSeparator2: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.layer.masksToBounds = false
        //        label.layer.cornerRadius = 7
        //        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor(r: 142, g: 142, b: 142).cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 5)
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.5
        return label
    }()
    
    let qrImageView: UIImageView = {
        var bi = UIImageView()
        let screenSize: CGRect = UIScreen.main.bounds
        bi.translatesAutoresizingMaskIntoConstraints = false
//        bi.contentMode = .scaleAspectFit
        bi.image = UIImage(named: "qr.png")
        return bi
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
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.sizeToFit()
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.black.cgColor
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
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.sizeToFit()
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
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: UserDefaults.standard.string(forKey: "date")!,
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    lazy var presetShiftLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "PRESET SHIFT:",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.backgroundColor = UIColor(r: 252, g: 227, b: 206)
        label.sizeToFit()
        return label
    }()
    
    lazy var presetShiftTimeLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: String(format: "%02d:%02d:%02d", timeInstance.hours, timeInstance.minutes, timeInstance.seconds),
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = UIColor(r: 252, g: 227, b: 206)
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    lazy var timeInLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "CLOCK IN:",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.backgroundColor = UIColor(r: 219, g: 231, b: 215)
        label.sizeToFit()
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: UserDefaults.standard.string(forKey: "timerStartedOn") ?? "00 : 00 : 00",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.layer.borderWidth = 0.5
        label.backgroundColor = UIColor(r: 219, g: 231, b: 215)
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    lazy var totalPickUpLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "Phone Activity:",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.backgroundColor = UIColor(r: 255, g: 243, b: 203)
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    lazy var totalPickUpDurationLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "\(UserDefaults.standard.integer(forKey: "pickDuration"))",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.layer.borderWidth = 0.5
        label.backgroundColor = UIColor(r: 255, g: 243, b: 203)
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    lazy var minLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "min",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.layer.borderWidth = 0.5
        label.backgroundColor = UIColor(r: 255, g: 243, b: 203)
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    lazy var workTimeLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "WORK TIME:",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.layer.borderWidth = 0.5
        label.backgroundColor = UIColor(r: 252, g: 227, b: 206)
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    lazy var workTimeDurationLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "WORK TIME",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.layer.borderWidth = 0.5
        label.backgroundColor = UIColor(r: 254, g: 241, b: 210)
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = UIColor(r: 252, g: 227, b: 206)
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    lazy var workMinLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "min",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.layer.borderWidth = 0.5
        label.backgroundColor = UIColor(r: 252, g: 227, b: 206)
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    lazy var timeOutLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "CLOCKED OUT:",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = UIColor(r: 240, g: 204, b: 205)
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    lazy var timeOutTimeLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "00:00:00",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.layer.borderWidth = 0.5
        label.backgroundColor = UIColor(r: 240, g: 204, b: 205)
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    let collectionContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let buttonsContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor(r: 142, g: 142, b: 142).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let messageButton: UIButton = {
        var button = UIButton()
        let myUIImage = UIImage(named: "messages.png")
        button.setImage(myUIImage, for: .normal)
//        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: Selector(("handleMessage")), for:.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleMessage(){
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = nil
        composeVC.body = ""
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let myurl = NSURL(fileURLWithPath: path)
        if let pathComponent = myurl.appendingPathComponent("\(UserDefaults.standard.string(forKey: "yourName")!)_\(UserDefaults.standard.string(forKey: "gameName")!)_Kapper.pdf") {
            let filePath = pathComponent.path
            print("File Path: \(filePath)")
            do {
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    try composeVC.addAttachmentData(NSData(contentsOfFile: filePath) as Data, typeIdentifier: "application/pdf", filename: "\(UserDefaults.standard.string(forKey: "yourName")!)_\(UserDefaults.standard.string(forKey: "gameName")!)_Kapper.pdf")
                    print("Writing PDF")
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
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    let emailButton: UIButton = {
        var button = UIButton()
        let myUIImage = UIImage(named: "mail.png")
        button.setImage(myUIImage, for: .normal)
//        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: Selector(("handleMail")), for:.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleMail(){
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([""])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let myurl = NSURL(fileURLWithPath: path)
        if let pathComponent = myurl.appendingPathComponent("\(UserDefaults.standard.string(forKey: "yourName")!)_\(UserDefaults.standard.string(forKey: "gameName")!)_Kapper.pdf") {
            let filePath = pathComponent.path
            do {
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    try mailComposerVC.addAttachmentData(NSData(contentsOfFile: filePath) as Data, mimeType: "application/pdf", fileName: "\(UserDefaults.standard.string(forKey: "yourName")!)_\(UserDefaults.standard.string(forKey: "gameName")!)_Kapper.pdf")
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
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    lazy var exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 109,g: 158,b: 235)
        button.setTitle("EXIT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 38)
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(r: 142, g: 142, b: 142).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 7)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.4
        button.addTarget(self, action: #selector(handleExitButton), for:.touchUpInside)
        return button
    }()
    
//    let alert = UIAlertController(title: "Warning!", message: "If you continue, all information will be lost; text/email to save receipt!", preferredStyle: UIAlertController.Style.alert)
    
    @objc func handleExitButton(){
        self.timeInstance.logs = """
        """
        timeInstance.isTutorialScreenLoadable = false
        let attributedString = NSAttributedString(string: "Warning!", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), //your font here
            NSAttributedString.Key.foregroundColor : UIColor.red
            ])
        let uiAlert = UIAlertController(title: "", message: "If you continue, all information will be lost: text/email to save receipt!", preferredStyle: UIAlertController.Style.alert)
        uiAlert.setValue(attributedString, forKey: "attributedTitle")
//        self.present(uiAlert, animated: true, completion: nil)
        
        uiAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
            self.deinitializeValues(arg: true, completion: { (success) -> Void in
                if success {
                    let viewController = ViewController()
                    let aObjNavi = UINavigationController(rootViewController: viewController)
                    let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
                    appDelegate.window?.rootViewController = aObjNavi
                } else {
                    print("false")
                }
            })

        }))
        
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Click of cancel button")
        }))
        uiAlert.view.layoutIfNeeded()
        self.present(uiAlert, animated: true, completion: nil)
    }
    
    lazy var logsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 109,g: 158,b: 235)
        button.setTitle("Logs", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(r: 142, g: 142, b: 142).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 7)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.4
        button.addTarget(self, action: #selector(handleLogs), for:.touchUpInside)
        return button
    }()
    
    @objc func handleLogs(){
        let viewController = LogsViewController()
        let aObjNavi = UINavigationController(rootViewController: viewController)
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        appDelegate.window?.rootViewController = aObjNavi
    }
    
    func deinitializeValues(arg: Bool, completion: (Bool) -> ()){
        UserDefaults.standard.set(0, forKey: "pickUpNumber")
        UserDefaults.standard.set(1, forKey: "state")
        AppDelegate.pickUpNumber = 0
        UserDefaults.standard.synchronize()
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        self.stopTimerTest()
        for view in self.view.subviews{
            view.removeFromSuperview()
        }
        completion(true)
    }
    
    func handleContinue(){
        
    }
    
    func handleCancel(){
//        self.dismiss(alert, animated: true, completion: nil)
    }
    
    var boxView = UIView()
    
    func addSavingPhotoView() {
        // You only need to adjust this frame to move it anywhere you want
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        boxView.backgroundColor = UIColor.lightGray
        boxView.alpha = 1
        boxView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        
        textLabel.textColor = UIColor.darkGray
        textLabel.text = "Saving Pickups"
        self.boxView.addSubview(activityView)
        self.boxView.addSubview(textLabel)
        print("box set")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(4, forKey: "state")
        UserDefaults.standard.set(0, forKey: "pickUpNumber")
        let workTime = UserDefaults.standard.integer(forKey: "timerShouldStopAtMilliSeconds") - UserDefaults.standard.integer(forKey: "timerStartedTime") - UserDefaults.standard.integer(forKey: "pickDuration")
        print(workTime)
        timeFormatter = DateFormatter()
        timeFormatter.timeZone = NSTimeZone(name: UserDefaults.standard.string(forKey: "timeZone")!)! as TimeZone
        timeFormatter.dateFormat = "hh:mm a"
        currentTimeLabel.textAlignment = .center
        currentTimeLabel.text = timeFormatter.string(from: NSDate() as Date)
        startTimer()
        addSavingPhotoView()
//        UserDefaults.standard.set(msToTime(duration: workTime), forKey: "workTime")
        UserDefaults.standard.synchronize()
        view.backgroundColor = .white
        topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionView.frame = CGRect(x: 0, y: 60, width: 320, height: 100)
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        //        self.collectionView.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
        self.collectionView.backgroundColor = .clear
        totalPickUpDurationLabel.text = msToTime(duration: UserDefaults.standard.integer(forKey: "pickDuration"))
        workTimeDurationLabel.text = msToTime(duration: workTime)
        timeOutTimeLabel.text = "\(UserDefaults.standard.string(forKey: "timerShouldStopAt")!)"
        let totalDuration: Int = UserDefaults.standard.integer(forKey: "pickDuration")
//        let workDuration: Int = UserDefaults.standard.integer(forKey: "timerStartedTime")
        print("pickDuration: \(totalDuration)")
        
        if (totalDuration/(1000*60*60))%24 != 0{
            minLabel.text = "  hour"
        }
        else{
            if (totalDuration/(1000*60))%60 != 0{
                minLabel.text = "  min"
            }
            else{
                minLabel.text = "  sec"
            }
        }
        
        if (workTime/(1000*60*60))%24 != 0{
            workMinLabel.text = "  hour"
        }
        else{
            if (workTime/(1000*60))%60 != 0{
                workMinLabel.text = "  min"
            }
            else{
                workMinLabel.text = "  sec"
            }
        }
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SpreadSheet.self, forCellWithReuseIdentifier: cellId)
        let realm = try! Realm()
        let results = realm.objects(Timings.self)
        if results.count != 0{
            self.zeroActivityLabel.isHidden = true
        }
        for (index, element) in results.enumerated(){
            pdfDataAdder += "<tr bgcolor='#ffffff'><td>\(results[index].pickUpNumber)</td><td>\(results[index].dropDownTime)</td><td>\(results[index].pickUpTime)</td></tr>"
            dataToQr += "|\(results[index].pickUpNumber)|\(results[index].dropDownTime)|\(results[index].pickUpTime)"
        }
        print("PDF Adder: \(pdfDataAdder)")
        setupViews()
    }
    
    weak var webView: WKWebView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.webView = WKWebView(frame: self.view.frame)
        self.view.addSubview(self.webView!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createPDF()
        return
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if #available(iOS 9.0, *)
        {
            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
            let date = NSDate(timeIntervalSince1970: 0)
            
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
        }
        else
        {
            var libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, false).first!
            libraryPath += "/Cookies"
            
            do {
                try FileManager.default.removeItem(atPath: libraryPath)
            } catch {
                print("error")
            }
            URLCache.shared.removeAllCachedResponses()
        }
        self.webView = nil
    }
    
    func generateQrCode(arg: Bool, completion: (Bool) -> ()){
        let data = self.dataToQr.data(using: .ascii, allowLossyConversion: false)
//        print(self.html)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        let img = UIImage(ciImage: (filter?.outputImage)!)
        self.qrImageView.image = img
        completion(true)
    }
    
    func msToTime(duration: Int) -> String{
        print("Total Duration: \(duration)")
        let seconds = (duration/1000)%60
        let minutes = (duration/(1000*60))%60
        let hours = (duration/(1000*60*60))%24
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let realm = try! Realm()
        let results = realm.objects(Timings.self)
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SpreadSheet
//        cell.pickUpLabel.text = "Pickup \(indexPath.row + 1)"
        let realm = try! Realm()
        let results = realm.objects(Timings.self)
        if results.count >= 0{
            cell.pickUpLabel.text = results[indexPath.row].pickUpNumber
            cell.startTimeLabel.text = results[indexPath.row].dropDownTime
            cell.stopTimeLabel.text = results[indexPath.row].pickUpTime
        }
        else{
            cell.pickUpLabel.text = ""
            cell.startTimeLabel.text = ""
            cell.stopTimeLabel.text = ""
        }
//        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 320, height: 20)
    }
    
    var html = """
                """
    var pdfCreatorCount = 0
    var dataToQr = ""
    var pdfDataAdder: String = ""
    func createPDF() {
        html = "<div style='display: flex; justify-content: center;'><table width='50%' cellspacing='1' cellpadding='0' border='0' bgcolor='#999999' align='center'><tr bgcolor='#ffffff'><td>\(self.yourNameLabel.text!)</td><td>\(self.institutionNameLabel.text!)</td><td> </td></tr><tr bgcolor='#ffffff'><td align='center'>\(self.dateLabel.text!)</td><td bgcolor='#fce3ce' align='right'>\(presetShiftLabel.text!)</td><td bgcolor='#fce3ce' align='right'>\(presetShiftTimeLabel.text!)</td></tr><tr bgcolor='#ffffff'><td bgcolor='#dbe8d5' align='right'>\(self.timeInLabel.text!)</td><td bgcolor='#dbe8d5' align='right'>\(self.timeLabel.text!)</td><td> </td></tr>\(self.pdfDataAdder)<tr bgcolor='#ffffff'><td bgcolor='#fff3cb' align='right'>\(self.totalPickUpLabel.text!)</td><td bgcolor='#fff3cb' align='right'>\(self.totalPickUpDurationLabel.text!)</td><td bgcolor='#fff3cb'>\(self.minLabel.text!)</td></tr><tr bgcolor='#ffffff'><td bgcolor='#fce3ce' align='right'>\(self.workTimeLabel.text!)</td><td bgcolor='#fce3ce' align='right'>\(self.workTimeDurationLabel.text!)</td><td bgcolor='#fce3ce'>\(self.workMinLabel.text!)</td></tr><tr bgcolor='#ffffff'><td bgcolor='#f1cccb' align='right'>\(self.timeOutLabel.text!)</td><td bgcolor='#f1cccb' align='right'>\(self.timeOutTimeLabel.text!)</td><td> </td></tr></table></div>"
        //        <img src='data:image/png;base64,\(String(describing: base64String) )'></img>
//        }
        if pdfCreatorCount == 0{
            dataToQr += "|\(self.yourNameLabel.text!)|\(self.institutionNameLabel.text!)|\(self.dateLabel.text!)|\(self.presetShiftTimeLabel.text!)|\(self.timeLabel.text!)|\(totalPickUpDurationLabel.text!)|\(minLabel.text!)|\(workTimeDurationLabel.text!)|\(workMinLabel.text!)|\(timeOutTimeLabel.text!)"
            dataToQr.remove(at: dataToQr.startIndex)
            pdfCreatorCount = 1
        }
        print(dataToQr)
        
        generateQrCode(arg: true, completion: { [weak self](success) -> Void in
            print("QR Code Generated")
            let image1 = captureView()
            let imageData1 = image1.pngData() ?? nil
            let base64String1 = imageData1?.base64EncodedString() ?? ""
            
            var image2 = UIImage(named:"empty")
            if self?.html.contains("Pickup 1") ?? false {
                print("pickup 1 Found")
            }
            else{
//                weak var image =
                image2 = UIImage(named:"zeroActivity")
                print("pickup Not found")
//                image = nil
            }
            let imageData2 = image2!.pngData() ?? nil
            let base64String2 = imageData2?.base64EncodedString() ?? ""
            
            let image3 = UIImage(named:"kapped")
            let imageData3 = image3!.pngData() ?? nil
            let base64String3 = imageData3?.base64EncodedString() ?? ""
            
            if success { // this will be equal to whatever value is set in this method call
                self?.html += "<html><body><div style='text-align: center'><p><br></p><p><b><img width='50%' height='20%' src='data:image/png;base64,\(String(describing: base64String1))'/><p><br></p><p><b><img width='50%' height='5%' src='data:image/png;base64,\(String(describing: base64String2))'/><p><br></p><p><b><img width='30%' height='5%' src='data:image/png;base64,\(String(describing: base64String3))'/></b></p></div></body></html>"
                self?.webView!.navigationDelegate = self
                self?.webView!.loadHTMLString(html, baseURL: nil)
                self?.webView!.isUserInteractionEnabled = false
//                let fmt = UIMarkupTextPrintFormatter(markupText: self.html)
                self?.boxView.removeFromSuperview()
                // 2. Assign print formatter to UIPrintPageRenderer
            } else {
                print("false")
            }
        })
    }
    
    func captureView() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(qrImageView.bounds.size, false,UIScreen.main.scale)//add this line
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.qrImageView.layer.render(in: context)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(webView.viewPrintFormatter(), startingAtPageAt: 0)
        
        // 3. Assign paperRect and printableRect
        
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)
        
        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
        
        // 4. Create PDF context and draw
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
        
        for i in 1...render.numberOfPages {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }
        
        UIGraphicsEndPDFContext();
        
        // 5. Save PDF file
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        pdfData.write(toFile: "\(documentsPath)/\(UserDefaults.standard.string(forKey: "yourName")!)_\(UserDefaults.standard.string(forKey: "gameName")!)_Kapper.pdf", atomically: true)
        print("\(documentsPath)/\(UserDefaults.standard.string(forKey: "yourName")!)_\(UserDefaults.standard.string(forKey: "gameName")!)_Kapper.pdf")
        webView.removeFromSuperview()
    }
    
    var timeFormatter = DateFormatter()
    
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
        self.currentTimeLabel.textAlignment = .center
        self.currentTimeLabel.text = timeFormatter.string(from: NSDate() as Date)
    }
    
    func stopTimerTest() {
        if timerTest != nil {
            timerTest!.invalidate()
            timerTest = nil
        }
    }
    
    func setupViews(){
        view.addSubview(mainContainerView)
        mainContainerView.heightAnchor.constraint(equalToConstant: 667.0).isActive = true
        mainContainerView.widthAnchor.constraint(equalToConstant: 375.0).isActive = true
        mainContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        mainContainerView.addSubview(qrImageView)
        qrImageView.leftAnchor.constraint(equalTo: mainContainerView.leftAnchor, constant: 20).isActive = true
        qrImageView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        qrImageView.widthAnchor.constraint(equalToConstant: 170).isActive = true
//        qrImageView.heightAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -10).isActive = true
        qrImageView.topAnchor.constraint(equalTo: mainContainerView.topAnchor, constant: 40).isActive = true
//        qrImageView.topAnchor.constraint(equalTo: mainContainerView.topAnchor, constant: 20).isActive = true

        mainContainerView.addSubview(logoImageView)
        logoImageView.topAnchor.constraint(equalTo: mainContainerView.topAnchor, constant: 47).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        logoImageView.leftAnchor.constraint(equalTo: qrImageView.rightAnchor, constant: 30).isActive = true
        
        mainContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        currentTimeLabel.leftAnchor.constraint(equalTo: qrImageView.rightAnchor, constant: 30).isActive = true
        
        mainContainerView.addSubview(zeroActivityLabel)
        zeroActivityLabel.centerXAnchor.constraint(equalTo: currentTimeLabel.centerXAnchor).isActive = true
        zeroActivityLabel.widthAnchor.constraint(equalToConstant: 160).isActive = true
        zeroActivityLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        zeroActivityLabel.topAnchor.constraint(equalTo: currentTimeLabel.bottomAnchor, constant: 10).isActive = true
        
        mainContainerView.addSubview(lineSeparator1)
        lineSeparator1.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        lineSeparator1.heightAnchor.constraint(equalToConstant: 2).isActive = true
        lineSeparator1.widthAnchor.constraint(equalToConstant: 360).isActive = true
        lineSeparator1.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 15).isActive = true
        
        mainContainerView.addSubview(collectionContainerView)
        collectionContainerView.topAnchor.constraint(equalTo: lineSeparator1.bottomAnchor, constant: 15).isActive = true
        collectionContainerView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        collectionContainerView.widthAnchor.constraint(equalToConstant: 320).isActive = true
        collectionContainerView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        
        collectionContainerView.addSubview(yourNameLabel)
        yourNameLabel.topAnchor.constraint(equalTo: collectionContainerView.topAnchor).isActive = true
        yourNameLabel.leftAnchor.constraint(equalTo: collectionContainerView.leftAnchor).isActive = true
        yourNameLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        yourNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectionContainerView.addSubview(institutionNameLabel)
        institutionNameLabel.topAnchor.constraint(equalTo: collectionContainerView.topAnchor).isActive = true
        institutionNameLabel.leftAnchor.constraint(equalTo: yourNameLabel.rightAnchor).isActive = true
        institutionNameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        institutionNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectionContainerView.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: yourNameLabel.bottomAnchor).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: collectionContainerView.leftAnchor).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectionContainerView.addSubview(presetShiftLabel)
        presetShiftLabel.topAnchor.constraint(equalTo: yourNameLabel.bottomAnchor).isActive = true
        presetShiftLabel.leftAnchor.constraint(equalTo: dateLabel.rightAnchor).isActive = true
        presetShiftLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        presetShiftLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectionContainerView.addSubview(presetShiftTimeLabel)
        presetShiftTimeLabel.topAnchor.constraint(equalTo: yourNameLabel.bottomAnchor).isActive = true
        presetShiftTimeLabel.leftAnchor.constraint(equalTo: presetShiftLabel.rightAnchor).isActive = true
        presetShiftTimeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        presetShiftTimeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectionContainerView.addSubview(timeInLabel)
        timeInLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        timeInLabel.leftAnchor.constraint(equalTo: collectionContainerView.leftAnchor).isActive = true
        timeInLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        timeInLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectionContainerView.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: timeInLabel.rightAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectionContainerView.addSubview(self.collectionView)
        self.collectionView.topAnchor.constraint(equalTo: timeInLabel.bottomAnchor).isActive = true
        self.collectionView.leftAnchor.constraint(equalTo: collectionContainerView.leftAnchor).isActive = true
        self.collectionView.centerXAnchor.constraint(equalTo: collectionContainerView.centerXAnchor).isActive = true

        collectionContainerView.addSubview(totalPickUpLabel)
        totalPickUpLabel.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor).isActive = true
        totalPickUpLabel.leftAnchor.constraint(equalTo: collectionContainerView.leftAnchor).isActive = true
        totalPickUpLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        totalPickUpLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectionContainerView.addSubview(totalPickUpDurationLabel)
        totalPickUpDurationLabel.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor).isActive = true
        totalPickUpDurationLabel.leftAnchor.constraint(equalTo: totalPickUpLabel.rightAnchor).isActive = true
        totalPickUpDurationLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        totalPickUpDurationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectionContainerView.addSubview(minLabel)
        minLabel.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor).isActive = true
        minLabel.leftAnchor.constraint(equalTo: totalPickUpDurationLabel.rightAnchor).isActive = true
        minLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        minLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectionContainerView.addSubview(workTimeLabel)
        workTimeLabel.topAnchor.constraint(equalTo: totalPickUpLabel.bottomAnchor).isActive = true
        workTimeLabel.leftAnchor.constraint(equalTo: collectionContainerView.leftAnchor).isActive = true
        workTimeLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        workTimeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectionContainerView.addSubview(workTimeDurationLabel)
        workTimeDurationLabel.topAnchor.constraint(equalTo: totalPickUpLabel.bottomAnchor).isActive = true
        workTimeDurationLabel.leftAnchor.constraint(equalTo: workTimeLabel.rightAnchor).isActive = true
        workTimeDurationLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        workTimeDurationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectionContainerView.addSubview(workMinLabel)
        workMinLabel.topAnchor.constraint(equalTo: totalPickUpLabel.bottomAnchor).isActive = true
        workMinLabel.leftAnchor.constraint(equalTo: workTimeDurationLabel.rightAnchor).isActive = true
        workMinLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        workMinLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectionContainerView.addSubview(timeOutLabel)
        timeOutLabel.topAnchor.constraint(equalTo: workTimeLabel.bottomAnchor).isActive = true
        timeOutLabel.leftAnchor.constraint(equalTo: collectionContainerView.leftAnchor).isActive = true
        timeOutLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        timeOutLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectionContainerView.addSubview(timeOutTimeLabel)
        timeOutTimeLabel.topAnchor.constraint(equalTo: workTimeLabel.bottomAnchor).isActive = true
        timeOutTimeLabel.leftAnchor.constraint(equalTo: timeOutLabel.rightAnchor).isActive = true
        timeOutTimeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeOutTimeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        mainContainerView.addSubview(emailButton)
        emailButton.rightAnchor.constraint(equalTo: mainContainerView.centerXAnchor, constant: -15).isActive = true
        emailButton.topAnchor.constraint(equalTo: timeOutTimeLabel.bottomAnchor, constant: 15).isActive = true
        emailButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        emailButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        mainContainerView.addSubview(messageButton)
        messageButton.leftAnchor.constraint(equalTo: mainContainerView.centerXAnchor, constant: 15).isActive = true
        messageButton.topAnchor.constraint(equalTo: timeOutTimeLabel.bottomAnchor, constant: 15).isActive = true
        messageButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        messageButton.heightAnchor.constraint(equalToConstant: 70).isActive = true

        mainContainerView.addSubview(lineSeparator2)
        lineSeparator2.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        lineSeparator2.heightAnchor.constraint(equalToConstant: 2).isActive = true
        lineSeparator2.widthAnchor.constraint(equalToConstant: 340).isActive = true
        lineSeparator2.topAnchor.constraint(equalTo: messageButton.bottomAnchor, constant: 15).isActive = true
        
        mainContainerView.addSubview(exitButton)
        exitButton.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        exitButton.topAnchor.constraint(equalTo: lineSeparator2.bottomAnchor, constant: 15).isActive = true

        mainContainerView.addSubview(logsButton)
        logsButton.leftAnchor.constraint(equalTo: exitButton.rightAnchor, constant: 10).isActive = true
        logsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logsButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        logsButton.topAnchor.constraint(equalTo: lineSeparator2.bottomAnchor, constant: 15).isActive = true
        
        self.view.addSubview(self.boxView)
    }
}

class SpreadSheet: BaseCell {
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let pickUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Pickup 1"
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let startTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "4:00:00 PM"
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let stopTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "4:40:00 PM"
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    override func setupViews() {
        //        addSubview(dividerLineView)
        
        setupContainerView()
        
        //        addConstraintsWithFormat(format: "H:|[v0]|", views: dividerLineView)
        //        addConstraintsWithFormat(format: "V:[v0(1)]|", views: dividerLineView)
    }
    
    private func setupContainerView() {
        let containerView = UIView()
        addSubview(containerView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        addConstraintsWithFormat(format: "V:[v0(20)]", views: containerView)
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        containerView.addSubview(pickUpLabel)
        containerView.addSubview(startTimeLabel)
        containerView.addSubview(stopTimeLabel)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0(120)][v1(100)][v2(100)]", views: pickUpLabel, startTimeLabel, stopTimeLabel)
        
        containerView.addConstraintsWithFormat(format: "V:|[v0]", views: pickUpLabel)
        containerView.addConstraintsWithFormat(format: "V:|[v0]", views: startTimeLabel)
        containerView.addConstraintsWithFormat(format: "V:|[v0]", views: stopTimeLabel)
        
        //        containerView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1(20)]-12-|", views: messageLabel, hasReadImageView)
        
        //        containerView.addConstraintsWithFormat(format: "V:|[v0(24)]", views: stopTimeLabel)
    }
    
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .blue
    }
}

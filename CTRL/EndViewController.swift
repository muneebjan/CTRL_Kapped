//
//  EndViewController.swift
//  CTRL
//
//  Created by Ali Apple on 22/11/2018.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {

    var timeInstance = TimeInfo.sharedInstance
    var format : DateFormatter!
    
    let mainContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    lazy var timeLabel: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        //        button.setTitle("hh:mm:ss PM", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(r: 142, g: 142, b: 142).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 2
        //        button.textAlignment = .center
        button.layer.shadowOpacity = 0.5
        button.isEnabled = false
        //        label.addTarget(self, action: #selector(handleStartButton), for:.touchUpInside)
        return button
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
        label.attributedText = NSAttributedString(string: String(format: "%02d : %02d : %02d", timeInstance.hours, timeInstance.minutes, timeInstance.seconds),
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(r: 50,g: 97,b: 152)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    
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
    
    lazy var completeLabel: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 217, g:234, b:210)
        //        button.setTitle("hh:mm:ss PM", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(r: 56, g: 119, b: 29), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitle("COMPLETE!", for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(r: 148, g: 194, b: 130).cgColor
        button.layer.masksToBounds = false
        button.isEnabled = false
        //        label.addTarget(self, action: #selector(handleStartButton), for:.touchUpInside)
        return button
    }()
    
    lazy var clockOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 109,g: 158,b: 235)
        button.setTitle("Clock Out", for: .normal)
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
        button.addTarget(self, action: #selector(handleClockOutButton), for:.touchUpInside)
        return button
    }()
    
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
    
    @objc func handleClockOutButton(){
        setTimerStartedFalse(arg: true, completion: { [weak self] (success) -> Void in
            print("Second line of code executed")
            if success {
                let aObjNavi = UINavigationController(rootViewController: ReceiptViewController())
                let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
                appDelegate.window?.rootViewController = aObjNavi
            } else {
                print("false")
            }
            print(UserDefaults.standard.bool(forKey: "timerStarted"))
        })
    }
    
    func setTimerStartedFalse(arg: Bool, completion: (Bool) -> ()){
        self.view.addSubview(self.boxView)
        print("clock out")
        print("spinner started")
        UserDefaults.standard.set(false, forKey: "timerStarted")
        UserDefaults.standard.synchronize()
        completion(true)
    }
    
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
        UserDefaults.standard.set(3, forKey: "state")
        UserDefaults.standard.set(false, forKey: "timerStarted")
        UserDefaults.standard.synchronize()
        print(UserDefaults.standard.integer(forKey: "seconds"))
        addSavingPhotoView()
        view.backgroundColor = .white
        setupViews()
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
        
        mainContainerView.addSubview(completeLabel)
        completeLabel.topAnchor.constraint(equalTo: timeContainerView.bottomAnchor, constant: 20).isActive = true
        completeLabel.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        completeLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        completeLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        mainContainerView.addSubview(clockOutButton)
        clockOutButton.topAnchor.constraint(equalTo: completeLabel.bottomAnchor, constant: 40).isActive = true
        clockOutButton.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        clockOutButton.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -60).isActive = true
        clockOutButton.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        mainContainerView.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -80).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -30).isActive = true
        
    }

}

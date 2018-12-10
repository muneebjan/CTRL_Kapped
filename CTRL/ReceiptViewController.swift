//
//  ReceiptViewController.swift
//  CTRL
//
//  Created by Ali Apple on 22/11/2018.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

import UIKit
import RealmSwift
import WebKit
import MessageUI

class ReceiptViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate{

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
    
    let logoImageView: UIImageView = {
        var bi = UIImageView()
        let screenSize: CGRect = UIScreen.main.bounds
        bi.translatesAutoresizingMaskIntoConstraints = false
        //        bi.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        bi.image = UIImage(named: "kapped.png")
        //        bi.contentMode = .scaleAspectFit
        return bi
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
    
    lazy var timeInLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "TIME IN",
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
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: UserDefaults.standard.string(forKey: "timerStartedOn")!,
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
        label.attributedText = NSAttributedString(string: "Total Activity",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.backgroundColor = UIColor(r: 254, g: 241, b: 210)
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
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
        label.backgroundColor = UIColor(r: 254, g: 241, b: 210)
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
        label.backgroundColor = UIColor(r: 254, g: 241, b: 210)
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
        label.attributedText = NSAttributedString(string: "TIME OUT",
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
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: Selector(("handleMessage")), for:.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleMessage(){
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = [""]
        composeVC.body = ""
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let myurl = NSURL(fileURLWithPath: path)
        if let pathComponent = myurl.appendingPathComponent("file.pdf") {
            let filePath = pathComponent.path
            do {
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    try composeVC.addAttachmentData(NSData(contentsOfFile: filePath) as Data, typeIdentifier: "application/pdf", filename: "file.pdf")
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
        button.contentMode = .scaleAspectFill
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
//        let fileManager = FileManager.default
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let fileData = URL(fileURLWithPath: documentsPath, isDirectory: true).appendingPathComponent("file").appendingPathExtension("pdf")
//        if let filePath = Bundle.main.path(forResource: "file", ofType: "pdf") {
//            print("File path loaded.")
//            if let fileData = NSData(contentsOfFile: "\(filePath)"){
//                print("File data loaded.")
//                mailComposerVC.addAttachmentData(fileData as Data, mimeType: "application/pdf", fileName: "file.pdf")
//            }
//        }
//        else{
//            print("File not found2")
//        }
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let myurl = NSURL(fileURLWithPath: path)
        if let pathComponent = myurl.appendingPathComponent("file.pdf") {
            let filePath = pathComponent.path
            do {
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    try mailComposerVC.addAttachmentData(NSData(contentsOfFile: filePath) as Data, mimeType: "application/pdf", fileName: "file.pdf")
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
    
    let messageLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "Message",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let mailLabel: UILabel = {
        let label = UILabel()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "Mail",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 109, g:158, b:235)
        button.setTitle("EXIT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 45)
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(r: 142, g: 142, b: 142).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.4
        button.addTarget(self, action: #selector(handleExitButton), for:.touchUpInside)
        return button
    }()
    
    @objc func handleExitButton(){
        UserDefaults.standard.set(0, forKey: "pickUpNumber")
        UserDefaults.standard.set(1, forKey: "state")
        AppDelegate.pickUpNumber = 0
        UserDefaults.standard.synchronize()
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        let viewController = ViewController()
        let aObjNavi = UINavigationController(rootViewController: viewController)
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        appDelegate.window?.rootViewController = aObjNavi
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(4, forKey: "state")
        UserDefaults.standard.set(0, forKey: "pickUpNumber")
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
        timeOutTimeLabel.text = "\(UserDefaults.standard.string(forKey: "timerShouldStopAt")!)"
        let totalDuration: Int = UserDefaults.standard.integer(forKey: "pickDuration")
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
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SpreadSheet.self, forCellWithReuseIdentifier: cellId)
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        let results = realm.objects(Timings.self)
            for (index, element) in results.enumerated(){
                pdfDataAdder += """
                <tr bgcolor="#ffffff">
                    <td>\(results[index].pickUpNumber)</td>
                    <td>\(results[index].dropDownTime)</td>
                    <td>\(results[index].pickUpTime)</td>
                </tr>
                """
            }
            print("PDF Adder: \(pdfDataAdder)")
        createPDF()
        return
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
            cell.pickUpLabel.text = "0"
            cell.startTimeLabel.text = "00:00:00"
            cell.stopTimeLabel.text = "00:00:00"
        }
//        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 320, height: 20)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        createPDF()
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
    
//    func loadPDF(filename: String) {
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//        let myurl = NSURL(fileURLWithPath: path)
//        if let pathComponent = myurl.appendingPathComponent("file.pdf") {
//            let filePath = pathComponent.path
//            print(filePath)
//            let fileManager = FileManager.default
//            if fileManager.fileExists(atPath: filePath) {
//                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//                let url = URL(fileURLWithPath: documentsPath, isDirectory: true).appendingPathComponent(filename).appendingPathExtension("pdf")
//                print(url)
//                let urlRequest = URLRequest(url: url)
//                webView.load(urlRequest)
//            } else {
//                print("File does not exist")
//            }
//        } else {
//            print("FILE PATH NOT AVAILABLE")
//        }
//    }
    var pdfDataAdder: String = ""
    func createPDF() {
//        var html = ""
//        let html = "<b>Hello <i>World!</i></b> <p>Generate PDF file from HTML in Swift</p>"
//        DispatchQueue.main.async{
        let html = """
        <table width="50%" cellspacing="1" cellpadding="0" border="0" bgcolor="#999999">
            <tr bgcolor="#ffffff">
                <td>\(self.yourNameLabel.text!)</td>
                <td>\(self.institutionNameLabel.text!)</td>
                <td> </td>
            </tr>
            <tr bgcolor="#ffffff">
                <td align="center">\(self.dateLabel.text!)</td>
                <td> </td>
                <td> </td>
            </tr>
            <tr bgcolor="#ffffff">
                <td>\(self.timeInLabel.text!)</td>
                <td bgcolor="#dbe8d5">\(self.timeLabel.text!)</td>
                <td> </td>
            </tr>
            \(self.pdfDataAdder)
            <tr bgcolor="#ffffff">
                <td bgcolor="#fef0d7">\(self.totalPickUpLabel.text!)</td>
                <td bgcolor="#fef0d7">\(self.totalPickUpDurationLabel.text!)</td>
                <td bgcolor="#fef0d7">\(self.minLabel.text!)</td>
            </tr>
            <tr bgcolor="#ffffff">
                <td>\(self.timeOutLabel.text!)</td>
                <td bgcolor="#f1cccb">\(self.timeOutTimeLabel.text!)</td>
                <td> </td>
            </tr>
        </table>
        """
//        }
        let fmt = UIMarkupTextPrintFormatter(markupText: html)
        
        // 2. Assign print formatter to UIPrintPageRenderer
        
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)
        
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
        pdfData.write(toFile: "\(documentsPath)/file.pdf", atomically: true)
        print("\(documentsPath)/file.pdf")
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
        logoImageView.topAnchor.constraint(equalTo: mainContainerView.topAnchor, constant: 50).isActive = true

        mainContainerView.addSubview(collectionContainerView)
        collectionContainerView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 60).isActive = true
        collectionContainerView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        collectionContainerView.widthAnchor.constraint(equalToConstant: 320).isActive = true
        collectionContainerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
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
        minLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        minLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectionContainerView.addSubview(timeOutLabel)
        timeOutLabel.topAnchor.constraint(equalTo: totalPickUpLabel.bottomAnchor).isActive = true
        timeOutLabel.leftAnchor.constraint(equalTo: collectionContainerView.leftAnchor).isActive = true
        timeOutLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        timeOutLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectionContainerView.addSubview(timeOutTimeLabel)
        timeOutTimeLabel.topAnchor.constraint(equalTo: totalPickUpLabel.bottomAnchor).isActive = true
        timeOutTimeLabel.leftAnchor.constraint(equalTo: timeOutLabel.rightAnchor).isActive = true
        timeOutTimeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeOutTimeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        mainContainerView.addSubview(buttonsContainerView)
        buttonsContainerView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        buttonsContainerView.topAnchor.constraint(equalTo: collectionContainerView.bottomAnchor, constant: 10).isActive = true
        buttonsContainerView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -200).isActive = true
        buttonsContainerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        buttonsContainerView.addSubview(messageButton)
        messageButton.leftAnchor.constraint(equalTo: buttonsContainerView.leftAnchor, constant: 10).isActive = true
        messageButton.topAnchor.constraint(equalTo: buttonsContainerView.topAnchor, constant: 10).isActive = true
        messageButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        messageButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        buttonsContainerView.addSubview(emailButton)
        emailButton.rightAnchor.constraint(equalTo: buttonsContainerView.rightAnchor, constant: -10).isActive = true
        emailButton.topAnchor.constraint(equalTo: buttonsContainerView.topAnchor, constant: 15).isActive = true
        emailButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        emailButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        buttonsContainerView.addSubview(messageLabel)
        messageLabel.bottomAnchor.constraint(equalTo: buttonsContainerView.bottomAnchor, constant: -10).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: messageButton.centerXAnchor).isActive = true
        
        buttonsContainerView.addSubview(mailLabel)
        mailLabel.bottomAnchor.constraint(equalTo: buttonsContainerView.bottomAnchor, constant: -10).isActive = true
        mailLabel.centerXAnchor.constraint(equalTo: emailButton.centerXAnchor).isActive = true
        
        mainContainerView.addSubview(exitButton)
        exitButton.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        exitButton.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -150).isActive = true
        exitButton.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -20).isActive = true
        
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

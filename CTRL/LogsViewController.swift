//
//  LogsViewController.swift
//  CTRL
//
//  Created by Ali Apple on 17/02/2019.
//  Copyright © 2019 Ali Apple. All rights reserved.
//

import UIKit

class LogsViewController: UIViewController {

    let contactTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isSelectable = true
        textView.isEditable = false
        return textView
    }()
    
    
    @objc func backButton(){
        let viewController = ReceiptViewController()
        let aObjNavi = UINavigationController(rootViewController: viewController)
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        appDelegate.window?.rootViewController = aObjNavi
    }
    
    var topBarHeight: CGFloat = 0
    let timeInstance = TimeInfo.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        let backBarButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(backButton))
        backBarButton.tintColor = .gray
        self.navigationItem.leftBarButtonItem = backBarButton
        contactTextView.text = timeInstance.logs
        view.addSubview(contactTextView)
        contactTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: topBarHeight+10).isActive = true
        contactTextView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contactTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        contactTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // Do any additional setup after loading the view.
    }

}

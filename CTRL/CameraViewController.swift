//
//  CameraViewController.swift
//  CTRL
//
//  Created by Ali Apple on 23/01/2019.
//  Copyright © 2019 Ali Apple. All rights reserved.
//

import UIKit
import AVFoundation
import WebKit

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIDocumentInteractionControllerDelegate, WKNavigationDelegate{

    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
    let timeInstance = TimeInfo.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeInstance.isTutorialScreenLoadable = false
        let backBarButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(backButton))
        backBarButton.tintColor = .gray
        self.navigationItem.leftBarButtonItem = backBarButton
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch{
            print("Camera not available")
        }
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        session.startRunning()
    }
    
    @objc func backButton(){
        deletePdf()
        let viewController = ViewController()
        let aObjNavi = UINavigationController(rootViewController: viewController)
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        appDelegate.window?.rootViewController = aObjNavi
    }
    
    func deletePdf(){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let myurl = NSURL(fileURLWithPath: path)
        if let pathComponent = myurl.appendingPathComponent("\(self.yourName)_\(self.sessionName)_Kapper.pdf") {
            let filePath = pathComponent.path
            print(pathComponent.path)
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
        }
        else {
            print("FILE PATH NOT AVAILABLE")
        }
    }
    
    let qrImageView: UIImageView = {
        var bi = UIImageView(frame: CGRect(x: 0, y: 0, width: 170, height: 170))
        let screenSize: CGRect = UIScreen.main.bounds
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.image = UIImage(named: "qr.png")
        return bi
    }()
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if object.type == AVMetadataObject.ObjectType.qr{
                    print(object.stringValue!)
                    let myCount = object.stringValue!.filter{$0 == "|"}.count
                    if myCount < 9{
//                        self.session.stopRunning()
                        ToastView.shared.short(self.view, txt_msg: "Invalid QR!")
                        return
                    }
                    self.session.stopRunning()
                    self.dataFromQr = object.stringValue!
                    self.dataFromQrArray = dataFromQr.components(separatedBy: "|")
                    self.clockOutTime = dataFromQrArray.remove(at: dataFromQrArray.count-1)
                    self.workMinLabel = dataFromQrArray.remove(at: dataFromQrArray.count-1)
                    self.workDuration = dataFromQrArray.remove(at: dataFromQrArray.count-1)
                    self.phoneActivityMinLabel = dataFromQrArray.remove(at: dataFromQrArray.count-1)
                    self.phoneActivityDuration = dataFromQrArray.remove(at: dataFromQrArray.count-1)
                    self.clockInTime = dataFromQrArray.remove(at: dataFromQrArray.count-1)
                    self.presetShiftDuration = dataFromQrArray.remove(at: dataFromQrArray.count-1)
                    self.currentDate = dataFromQrArray.remove(at: dataFromQrArray.count-1)
                    self.sessionName = dataFromQrArray.remove(at: dataFromQrArray.count-1)
                    self.yourName = dataFromQrArray.remove(at: dataFromQrArray.count-1)
                    var i = 0
                    for j in stride(from: 0, to: self.dataFromQrArray.count, by: 3) {
                        self.pdfDataAdder += "<tr bgcolor='#ffffff'><td>\(self.dataFromQrArray[i])</td><td>\(self.dataFromQrArray[i+1])</td><td>\(self.dataFromQrArray[i+2])</td></tr>"
//                        dataToQr += "|\(dataFromQrArray[i])|\(dataFromQrArray[i+1])|\(dataFromQrArray[i+2])"
                        i += 3
                    }
                    print(dataFromQrArray)
                    self.createPdf(arg: true, completion: {(success) -> Void in
                        if success{
                            let webView = WKWebView(frame: self.view.frame)
                            self.view.addSubview(webView)
                            webView.navigationDelegate = self
                            webView.loadHTMLString(self.html, baseURL: nil)
                            webView.isUserInteractionEnabled = false
                        }
                    })
                }
            }
        }
    }
    var clockOutTime = ""
    var workMinLabel = ""
    var workDuration = ""
    var phoneActivityMinLabel = ""
    var phoneActivityDuration = ""
    var clockInTime = ""
    var presetShiftDuration = ""
    var currentDate = ""
    var sessionName = ""
    var yourName = ""
    var dataFromQrArray = [String]()
    var dataFromQr = ""
    var html = """
                """
    var pdfDataAdder = ""
    
    func generateQrCode(arg: Bool, completion: (Bool) -> ()){
        let data = self.dataFromQr.data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        let img = UIImage(ciImage: (filter?.outputImage)!)
        self.qrImageView.image = img
        completion(true)
    }
    
    func createPdf(arg: Bool, completion: (Bool) -> ()){
        html = "<div style='display: flex; justify-content: center;'><table width='50%' cellspacing='1' cellpadding='0' border='0' bgcolor='#999999' align='center'><tr bgcolor='#ffffff'><td>\(self.yourName)</td><td>\(self.sessionName)</td><td> </td></tr><tr bgcolor='#ffffff'><td align='center'>\(self.currentDate)</td><td bgcolor='#d9d9d9' align='right'>PRESET SHIFT:</td><td bgcolor='#d9d9d9' align='right'>\(self.presetShiftDuration)</td></tr><tr bgcolor='#ffffff'><td bgcolor='#fff2cc' align='right'>CLOCKED IN:</td><td bgcolor='#fff2cc' align='right'>\(self.clockInTime)</td><td> </td></tr>\(self.pdfDataAdder)<tr bgcolor='#ffffff'><td bgcolor='#f4cccc' align='right'>Phone Activity:</td><td bgcolor='#f4cccc' align='right'>\(self.phoneActivityDuration)</td><td bgcolor='#f4cccc'>\(self.phoneActivityMinLabel)</td></tr><tr bgcolor='#ffffff'><td bgcolor='#d9ead3' align='right'>KAPPER TIME:</td><td bgcolor='#d9ead3' align='right'>\(self.workDuration)</td><td bgcolor='#d9ead3'>\(self.workMinLabel)</td></tr><tr bgcolor='#ffffff'><td bgcolor='#fff2cc' align='right'>CLOCKED OUT:</td><td bgcolor='#fff2cc' align='right'>\(self.clockOutTime)</td><td> </td></tr></table></div>"
        
        generateQrCode(arg: true, completion: { (success) -> Void in
            print("QR Code Generated")
            self.view.addSubview(self.qrImageView)
            let image1 = captureView()
            self.qrImageView.removeFromSuperview()
            let imageData1 = image1.pngData() ?? nil
            let base64String1 = imageData1?.base64EncodedString() ?? ""
            
            var image2 = UIImage(named:"empty")
            if self.html.contains("Pickup 1") {
                print("pickup 1 Found")
            }
            else{
                let image = UIImage(named:"zeroActivity")
                image2 = image
                print("pickup Not found")
            }
            
            let imageData2 = image2!.pngData() ?? nil
            let base64String2 = imageData2?.base64EncodedString() ?? ""
            
            let image3 = UIImage(named:"kapped")
            let imageData3 = image3!.pngData() ?? nil
            let base64String3 = imageData3?.base64EncodedString() ?? ""
            
            if success { // this will be equal to whatever value is set in this method call
                self.html += "<html><body><div style='text-align: center'><p><br></p><p><b><img width='50%' height='20%' src='data:image/png;base64,\(String(describing: base64String1))'/><p><br></p><p><b><img width='50%' height='5%' src='data:image/png;base64,\(String(describing: base64String2))'/><p><br></p><p><b><img width='30%' height='5%' src='data:image/png;base64,\(String(describing: base64String3))'/></b></p></div></body></html>"
                completion(true)
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
        print("Captured screenshot")
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
        pdfData.write(toFile: "\(documentsPath)/\(self.yourName)_\(self.sessionName)_Kapper.pdf", atomically: true)
        print("\(documentsPath)/Kapper.pdf")
        webView.removeFromSuperview()
        let dc = UIDocumentInteractionController(url: URL(fileURLWithPath: "\(documentsPath)/\(self.yourName)_\(self.sessionName)_Kapper.pdf"))
        dc.delegate = self
        dc.presentPreview(animated: true)
        print("PDF displayed")
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self//or use return self.navigationController for fetching app navigation bar colour
    }

}

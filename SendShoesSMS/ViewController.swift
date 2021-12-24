//
//  ViewController.swift
//  SendShoesSMS
//
//  Created by Soul on 2021/12/16.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate, UITextFieldDelegate,
                      ChooseSizeControllerDelegate, ChooseUserControllerDelegate {
    
    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "🧨 好运来 🧨"
        // Delegate
        self.shoesModelTypeTextField.delegate = self
        self.shoesSizeTextField.delegate = self
        self.userInfoTextField.delegate = self
        
        // Welcome
        self.showLog("👏 欢迎使用短信模版编辑 \n1.请先构造短信内容 \n2.请选择收信人列表 \n3.点击Send Message")
    }
    
    @IBOutlet weak var shoesModelTypeTextField: UITextField!
    @IBOutlet weak var shoesSizeTextField: UITextField!
    @IBOutlet weak var userInfoTextField: UITextField!

    // MARK: - Action Method
    
    var messageBody: String?
    /// 组装短信内容
    @IBAction func buildMessageBodyAction(_ sender: Any) {
        messageBody = ""
        
        if let shoeModel = shoesModelTypeTextField.text {
            messageBody?.append("\(shoeModel)+")
        } else {
            showLog("🙅‍♂️ 鞋子型号填写为空")
            return
        }
        
        if let userInfo = userInfoTextField.text {
            messageBody?.append(userInfo)
        } else {
            showLog("🙅‍♂️ 抽签人信息填写为空")
            return
        }
     
        if let shoesSize = shoesSizeTextField.text {
            messageBody?.append("+\(shoesSize)")
        } else {
            showLog("🙅‍♂️ 鞋码信息填写为空")
            return
        }
        
        showLog("👏 生成短信模版如下\n\(String(describing: messageBody))\n")
    }
    
    /// 唤起发送短信界面
    @IBAction func sendMessageAction(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
            let vc = MFMessageComposeViewController()
            vc.recipients = ["10086"] // 支持多个手机号
            vc.body = "今天晚上有空么,一起肯德基疯狂星期四" // 支持文字直接进入文本框
            vc.messageComposeDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Texefield Delegate Method
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
            
        case self.shoesSizeTextField:
            let sizeVc = ChooseSizeController()
            sizeVc.delegate = self
            self.navigationController?.show(sizeVc, sender: nil)
            return false
            
        case self.userInfoTextField:
            let userVc = ChooseUserController()
            userVc.delegate = self
            self.navigationController?.show(userVc, sender: nil)
            return false
            
        default:
            return true
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let textStr = (textField.text ?? "") as String
        switch textField {
        case self.shoesModelTypeTextField:
            if textStr.isEmpty == true {
                showLog("🙅 鞋码填写不能为空")
            } else {
                showLog("☑️ 已填写鞋号:\(textStr)")
            }
        default :
            break
        }
    }
    
    // MARK: - Choose Controller Callback Delegate
    func didSelectedSize(_ vc: UIViewController, size: String) {
        showLog("☑️ 已选中尺码 \(size)")
        self.shoesSizeTextField.text = size
    }
    
    func didSelectedUser(_ vc: UIViewController, userInfo: String) {
        showLog("☑️ 已选中用户 \(userInfo)")
        self.userInfoTextField.text = userInfo
    }
    
    // MARK: - Message Delegate Method
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        
        var res = "未知"
        switch result {
        case .cancelled:
            res = "用户取消 😳😳"
        case .sent:
            res = "已发送 🥳🥳"
        case .failed:
            res = "失败 🤯🤯"
        @unknown default:
            res = "异常错误 😭😭"
        }
        
        controller.dismiss(animated: true) {
            self.showLog("【发送状态】 \(res) ")
        }
    }
    
    
    // MARK: - Private Method
    
    @IBOutlet weak var logTextView: UITextView!
    /// 输出到日志台
    func showLog(_ message: String) {
        debugPrint(message)
        
        DispatchQueue.main.async {
            var currentText = self.logTextView.text
            
            currentText?.append("\n")
            currentText?.append(message)
            currentText?.append("\n")
            
            self.logTextView.text = currentText
            
            let nsrange = NSRange.init(location: currentText?.count ?? 1, length: 1)
            self.logTextView.scrollRangeToVisible(nsrange)
        }
        
    }
    
    
}


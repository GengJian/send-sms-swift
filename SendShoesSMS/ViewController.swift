//
//  ViewController.swift
//  SendShoesSMS
//
//  Created by Soul on 2021/12/16.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - Action Method
    /// 组装短信内容
    @IBAction func buildMessageBodyAction(_ sender: Any) {
        
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
    
    // MARK: - Delegate Method
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
            let range = currentText?.range(of: message)
         
            self.logTextView.scrollRangeToVisible(NSRange.)
        }
        
    }
    
    
}


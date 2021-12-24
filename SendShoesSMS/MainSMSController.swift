//
//  MainSMSController.swift
//  SendShoesSMS
//
//  Created by Soul on 2021/12/16.
//

import UIKit
import MessageUI

let CACHE_USER_INFO = "cacheUserInfoName"

class MainSMSController: UIViewController, MFMessageComposeViewControllerDelegate,
                         UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,
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
        // DataSource
        self.sellerListView.dataSource = self
        self.sellerListView.delegate = self
        self.sellerListView.register(UITableViewCell.self, forCellReuseIdentifier: "sellerCell")
        
        // Welcome
        self.showLog("👏 欢迎使用短信模版编辑 \n1.请先构造短信内容 \n2.请选择收信人列表 \n3.点击Send Message")
        
        // AutoFill
        self.userInfoTextField.text = UserDefaults.standard.string(forKey: CACHE_USER_INFO)
        
    }
    
    @IBOutlet weak var shoesModelTypeTextField: UITextField!
    @IBOutlet weak var shoesSizeTextField: UITextField!
    @IBOutlet weak var userInfoTextField: UITextField!

    // MARK: - Action Method
    
    var messageBody: String?
    /// 组装短信内容
    @IBAction func buildMessageBodyAction(_ sender: Any) {
        messageBody = ""
        
        if let shoeModel = shoesModelTypeTextField.text, shoeModel.count > 4 {
            messageBody?.append("\(shoeModel)+")
        } else {
            showLog("🙅‍♂️ 鞋子型号填写为空")
            return
        }
        
        if let userInfo = userInfoTextField.text, userInfo.count > 4 {
            messageBody?.append(userInfo)
            UserDefaults.standard.set(userInfo, forKey: CACHE_USER_INFO)
        } else {
            showLog("🙅‍♂️ 抽签人信息填写为空")
            return
        }
     
        if let shoesSize = shoesSizeTextField.text, shoesSize.count >= 2 {
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
            
            for dict in self.sellerDataSource {
                let phone = dict["phone"] as! String
                let isTick = dict["isTick"] as! Bool
                
                if isTick {
                    let vc = MFMessageComposeViewController()
                    vc.recipients = [phone] // 支持多个手机号
                    vc.body = self.messageBody // 支持文字直接进入文本框
                    vc.messageComposeDelegate = self
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    // MARK: - TextField Delegate Method
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
    
    // MARK: - UITableView DataSource / Delegate Method
    @IBOutlet weak var sellerListView: UITableView!
    var sellerDataSource = [
        ["phone":"159 0186 6357", "isTick":true],
        ["phone":"158 0067 0976", "isTick":true],
        ["phone":"166 2315 3174", "isTick":true],
        ["phone":"187 0176 0158", "isTick":false],
        ["phone":"158 0067 0976", "isTick":false],
        ["phone":"158 0172 3235", "isTick":false],
        ["phone":"138 1728 8147", "isTick":false],
    ]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.sellerDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sellerCell", for: indexPath)
        cell.selectionStyle = .none
        
        let sellerDict = sellerDataSource[indexPath.row]
        cell.textLabel?.text = sellerDict["phone"] as? String
        let isTickoff = sellerDict["isTick"] as! Bool
        cell.accessoryType = isTickoff ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    /// 选择和取消选中收件人手机号
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isTickoff = sellerDataSource[indexPath.row]["isTick"] as! Bool
        sellerDataSource[indexPath.row]["isTick"] = !isTickoff
        
        tableView.reloadData()
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
            
            let nsrange = NSRange.init(location: currentText?.count ?? 1 - 10, length: 10)
            self.logTextView.scrollRangeToVisible(nsrange)
        }
        
    }
    
    
}


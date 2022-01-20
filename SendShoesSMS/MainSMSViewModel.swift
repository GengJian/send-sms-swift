//
//  MainSMSViewModel.swift
//  SendShoesSMS
//
//  Created by GengJian on 2022/1/20.
//

import UIKit

class MainSMSViewModel: NSObject {
    
    //MARK: - Property
    // 预置所有的收件人列表
    let allSellerList = [
        "159 0186 6357",
        "158 0067 0976",
        "166 2315 3174",
        "187 0176 0158",
        "158 0067 0976",
        "158 0172 3235",
        "138 1728 8147"
    ]
    
    // 缓存待发送的收件人列表
    var receiverList = [
        "159 0186 6357",
        "158 0067 0976",
        "166 2315 3174"
    ]
    
    //MARK: - Public Method
    /// 判断当前手机号是否被勾选（待发送）
    func shouldBeTickOff(phone: String) -> Bool {
        return receiverList.contains(phone)
        
    }
    
    /// 添加待发送手机号
    func addReciver(phone: String) -> Bool {
        if (shouldBeTickOff(phone: phone) == false) {
            receiverList.append(phone)
            return true
        }
        return false
    }
    
    
    /// 移除待发送手机号
    func deleteReciver(phone: String) -> Bool {
        if (receiverList.isEmpty) {
            return true
        }
        
        if (shouldBeTickOff(phone: phone) == true) {
            receiverList.remove(at: receiverList.firstIndex(of: phone)!)
            return true
        }
        return false
    }
    
}

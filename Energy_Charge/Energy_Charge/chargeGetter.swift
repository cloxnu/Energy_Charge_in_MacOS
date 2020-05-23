//
//  chargeGetter.swift
//  Energy_Charge
//
//  Created by Land on 2019/12/8.
//  Copyright © 2019 Land. All rights reserved.
//

import Cocoa
import Alamofire

protocol chargeDelegate {
    func chargeChanged(amount: Double)
    func chargeGetError(errorDisc: String)
    func notificate(disc: String)
}


class chargeGetter
{
    var delegate: chargeDelegate?
    
    var is_enable_notification = true
    var low_energy_threshold = Settings.shared.low_energy_threshold
    var has_notificate_low_energy = false
    
    var room = Settings.shared.room
    
    init() {
        self.getCharge()
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true, block: { (timer) in
            self.getCharge()
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(settingsChanged), name: .SettingsChanged, object: nil)
    }
    
    func getCharge()
    {
        let dic: [[String: String]] = [["schoolCode": "10356", "areaId": "1902201604208035", "buildingCode": "9cf8b921", "floorCode": "1004", "roomCode": "0422"],
                                       ["schoolCode": "10356", "areaId": "1902201604208035", "buildingCode": "9a7f9a5a", "floorCode": "1003", "roomCode": "0328"]]
        
        
        let param = { () -> [String : String] in
            if self.room >= 0 && self.room < dic.count
            {
                return dic[self.room]
            }
            return dic[0]
        }()
        
        Alamofire.request("https://application.xiaofubao.com/app/electric/queryRoomSurplus.htm", method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.error == nil){
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments)
                    if let dict = json as? NSDictionary
                    {
                        if let data = dict["data"] as? NSDictionary
                        {
                            if let charge = data["amount"] as? Double
                            {
                                self.delegate?.chargeChanged(amount: charge)
                                print(charge)
                                self.chargeProcess(charge: charge)
                                return
                            }
                            
                        }
                    }
                    self.delegate?.chargeGetError(errorDisc: "json 获取错误")
                }
                catch{
                    print("error")
                    self.delegate?.chargeGetError(errorDisc: "json 解析错误")
                }
            }else{
                print("Alamofire请求失败：\(response.error ?? "" as! Error)")
                self.delegate?.chargeGetError(errorDisc: "网络请求失败")
            }
        }
    }
    
    func chargeProcess(charge: Double)
    {
        if self.is_enable_notification
        {
            if charge <= self.low_energy_threshold
            {
                if !self.has_notificate_low_energy
                {
                    self.has_notificate_low_energy = true
                    self.delegate?.notificate(disc: "您的电费低于 ¥\(self.low_energy_threshold)，请尽快充值。")
                }
            }
            else
            {
                self.has_notificate_low_energy = false
            }
        }
    }
    
    func enableNotification(isEnable: Bool)
    {
        self.is_enable_notification = isEnable
        self.has_notificate_low_energy = false
        self.getCharge()
    }
    
    @objc func settingsChanged() {
        self.low_energy_threshold = Settings.shared.low_energy_threshold
        self.room = Settings.shared.room
        self.getCharge()
    }
}

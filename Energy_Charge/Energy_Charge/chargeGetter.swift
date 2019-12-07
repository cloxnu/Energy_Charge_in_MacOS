//
//  chargeGetter.swift
//  Energy_Charge
//
//  Created by Land on 2019/12/8.
//  Copyright © 2019 Land. All rights reserved.
//

import Cocoa
import Alamofire

protocol charge {
    func chargeChanged(amount: String)
    func chargeGetError(errorDisc: String)
}


class chargeGetter {
    var delegate: charge?
    
    init() {
        self.getCharge()
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true, block: { (timer) in
            self.getCharge()
        })
    }
    
    func getCharge()
    {
        let dic: [[String: String]] = [["schoolCode": "10356", "areaId": "1902201604208035", "buildingCode": "9a7f9a5a", "floorCode": "1003", "roomCode": "0328"],
                                       ["schoolCode": "10356", "areaId": "1902201604208035", "buildingCode": "9cf8b921", "floorCode": "1004", "roomCode": "0422"]]
        Alamofire.request("https://application.xiaofubao.com/app/electric/queryRoomSurplus.htm", method: .post, parameters: dic[1], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.error == nil){
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments)
                    if let dict = json as? NSDictionary
                    {
                        if let data = dict["data"] as? NSDictionary
                        {
                            if let charge = data["amount"] as? Double
                            {
                                self.delegate?.chargeChanged(amount: String(charge))
                                print(charge)
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
}

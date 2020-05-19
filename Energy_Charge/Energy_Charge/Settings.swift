//
//  Settings.swift
//  Energy_Charge
//
//  Created by Land on 2020/5/18.
//  Copyright © 2020 Land. All rights reserved.
//

import Foundation


let settings = Settings()


extension Notification.Name
{
    static let SettingsChanged = Notification.Name(rawValue:"SettingsChanged")
}

class Settings
{
    class var shared: Settings
    {
        return settings
    }
    
    var low_energy_threshold = 5.0
    var room = 0
    
    init() {
        let userDefault = UserDefaults.standard
        self.low_energy_threshold = userDefault.double(forKey: "low_energy_threshold")
        self.room = userDefault.integer(forKey: "room")
    }
    
    func save()
    {
        let userDefault = UserDefaults.standard
        userDefault.set(self.low_energy_threshold, forKey: "low_energy_threshold")
        userDefault.set(self.room, forKey: "room")
        
        NotificationCenter.default.post(name: .SettingsChanged, object: nil)
    }
}


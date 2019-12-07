//
//  StatusMenu.swift
//  Energy_Charge
//
//  Created by Land on 2019/12/8.
//  Copyright © 2019 Land. All rights reserved.
//

import Cocoa

class StatusMenu: NSObject {

    @IBOutlet weak var MainMenu: NSMenu!
    @IBOutlet weak var UpdateAt: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var chargeManager: chargeGetter?
    
    @IBAction func UpdateCharge(_ sender: NSMenuItem) {
        self.chargeManager?.getCharge()
    }
    
    override func awakeFromNib() {
        self.chargeManager = chargeGetter()
        self.chargeManager!.delegate = self
        statusItem.menu = MainMenu
        statusItem.button?.title = "电费：¥"
    }
}

extension StatusMenu: charge
{
    func chargeGetError(errorDisc: String) {
        self.UpdateAt.title = errorDisc
    }
    
    func chargeChanged(amount: String) {
        statusItem.button?.title = "电费：¥" + amount
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        self.UpdateAt.title = "更新于：" + dateFormatter.string(from: Date())
    }
}

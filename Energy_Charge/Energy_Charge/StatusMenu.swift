//
//  StatusMenu.swift
//  Energy_Charge
//
//  Created by Land on 2019/12/8.
//  Copyright © 2019 Land. All rights reserved.
//

import Cocoa
import UserNotifications

class StatusMenu: NSObject {

    @IBOutlet weak var MainMenu: NSMenu!
    @IBOutlet weak var UpdateAt: NSMenuItem!
    @IBOutlet weak var Notification: NSMenuItem!
    
    @IBOutlet weak var Room8E422: NSMenuItem!
    @IBOutlet weak var Room10S328: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var chargeManager: chargeGetter?
    
    @IBAction func UpdateCharge(_ sender: NSMenuItem) {
        self.chargeManager?.getCharge()
    }
    
    @IBAction func ChangeNotification(_ sender: NSMenuItem) {
        self.Notification.state = self.Notification.state == .on ? .off : .on
        self.chargeManager?.enableNotification(isEnable: self.Notification.state == .on)
    }
    
    override func awakeFromNib() {
        self.chargeManager = chargeGetter()
        self.chargeManager!.delegate = self
        statusItem.menu = self.MainMenu
        statusItem.button?.title = "电费：¥"
        self.SelectRoom(tag: Settings.shared.room)
    }
    
    @IBAction func ChangeRoom(_ sender: NSMenuItem) {
        self.UnselectAllRoom()
        sender.state = .on
        Settings.shared.room = sender.tag - 10
        Settings.shared.save()
    }
    
    func SelectRoom(tag: Int)
    {
        self.UnselectAllRoom()
        guard let item = self.MainMenu.item(withTag: Settings.shared.room + 10) else {
            return
        }
        item.state = .on
    }
    
    func UnselectAllRoom()
    {
        self.Room8E422.state = .off
        self.Room10S328.state = .off
    }
    
}

extension StatusMenu: chargeDelegate
{
    func chargeGetError(errorDisc: String) {
        self.UpdateAt.title = errorDisc
        self.statusItem.button?.contentTintColor = .gray
    }
    
    func chargeChanged(amount: Double) {
        if amount < Settings.shared.low_energy_threshold {
            self.statusItem.button?.contentTintColor = .red
        } else {
            self.statusItem.button?.contentTintColor = .none
        }
        statusItem.button?.title = "电费：¥" + String(amount)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        self.UpdateAt.title = "更新于：" + dateFormatter.string(from: Date())
    }
    
    func notificate(disc: String) {
        let alert = NSAlert()
        alert.messageText = disc
        alert.alertStyle = .critical
        alert.addButton(withTitle: "马上充")
        alert.runModal()
    }
}

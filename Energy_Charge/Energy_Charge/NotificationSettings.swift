//
//  ViewController.swift
//  Energy_Charge
//
//  Created by Land on 2019/12/7.
//  Copyright © 2019 Land. All rights reserved.
//

import Cocoa


class NotificationSettings: NSViewController {
    
    @IBOutlet weak var low_energy_threshold: NSTextField!
    @IBOutlet weak var low_energy_setting_level_indicator: NSLevelIndicator!
    
    var low_energy_threshold_value = 5.0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.low_energy_threshold_value = Settings.shared.low_energy_threshold
        self.low_energy_threshold.stringValue = "¥\(self.low_energy_threshold_value)"
        self.low_energy_setting_level_indicator.doubleValue = self.low_energy_threshold_value
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func Done(_ sender: NSButton) {
        Settings.shared.low_energy_threshold = self.low_energy_threshold_value
        Settings.shared.save()
        self.view.window?.close()
    }
    
    @IBAction func Cancel(_ sender: NSButton) {
        self.view.window?.close()
    }
    
    
    @IBAction func low_energy_threshold_changed(_ sender: NSLevelIndicator) {
        self.low_energy_threshold_value = sender.doubleValue
        self.low_energy_threshold.stringValue = "¥" + String(sender.doubleValue)
    }
    
}


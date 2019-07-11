//
//  ServerProfileManager.swift
//  ShadowsocksX-NG
//
//  Created by 邱宇舟 on 16/6/6. Modified by 秦宇航 16/9/12
//  Copyright © 2016年 qiuyuzhou. All rights reserved.
//

import Cocoa

class ServerProfileManager: NSObject {
    
    static let instance:ServerProfileManager = ServerProfileManager()
    
    var profiles:[ServerProfile]
    var activeProfileId: String?
    
    fileprivate override init() {
        profiles = [ServerProfile]()
        
        let defaults = UserDefaults.standard
        if let _profiles = defaults.array(forKey: "ServerProfiles") {
            for _profile in _profiles {
                let profile = ServerProfile.fromDictionary(_profile as! [String: Any])
                profiles.append(profile)
            }
        }
        activeProfileId = defaults.string(forKey: "ActiveServerProfileId")
    }
    
    func setActiveProfiledId(_ id: String) {
        activeProfileId = id
        let defaults = UserDefaults.standard
        defaults.set(id, forKey: "ActiveServerProfileId")
    }
    
    func save() {
        let defaults = UserDefaults.standard
        var _profiles = [AnyObject]()
        for profile in profiles {
            if profile.isValid() {
                let _profile = profile.toDictionary()
                _profiles.append(_profile as AnyObject)
            }
        }
        defaults.set(_profiles, forKey: "ServerProfiles")
        
        if getActiveProfile() == nil {
            activeProfileId = nil
        }
    }
    
    func getActiveProfile() -> ServerProfile? {
        if let id = activeProfileId {
            for p in profiles {
                if p.uuid == id {
                    return p
                }
            }
            return nil
        } else {
            return nil
        }
    }
}

extension ServerProfileManager {
    
    
    
    func importConfigFile() {
        let openPanel = NSOpenPanel()
        openPanel.title = "Choose Config Json File".localized
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.becomeKey()
        let result = openPanel.runModal()
        if (result.rawValue == NSFileHandlingPanelOKButton && (openPanel.url) != nil) {
            let fileManager = FileManager.default
            let filePath:String = (openPanel.url?.path)!
            if (fileManager.fileExists(atPath: filePath) && filePath.hasSuffix("json")) {
                let data = fileManager.contents(atPath: filePath)
                let readString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                let readStringData = readString.data(using: String.Encoding.utf8.rawValue)
                
                let jsonArr1 = try! JSONSerialization.jsonObject(with: readStringData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                for item in jsonArr1.object(forKey: "configs") as! [[String: AnyObject]]{
                    let profile = ServerProfile()
                    profile.serverHost = item["server"] as! String
                    profile.serverPort = UInt16((item["server_port"]?.integerValue)!)
                    profile.method = item["method"] as! String
                    profile.password = item["password"] as! String
                    profile.remark = item["remarks"] as! String
                    
                    // Kcptun
                    profile.pluginEnable = item["enabled_kcptun"]?.boolValue ?? (item["plugin_enable"]?.boolValue ?? false)
                    profile.pluginOptions = item["plugin_options"] as? String ?? ""
                    if let kcptun = item["kcptun"] as? [String : Any?] {
                        profile.plugin = "kcptun"
                        profile.pluginOptions = kcptun.reduce(into: [String]()) { (result, dict) in
                            result.append("\(dict.key)=\(dict.value!)")
                            }.joined(separator: ";")
                    }
                    
                    self.profiles.append(profile)
                    self.save()
                }
                NotificationCenter.default.post(name: NOTIFY_SERVER_PROFILES_CHANGED, object: nil)
                let configsCount = (jsonArr1.object(forKey: "configs") as! [[String: AnyObject]]).count
                let notification = NSUserNotification()
                notification.title = "Import Server Profile succeed!".localized
                notification.informativeText = "Successful import \(configsCount) items".localized
                NSUserNotificationCenter.default
                    .deliver(notification)
            }else{
                let notification = NSUserNotification()
                notification.title = "Import Server Profile failed!".localized
                notification.informativeText = "Invalid config file!".localized
                NSUserNotificationCenter.default
                    .deliver(notification)
                return
            }
        }
    }
    
    func exportConfigFile() {
        //读取example文件，删掉configs里面的配置，再用NSDictionary填充到configs里面
        let fileManager = FileManager.default
        
        let filePath:String = Bundle.main.path(forResource: "example-gui-config", ofType: "json")!
        let data = fileManager.contents(atPath: filePath)
        let readString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
        let readStringData = readString.data(using: String.Encoding.utf8.rawValue)
        let jsonArr1 = try! JSONSerialization.jsonObject(with: readStringData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        
        let configsArray:NSMutableArray = [] //not using var?
        
        for profile in profiles{
            let configProfile:NSMutableDictionary = [:] //not using var?
            //standard ss profile
            configProfile.setValue(true, forKey: "enable")
            configProfile.setValue(profile.serverHost, forKey: "server")
            configProfile.setValue(NSNumber(value:profile.serverPort), forKey: "server_port")//not work
            configProfile.setValue(profile.password, forKey: "password")
            configProfile.setValue(profile.method, forKey: "method")
            configProfile.setValue(profile.remark, forKey: "remarks")
            configProfile.setValue(profile.remark.data(using: String.Encoding.utf8)?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)), forKey: "remarks_base64")
            
            // Kcptun
            configProfile.setValue(profile.pluginEnable, forKey: "plugin_enabled")
            configProfile.setValue(profile.pluginOptions, forKey: "plugin_options")
            if profile.plugin == "kcptun" {
                configProfile.setValue(profile.pluginEnable, forKey: "enabled_kcptun")
                configProfile.setValue(profile.pluginOptions, forKey: "kcptun_options")
                let dict = profile.pluginOptions.components(separatedBy: ";").reduce(into: [String : Any?]()) { (result, str) in
                    let arr = str.components(separatedBy: "=")
                    result[arr[0]] = arr[1]
                }
                configProfile.setValue(dict, forKey: "kcptun")
            }
            
            configsArray.add(configProfile)
        }
        jsonArr1.setValue(configsArray, forKey: "configs")
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonArr1, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        let savePanel = NSSavePanel()
        savePanel.title = "Export Config Json File".localized
        savePanel.canCreateDirectories = true
        savePanel.allowedFileTypes = ["json"]
        savePanel.nameFieldStringValue = "export.json"
        savePanel.becomeKey()
        let result = savePanel.runModal()
        if (result.rawValue == NSFileHandlingPanelOKButton && (savePanel.url) != nil) {
            //write jsonArr1 back to file
            try! jsonString.write(toFile: (savePanel.url?.path)!, atomically: true, encoding: String.Encoding.utf8)
            NSWorkspace.shared.selectFile((savePanel.url?.path)!, inFileViewerRootedAtPath: (savePanel.directoryURL?.path)!)
            let notification = NSUserNotification()
            notification.title = "Export Server Profile succeed!".localized
            notification.informativeText = "Successful Export \(self.profiles.count) items".localized
            NSUserNotificationCenter.default
                .deliver(notification)
        }
    }
}

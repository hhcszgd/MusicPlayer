
//
//  AppDelegate+extension.swift
//  Project
//
//  Created by WY on 2018/1/17.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import UserNotifications



/// test somethinbg

extension AppDelegate {
    func test1()   {

        
   
        
    }
    
   
    
}




// MARK: 注释 : registerNotifacation



extension AppDelegate {
    
  
    
    /// did register apple remote id
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let device_ns = NSData.init(data: deviceToken)
        let token:String = device_ns.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>" ))//需要传给服务器
//        GDNetworkManager.shareManager.saveDeviceTokenAndRegisterID(deviceToken: token , registerID: nil , { (respodsData) in
//            mylog("deviceToken\(respodsData.msg)")
//        }, failure: { (error ) in
//            mylog("deviceToken保存失败\(error)")
//        })
        //send deviceToken to jpush
        
        mylog(token)
        
    }
    /// fail register apple remote id
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        mylog("注册远程推送失败\(error)")
    }

    //MARK://///////通用链接代理//////////////
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool{
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let webPageUrl = userActivity.webpageURL
            let host = webPageUrl?.host
            if let hostStr = host  {
                if hostStr == "zjlao.com" || hostStr == "www.zjlao.com" || hostStr == "m.zjlao.com" || hostStr == "items.zjlao.com" {
                    
                    /*
                     //进行我们需要的处理
                     NSLog(@"_%d_%@",__LINE__,@"通用链接测试成功");
                     NSLog(@"_%d_%@",__LINE__,webpageURL.absoluteString);
                     NSURLComponents * components = [NSURLComponents componentsWithString:webpageURL.absoluteString];
                     NSArray * queryItems =  components.queryItems;
                     NSString * actionkey =  nil ;
                     NSString * ID = nil ;
                     for (NSURLQueryItem * item  in queryItems) {
                     if ([item.name isEqualToString:@"actionkey"]) {
                     if ([item.value isEqualToString:@"shop"]) {
                     actionkey = @"HShopVC";
                     }else if ([item.value isEqualToString:@"goods"]){
                     actionkey = @"HGoodsVC";
                     }else{
                     actionkey = item.value;
                     }
                     NSLog(@"_%d_%@",__LINE__,item.value);
                     }else if ([item.name isEqualToString:@"ID"]){
                     ID = item.value;
                     NSLog(@"_%d_%@",__LINE__,item.value);
                     }
                     
                     NSLog(@"_%d_%@",__LINE__,item.name);
                     NSLog(@"_%d_%@",__LINE__,item.value);
                     }
                     if (actionkey && ID ) {
                     BaseModel * model = [[[BaseModel alloc] init]initWithDict:@{@"actionkey":actionkey,@"paramete":ID}];
                     model.actionKey = actionkey;
                     model.keyParamete = @{@"paramete":ID};
                     [[SkipManager shareSkipManager] skipByVC:[KeyVC shareKeyVC] withActionModel:model];
                     }
                     
                     */
                    
                }else{
                    if UIApplication.shared.canOpenURL(webPageUrl!) {
                        UIApplication.shared.openURL(webPageUrl!)
                    }
                    
                }
            }
        }
        
        return true
    }
}




// MARK: 注释 : 处理远程推送数据
extension AppDelegate {
    //MARK:///////////////////处理远程推送相关/////////
    func dealWithRemoteNotification(userInfo : [AnyHashable : Any]) {
//        if !Account.shareAccount.isLogin {
//            GDAlertView.alert("请登录", image: nil, time: 2, complateBlock: nil)
//        }
        self.analysisData(userinfo: userInfo)
    }
    
    func analysisData (userinfo : [AnyHashable : Any] ) {
        if let actionkey = userinfo["actionkey"] {
            
            if let actionkeyStr = actionkey as? String {
                if  actionkeyStr == "orderlist" {
                    if let value  = userinfo["value"] {
                        mylog("good成功\(value)")
                        //                        let subWebVC = SubOrderListVC(vcType : VCType.withBackButton)
                        //                        if let url  = value as? String {
                        //                            subWebVC.originUrl = url
                        //                            KeyVC.share.pushViewController(subWebVC, animated: true )
                        //
                        //                        }else{mylog("\(actionkeyStr)对应的value转字符串失败")}
                    }else{mylog("\(actionkeyStr)对应的value为空")}
                }else if (actionkeyStr == "im"){
                    
                    if let value  = userinfo["value"] {
                        mylog("good成功\(value)")
                        //                        let chatVC  = ChatVC()
                        if let user  = value as? String {//要跟谁聊天
                            //                            let jid : XMPPJID = XMPPJID.init(user: user , domain: "jabber.zjlao.com", resource: "ios")
                            //                            chatVC.userJid = jid
                            //                            KeyVC.share.pushViewController(chatVC, animated: true )
                            
                        }else{mylog("\(actionkeyStr)对应的value转字符串失败")}
                    }else{mylog("\(actionkeyStr)对应的value为空")}
                    
                }
            }else{mylog("actionkey  any类型转string类型失败")}
            
            
            
        }else {
            mylog("解析actinkey失败")
        }
    }
    
}



// MARK : home Screen 3D touch
extension AppDelegate {
    //通过homeScreen 3D 按压应用图标defangshi进入app的代理方法
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let handledShortCutItem = handleShortCutItem(shortcutItem)
        
        completionHandler(handledShortCutItem)//处理的话 , 传true , 否则传false(还要处理longPress)
    }
    @available(iOS 9.0, *)
    func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        print("enter app by 3D touch press -> title:\(shortcutItem.localizedTitle) , subtitle:\(shortcutItem.localizedSubtitle) , type : \(shortcutItem.type) , info : \(shortcutItem.userInfo) , icon: \(shortcutItem.icon)")
        switch shortcutItem.localizedTitle {
        case "customTitle1":
            return true
        case "customTitle2":
            return true
        case "like me":
            let urlStr = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1133780608"
            if let url = URL(string: urlStr){
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url )
                }
            }
            return true
        default:
            return false
        }
        
    }
    ///判断3D touch 是否可用
    func whether3DTouchAble() -> Bool  {
        if #available(iOS 9.0, *) {
            switch self.window!.traitCollection.forceTouchCapability.rawValue {
            case 0:
                print("3D touch unknown")
                return false
            case 1:
                print("3D touch unavailable")
                return false
            case 2:
                print("3D touch available")
                return true
            default:
                return false
            }
        } else {
            // Fallback on earlier versions
            return false
        }
    }
    
    func dynamicSetHomescreen3DTouch(application : UIApplication)  {
        if #available(iOS 9.0, *) {
            let shortcutItems = self.getDynamicShortcuts()
            if  shortcutItems.isEmpty {
                let shortcut1 = UIMutableApplicationShortcutItem(type: "type1", localizedTitle: "customTitle1", localizedSubtitle: "customSubTitle1", icon: UIApplicationShortcutIcon(type: .play/*可以用自定义图片名,也可以用系统枚举值*/), userInfo: [
                    "info1": "value1"]
                )
                let shortcut2 = UIMutableApplicationShortcutItem(type: "type2", localizedTitle: "customTitle2", localizedSubtitle: "customSubTitle2", icon: UIApplicationShortcutIcon(type: .pause), userInfo: [
                    "info1": "value2"]
                )
                // Update the application providing the initial 'dynamic' shortcut items.
                application.shortcutItems = [shortcut1, shortcut2]
                if #available(iOS 9.1, *) {
                    let shortcut3 = UIMutableApplicationShortcutItem(type: "type3", localizedTitle: "like me", localizedSubtitle: "comment to appStore", icon: UIApplicationShortcutIcon(type: .love), userInfo: [
                        "info1": "value2"]
                    )
                    application.shortcutItems?.append(shortcut3)
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 9.0, *)
    ///获取通过代码动态创建的3D touch 配置项
    func getDynamicShortcuts() ->  [UIApplicationShortcutItem] {
        return  UIApplication.shared.shortcutItems ?? []
    }
    
    @available(iOS 9.0, *)
    ///获取infoPlist文件中3D touch 配置项
    func getStaticShortcuts () ->  [UIApplicationShortcutItem] {
        // Obtain the `UIApplicationShortcutItems` array from the Info.plist. If unavailable, there are no static shortcuts.
        guard let shortcuts = Bundle.main.infoDictionary?["UIApplicationShortcutItems"] as? [[String: NSObject]] else { return [] }
        
        // Use `flatMap(_:)` to process each dictionary into a `UIApplicationShortcutItem`, if possible.
        let shortcutItems = shortcuts.flatMap { shortcut -> [UIApplicationShortcutItem] in
            // The `UIApplicationShortcutItemType` and `UIApplicationShortcutItemTitle` keys are required to successfully create a `UIApplicationShortcutItem`.
            guard let shortcutType = shortcut["UIApplicationShortcutItemType"] as? String,
                let shortcutTitle = shortcut["UIApplicationShortcutItemTitle"] as? String else { return [] }
            // Get the localized title.
            var localizedShortcutTitle = shortcutTitle
            if let localizedTitle = Bundle.main.localizedInfoDictionary?[shortcutTitle] as? String {
                localizedShortcutTitle = localizedTitle
            }
            
            /*
             The `UIApplicationShortcutItemSubtitle` key is optional. If it
             exists, get the localized version.
             */
            var localizedShortcutSubtitle: String?
            if let shortcutSubtitle = shortcut["UIApplicationShortcutItemSubtitle"] as? String {
                localizedShortcutSubtitle = Bundle.main.localizedInfoDictionary?[shortcutSubtitle] as? String
            }
            
            return [
                UIApplicationShortcutItem(type: shortcutType, localizedTitle: localizedShortcutTitle, localizedSubtitle: localizedShortcutSubtitle, icon: nil, userInfo: nil)
            ]
        }
        return shortcutItems
    }
    
}

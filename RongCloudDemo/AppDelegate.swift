//
//  AppDelegate.swift
//  RongCloudDemo
//
//  Created by joakim.liu on 2018/8/30.
//  Copyright © 2018年 joakim.liu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        RCIM.shared().initWithAppKey("8w7jv4qb82kry")
        RCIM.shared().registerMessageType(TIMNotiMessage.self)
        RCIM.shared().enablePersistentUserInfoCache = true
        RCIM.shared().receiveMessageDelegate = self
        RCIM.shared()?.userInfoDataSource = self
        RCIM.shared()?.groupInfoDataSource = self
        
        RCIM.shared().connect(withToken: "2pX3bYqCFAQUvU8SxV/3MxLPJnCjqKgsrjmEscCaT3rKLpp+0uOpUQ==@7mhs.cn.rongnav.com;7mhs.cn.rongcfg.com", success: { (userId) in
            print("userId:\(String(describing: userId))")
            let userInfo: RCUserInfo = RCUserInfo.init(userId: userId, name: "Test", portrait:"")
            RCIM.shared().refreshUserInfoCache(userInfo, withUserId: userId)
            RCIM.shared().currentUserInfo = userInfo
        }, error: { (status) in
            print("connect status:\(status)")
        }, tokenIncorrect: {
            print("connect tokenIncorrect")
        })
        
        let tabbar = UITabBarController()
        let vc1 = UINavigationController(rootViewController: TIMConversationListViewController(nibName: nil, bundle: nil))
        vc1.tabBarItem = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 1)
        let vc2 = UINavigationController(rootViewController: TestViewController(nibName: nil, bundle: nil))
        vc2.tabBarItem = UITabBarItem.init(tabBarSystemItem: .topRated, tag: 2)
        tabbar.setViewControllers([vc1, vc2], animated: false)
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = tabbar
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: RCIMReceiveMessageDelegate {
    func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        let typeArray = [NSNumber(value: RCConversationType.ConversationType_PRIVATE.rawValue),
        NSNumber(value: RCConversationType.ConversationType_SYSTEM.rawValue),NSNumber(value: RCConversationType.ConversationType_GROUP.rawValue)]
        
        let count = RCIMClient.shared()?.getUnreadCount(typeArray, containBlocked: false)
        let count1 = RCIMClient.shared()?.getTotalUnreadCount()
        print("onRCIMReceive:\(String(describing: message.objectName)), count:\(count!), count1:\(count1!)")
    }
}

extension AppDelegate: RCIMUserInfoDataSource {
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        completion(RCUserInfo(userId: userId, name: "用户:\(userId!)", portrait: ""))
    }
}


extension AppDelegate : RCIMGroupInfoDataSource {
    func getGroupInfo(withGroupId groupId: String!, completion: ((RCGroup?) -> Void)!) {
        completion(RCGroup(groupId: groupId, groupName: "群:\(groupId!)", portraitUri: ""))
    }
}

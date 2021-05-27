//
//  ApplozicWrapper.swift
//  ApplozicSwiftObjcSample
//
//  Created by apple on 27/05/21.
//

import Foundation
import ApplozicSwift
import UserNotifications
import ApplozicCore

@objc public class ApplozicWrapper: NSObject {

    @objc public static let shared = ApplozicWrapper()

    @objc func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NSLog("Device token data :: \(deviceToken.description)")
        var deviceTokenString: String = ""
        for i in 0..<deviceToken.count {
            deviceTokenString += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        NSLog("Device token :: \(deviceTokenString)")
        if (ALUserDefaultsHandler.getApnDeviceToken() != deviceTokenString) {
            let alRegisterUserClientService: ALRegisterUserClientService = ALRegisterUserClientService()
            alRegisterUserClientService.updateApnDeviceToken(withCompletion: deviceTokenString, withCompletion: { (response, error) in
                if error != nil {
                    print("Error in Registration: " + error!.localizedDescription)
                    return
                }
                print("Registration Response :: \(String(describing: response))")
            })
        }
    }

    @objc func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerForNotification()
        // Override point for customization after application launch.
        ALKPushNotificationHandler.shared.dataConnectionNotificationHandlerWith(ALChatManager.defaultConfiguration)
        let alApplocalNotificationHnadler : ALAppLocalNotifications =  ALAppLocalNotifications.appLocalNotificationHandler();
        alApplocalNotificationHnadler.dataConnectionNotificationHandler();
        return true
    }

    @objc func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    @objc func applicationWillTerminate(application: UIApplication) {
        ALDBHandler.sharedInstance().saveContext()
    }

    @objc func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        print("Received notification With Completion :: \(userInfo.description)")
        let service = ALPushNotificationService()
        guard !service.isApplozicNotification(userInfo) else {
            service.notificationArrived(to: application, with: userInfo)
            completionHandler(UIBackgroundFetchResult.newData)
            return
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }

    @objc func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let service = ALPushNotificationService()
        guard !service.isApplozicNotification(notification.request.content.userInfo) else {
            service.notificationArrived(to: UIApplication.shared, with: notification.request.content.userInfo)
            completionHandler([])
            return
        }
        completionHandler([.sound, .badge, .alert])
    }

    @objc func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let service = ALPushNotificationService()
        let dict = response.notification.request.content.userInfo
        guard !service.isApplozicNotification(dict) else {
            switch UIApplication.shared.applicationState {
            case .active:
                service.processPushNotification(dict, updateUI: NSNumber(value: APP_STATE_ACTIVE.rawValue))
            case .background:
                service.processPushNotification(dict, updateUI: NSNumber(value: APP_STATE_BACKGROUND.rawValue))
            case .inactive:
                service.processPushNotification(dict, updateUI: NSNumber(value: APP_STATE_INACTIVE.rawValue))
            @unknown default:
                print("unknown state in push notification")
            }
            completionHandler()
            return
        }
        completionHandler()
    }

    @objc func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in

            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
}

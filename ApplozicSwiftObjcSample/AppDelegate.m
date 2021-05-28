//
//  AppDelegate.m
//  ApplozicSwiftObjcSample
//
//  Created by apple on 26/05/21.
//

#import "AppDelegate.h"
#import "ViewController.h"
@import ApplozicSwift;
@import ApplozicCore;
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if ([ALUserDefaultsHandler isLoggedIn]) {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
        UINavigationController *navVC = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"navVC"];

        navVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.window makeKeyAndVisible];
        [self.window.rootViewController presentViewController:navVC
                                                     animated:YES
                                                   completion:nil];
    }

    UNUserNotificationCenter.currentNotificationCenter.delegate = self;

    return [ApplozicWrapper.shared application:application didFinishLaunchingWithOptions:launchOptions];
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)) {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}



-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {

    [ApplozicWrapper.shared application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult backgroundFetchResult) {

        // Perform your other operations here

        completionHandler(backgroundFetchResult);
    }];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification*)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {

    [ApplozicWrapper.shared userNotificationCenter:center willPresent:notification withCompletionHandler:^(UNNotificationPresentationOptions options) {
        completionHandler(options);
    }];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(nonnull UNNotificationResponse* )response withCompletionHandler:(nonnull void (^)(void))completionHandler {

    [ApplozicWrapper.shared userNotificationCenter:center didReceive:response withCompletionHandler:^{
        completionHandler();
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [ApplozicWrapper.shared applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [ApplozicWrapper.shared applicationWillTerminateWithApplication:application];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    [ApplozicWrapper.shared application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

@end

//
//  AppDelegate.m
//  eNos
//
//  Created by AMZUR Technologies on 15/08/15.
//  Copyright (c) 2015 AMZUR Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import "HexColor.h"
#import "AFNetworking.h"
#import "NSData+HexString.h"
#import "TSMessage.h"
@import AVFoundation;
#import "OpenHABAppDataDelegate.h"
#import "OpenHABDataObject.h"
#import "AFRememberingSecurityPolicy.h"
#import <ChameleonFramework/Chameleon.h>
#import "SlideNavigationController.h"
#import "MenuViewController.h"
#import "SlideNavigationContorllerAnimator.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
#import <MQTTKit.h>
#import "defines.h"
@interface AppDelegate ()<OpenHABAppDataDelegate>
{
    AVAudioPlayer *player;
}
@property (nonatomic, retain) OpenHABDataObject* appData;
@property MQTTClient *client;
@end

@implementation AppDelegate

- (id)init
{
    self.appData = [[OpenHABDataObject alloc] init];
    return [super init];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    


    MenuViewController *menuviewcontroller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"menu"];
    
    [SlideNavigationController sharedInstance].leftMenu = menuviewcontroller;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = 0.18;
    
    [SlideNavigationController sharedInstance].menuRevealAnimator = [[SlideNavigationContorllerAnimatorScaleAndFade alloc] init];
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = 0.22;
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTranslucent:YES];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100) forBarMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self loadSettingsDefaults];
    [AFRememberingSecurityPolicy initializeCertificatesStore];
    // Notification registration now depends on iOS version (befor iOS8 and after it)
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        // iOS 8 Notifications
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        // iOS < 8 Notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    //    AudioSessionInitialize(NULL, NULL, nil , nil);
    //    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error: nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // TODO: Pass this parameters to openHABViewController somehow to open specified sitemap/page and send specified command
    // Probably need to do this in a way compatible to Android app's URL
    NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", [deviceToken hexString]);
    NSDictionary *dataDict = @{
                               @"deviceToken": [deviceToken hexString],
                               @"deviceId": [UIDevice currentDevice].identifierForVendor.UUIDString,
                               @"deviceName": [UIDevice currentDevice].name,
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"apsRegistered" object:self userInfo:dataDict];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification");
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"App is active and got a remote notification");
        NSLog(@"%@", [userInfo valueForKey:@"aps"]);
        NSString *message = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"body"];
        NSURL* soundPath = [[NSBundle mainBundle] URLForResource: @"ping" withExtension:@"wav"];
        NSLog(@"Sound path %@", soundPath);
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundPath error:nil];
        if (player != nil) {
            player.numberOfLoops = 0;
            [player play];
        } else {
            NSLog(@"AVPlayer error");
        }
        [TSMessage showNotificationInViewController:((UINavigationController*)self.window.rootViewController).visibleViewController title:@"Notification" subtitle:message image:nil type:TSMessageNotificationTypeMessage duration:5.0 callback:nil buttonTitle:nil buttonCallback:nil atPosition:TSMessageNotificationPositionBottom canBeDismissedByUser:YES];
    }
}


- (void)loadSettingsDefaults
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (![prefs objectForKey:@"localUrl"])
        [prefs setValue:@"" forKey:@"localUrl"];
    if (![prefs objectForKey:@"remoteUrl"])
        [prefs setValue:@"" forKey:@"remoteUrl"];
    if (![prefs objectForKey:@"username"])
        [prefs setValue:@"" forKey:@"username"];
    if (![prefs objectForKey:@"password"])
        [prefs setValue:@"" forKey:@"password"];
    if (![prefs objectForKey:@"ignoreSSL"])
        [prefs setBool:NO forKey:@"ignoreSSL"];
    if (![prefs objectForKey:@"demomode"])
        [prefs setBool:YES forKey:@"demomode"];
    if (![prefs objectForKey:@"idleOff"])
        [prefs setBool:NO forKey:@"idleOff"];
}

@end

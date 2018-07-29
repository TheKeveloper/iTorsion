//
//  AppDelegate.swift
//  Eyeliner
//
//  Created by Kevin Bi on 6/29/17.
//  Copyright © 2017 Kevelopment. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let bgColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1);
    static let screenSize : CGRect = UIScreen.main.bounds;
    
    static let KEY_DEFAULTSET = "DEFAULTS_SET";
    
    static let KEY_RIGHTR = "RIGHT0";
    static let KEY_RIGHTG = "RIGHT1";
    static let KEY_RIGHTB = "RIGHT2";
    
    static let KEY_LEFTR = "LEFT0";
    static let KEY_LEFTG = "LEFT1";
    static let KEY_LEFTB = "LEFT2";
    
    static let KEY_BG = "BACKGROUND_COLOR";
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Handles uncaught exceptions
        NSSetUncaughtExceptionHandler { (exception) in
            //Print exceptions to console
            debugPrint(exception.name, exception.reason!);
            //Set defaults to be manually read later
            let defaults = UserDefaults.standard;
            defaults.set(exception.name, forKey: "EXCEPTION_NAME");
            defaults.set(exception.reason!, forKey: "EXCEPTION_REASON");
        }
        // Override point for customization after application launch.
        setDefaults();
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
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
    }
    
    //Establishes the default values.
    func setDefaults(){
        let defaults = UserDefaults.standard;
        let changed = defaults.bool(forKey: AppDelegate.KEY_DEFAULTSET);
        if(!changed){
            defaults.set(Float(190), forKey: AppDelegate.KEY_RIGHTR);
            defaults.set(Float(0), forKey: AppDelegate.KEY_RIGHTG);
            defaults.set(Float(0), forKey: AppDelegate.KEY_RIGHTB);
            
            defaults.set(Float(0), forKey: AppDelegate.KEY_LEFTR);
            defaults.set(Float(63), forKey: AppDelegate.KEY_LEFTG);
            defaults.set(Float(126), forKey: AppDelegate.KEY_LEFTB);
            
            defaults.set(Float(38), forKey: AppDelegate.KEY_BG);
         
            defaults.set(true, forKey: AppDelegate.KEY_DEFAULTSET);
        }
        defaults.synchronize();
    }


}


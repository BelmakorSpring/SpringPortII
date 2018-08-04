//
//  AppDelegate.swift
//  SpringPort II
//
//  Created by MasterBel2 on 3/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

func timeStamp() -> String { // Make this a class thing?
    let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = "HH:mm:ss"
    dateFormatter.timeZone = TimeZone.current

    let timestamp = dateFormatter.string(from: Date())

    return timestamp
}



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow?
    
    
    
    @IBOutlet weak var singlePlayerGameMenuItem: NSMenuItem!
    @IBOutlet weak var relaunchSpringMenuItem: NSMenuItem! // When selected will join an already in-game game
	
	@IBAction func relaunchSpringMenuItemPressed(_ sender: Any) {
        
    }
	
    @IBAction func singlePlayerGameMenuItemPressed(_ sender: Any) {
    }
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let window = NSWindow()
        let storyboard = DefaultStoryboard(window: window)
        let viewController = storyboard.loginViewController()
        
        window.contentViewController = viewController
        window.makeKeyAndOrderFront(self)
        
        self.window = window
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
}

protocol MenuDelegate: class {
	func disableSpectate()
	func enableSpectate()
	func disableSoloGame()
	func enableSoloGame()
}

extension AppDelegate: MenuDelegate {
	func disableSpectate() { relaunchSpringMenuItem.isEnabled = false }
	func enableSpectate() { relaunchSpringMenuItem.isEnabled = true }
	
	func disableSoloGame() { singlePlayerGameMenuItem.isEnabled = false }
	func enableSoloGame() { singlePlayerGameMenuItem.isEnabled = true }
}

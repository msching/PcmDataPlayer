//
//  AppDelegate.m
//  MacPcmDataPlayer
//
//  Created by Chengyin on 15/12/21.
//  Copyright © 2015年 Chengyin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    [self.window makeKeyAndOrderFront:NSApp];
    return YES;
}

@end

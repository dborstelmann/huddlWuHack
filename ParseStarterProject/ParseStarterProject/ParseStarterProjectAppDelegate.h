//
//  ParseStarterProjectAppDelegate.h
//  ParseStarterProject
//
//  Copyright 2014 Parse, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class ParseStarterProjectViewController;

@interface ParseStarterProjectAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet ParseStarterProjectViewController *viewController;

@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static int facebookBlue = 0x3B5998;
static int huddlOrange = 0xf15b25;
static int huddlBlue = 0x4698C2;
static int huddlRed = 0xCC0000;
static int lightGray = 0xD6D6D6;
static int darkGray = 0x444444;

NSString *facebookID;

NSMutableDictionary *idList;
NSMutableArray *groupList;
NSMutableArray *chatGroups;
NSMutableDictionary *chatAll;
NSMutableArray *currentGroupHuddlList;
NSInteger currentChat;

PFObject *friendListObject;
PFObject *groupListObject;

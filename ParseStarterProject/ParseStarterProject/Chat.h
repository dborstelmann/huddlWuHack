//
//  Chat.h
//  ParseStarterProject
//
//  Created by Daniel Borstelmann on 9/13/14.
//
//

#import <UIKit/UIKit.h>

@interface Chat : UITableViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

{
    UIView *addView;
    UIView *addPop;
    UITextField *huddlName;
    UITextField *whenField;
    NSMutableArray *chatMessages;
    UITextField *chatField;
    NSString *stringId;
    NSTimer *autoTimer;
}

@end

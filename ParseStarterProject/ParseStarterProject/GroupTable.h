//
//  GroupTable.h
//  ParseStarterProject
//
//  Created by Daniel Borstelmann on 9/12/14.
//
//

#import <UIKit/UIKit.h>

@interface GroupTable : UITableViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

{
    UITableView *friendTable;
    NSMutableArray *friends;
    NSMutableArray *selectedFriends;
    UIView *addView;
    UIView *addPop;
    UITextField *groupName;
}

@end

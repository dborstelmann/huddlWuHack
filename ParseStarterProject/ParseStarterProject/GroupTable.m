//
//  GroupTable.m
//  ParseStarterProject
//
//  Created by Daniel Borstelmann on 9/12/14.
//
//

#import "GroupTable.h"
#import "ParseStarterProjectAppDelegate.h"
#import "Chat.h"

#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface GroupTable ()

@end

@implementation GroupTable

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    friends = [[NSMutableArray alloc] init];
    selectedFriends = [[NSMutableArray alloc] init];
    
    self.title = @"Groups";
    [self.tableView setBackgroundColor:UIColorFromRGB(lightGray)];

    [self _loadData];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroup)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)addGroup {
    addPop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [addPop setBackgroundColor:UIColorFromRGB(darkGray)];
    [addPop setAlpha:.5];
    [self.view addSubview:addPop];
    
    addView = [[UIView alloc] initWithFrame:CGRectMake(40, 40, self.view.frame.size.width - 80, self.view.frame.size.height - 80)];
    [addView.layer setCornerRadius:4];
    [addView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:addView];
    
    UILabel *groupAddLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 100, 20)];
    groupAddLabel.text = @"Group Name:";
    groupAddLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    groupAddLabel.textColor = UIColorFromRGB(huddlOrange);
    groupAddLabel.textAlignment = NSTextAlignmentLeft;
    [addView addSubview:groupAddLabel];
    
    groupName = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, self.view.frame.size.width - 100, 20)];
    groupName.delegate = self;
    groupName.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    groupName.returnKeyType = UIReturnKeyDone;
    [groupName setBorderStyle:UITextBorderStyleRoundedRect];
    [addView addSubview:groupName];
    
    friendTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 80, self.view.frame.size.width - 100, self.view.frame.size.height - 230)];
    friendTable.delegate = self;
    friendTable.dataSource = self;
    [friendTable.layer setBorderColor:UIColorFromRGB(huddlOrange).CGColor];
    [friendTable.layer setBorderWidth:.5];
    [friendTable.layer setCornerRadius:4];
    [addView addSubview:friendTable];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 140, self.view.frame.size.width - 100, 50)];
    [addButton setBackgroundColor:UIColorFromRGB(huddlOrange)];
    [addButton.layer setCornerRadius:4];
    [addButton setTitle:@"Add Group" forState:UIControlStateNormal];
    [addButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    [addButton addTarget:self action:@selector(sendGroup) forControlEvents:UIControlEventTouchUpInside];
    [addView addSubview:addButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 160, 6, 70, 28)];
    [cancelButton setBackgroundColor:UIColorFromRGB(huddlOrange)];
    [cancelButton.layer setCornerRadius:4];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [cancelButton addTarget:self action:@selector(dismissGroup) forControlEvents:UIControlEventTouchUpInside];
    [addView addSubview:cancelButton];
}

- (void)dismissGroup {
    [addView removeFromSuperview];
    [addPop removeFromSuperview];
}

- (void)sendGroup {
    
    for (int i = 0; i < selectedFriends.count; i++) {
        if ([[selectedFriends objectAtIndex:i] isEqualToString:@""]) {
            [selectedFriends removeObjectAtIndex:i];
        }
    }
    PFUser *user = [PFUser currentUser];
    
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [act setFrame:CGRectMake(((self.view.frame.size.width / 2) - 40), ((self.view.frame.size.height / 2) - 40), 80, 80)];
    [self.view addSubview:act];
    [act startAnimating];
    [PFCloud callFunctionInBackground:@"newGroup"
                       withParameters:@{@"users": selectedFriends, @"name": groupName.text, @"user_id": facebookID}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        NSString *groupId = result;
                                        NSLog(@"NEW GROUP %@", groupId);
                                        
                                        [PFCloud callFunctionInBackground:@"getGroups"
                                                           withParameters:@{@"userId": user.objectId}
                                                                    block:^(NSArray *result, NSError *error) {
                                                                        if (!error) {
                                                                            [act stopAnimating];
                                                                            [addPop removeFromSuperview];
                                                                            [addView removeFromSuperview];
                                                                            NSLog(@"GET GROUPS %@", result);
                                                                            [groupList removeAllObjects];
                                                                            groupList = [NSMutableArray arrayWithArray:result];
                                                                            [self.tableView reloadData];
                                                                            [selectedFriends removeAllObjects];
                                                                            selectedFriends = [[NSMutableArray alloc] init];
                                                                            for (int i = 0; i < friends.count; i++) {
                                                                                [selectedFriends addObject:@""];
                                                                            }
                                                                        }
                                                                        
                                                                        
                                        }];

//                                        NSMutableDictionary *groupDict = [[NSMutableDictionary alloc] init];
//                                        [groupDict setObject:selectedFriends forKey:@"friends"];
//                                        [groupDict setObject:groupName.text forKey:@"name"];
//                                        [groupDict setObject:groupId forKey:@"id"];
//                                        [groupList addObject:groupDict];
                                        
                                    }
    }];
    
}

- (void)_loadData {
    
    FBRequest *idReq = [FBRequest requestForMe];
    [idReq startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            facebookID = [userData objectForKey:@"id"];
        }
    }];
    
    PFUser *user = [PFUser currentUser];
    
    FBRequest *request = [FBRequest requestForMyFriends];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            NSMutableDictionary *friendList = [[NSMutableDictionary alloc] init];
                        
            for (int i = 0; i < [[userData objectForKey:@"data"] count]; i++) {
                NSString *friendId = [[[userData objectForKey:@"data"] objectAtIndex:i] objectForKey:@"id"];
                NSString *friendName = [[[userData objectForKey:@"data"] objectAtIndex:i] objectForKey:@"name"];
                [friendList setObject:friendName forKey:friendId];
                
                NSMutableDictionary *friend = [[NSMutableDictionary alloc] init];
                [friend setObject:friendId forKey:@"id"];
                [friend setObject:friendName forKey:@"name"];
                [friends addObject:friend];
                [selectedFriends addObject:@""];
            }
                        
            if ([[idList objectForKey:@"friendListKey"] isEqualToString:@"empty"]) {
                groupListObject = [PFObject objectWithClassName:@"groupList"];
                groupListObject[@"array"] = groupList;
                friendListObject = [PFObject objectWithClassName:@"friendList"];
                friendListObject[@"array"] = friendList;
                [friendListObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [idList setObject:friendListObject.objectId forKey:@"friendListKey"];
                    [[PFUser currentUser] setObject:idList forKey:@"listOfObjects"];
                    [[PFUser currentUser] setObject:facebookID forKey:@"facebookId"];
                    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        [groupListObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            [idList setObject:groupListObject.objectId forKey:@"groupListKey"];
                            [[PFUser currentUser] setObject:idList forKey:@"listOfObjects"];
                            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                
                            }];
                        }];
                    }];
                }];
                
            }
            else {
                PFQuery *query = [PFQuery queryWithClassName:@"friendList"];
                [query getObjectInBackgroundWithId:[idList objectForKey:@"friendListKey"] block:^(PFObject *temp, NSError *error) {
                    friendListObject = temp;
                    temp[@"array"] = friendList;
                    [temp saveInBackground];
                }];
                PFQuery *chatQuery = [PFQuery queryWithClassName:@"groupList"];
                [chatQuery getObjectInBackgroundWithId:[idList objectForKey:@"groupListKey"] block:^(PFObject *temp, NSError *error) {
                    chatGroups = temp[@"array"];

                }];
                
                [PFCloud callFunctionInBackground:@"getGroups"
                                   withParameters:@{@"userId": user.objectId}
                                            block:^(NSArray *result, NSError *error) {
                                                if (!error) {
                                                    NSLog(@"GET GROUPS %@", result);
                                                    groupList = [NSMutableArray arrayWithArray:result];
                                                    [self.tableView reloadData];
                                                }
                                                
                                                
                }];
            }
            
        }
    }];

}

- (void) logoutButtonAction:(id)sender  {
    [PFUser logOut]; // Log out
    
    // Return to Login view controller
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:friendTable]) {
        return 44;
    }
    else {
        return 60;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:friendTable]) {
        return [[friendListObject objectForKey:@"array"] count];
    }
    else {
        return groupList.count;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *newCell = nil;

    if ([tableView isEqual:friendTable]) {
        NSNumber *row = [NSNumber numberWithInteger:indexPath.row];
        UITableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:[row stringValue]];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[row stringValue]];
        }
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 115, 44)];
        nameLabel.text = [[friends objectAtIndex:indexPath.row] objectForKey:@"name"];
        nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        nameLabel.textColor = UIColorFromRGB(darkGray);
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:nameLabel];
        
        return cell;
    }
    else {
        NSNumber *row = [NSNumber numberWithInteger:indexPath.row];
        UITableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:[row stringValue]];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[row stringValue]];
        }
        cell.backgroundColor = UIColorFromRGB(lightGray);
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 50)];
        [backView setBackgroundColor:[UIColor whiteColor]];
        [backView.layer setCornerRadius:4];
        [cell addSubview:backView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 40, 30)];
        nameLabel.text = [groupList[indexPath.row] objectForKey:@"name"];
        nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        nameLabel.textColor = UIColorFromRGB(darkGray);
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [backView addSubview:nameLabel];
        
        UILabel *friendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 26, self.view.frame.size.width - 40, 20)];
        NSMutableString *string = [NSMutableString stringWithString:[groupList[indexPath.row] objectForKey:@"length"]];
        if ([string isEqualToString:@"1"]) {
            [string appendString:@" friend"];
        }
        else {
            [string appendString:@" friends"];
        }
        friendsLabel.text = string;
        friendsLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        friendsLabel.textColor = UIColorFromRGB(huddlOrange);
        friendsLabel.textAlignment = NSTextAlignmentLeft;
        [backView addSubview:friendsLabel];
        
        return cell;
    }
    return newCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:friendTable]) {
        if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [selectedFriends replaceObjectAtIndex:indexPath.row withObject:@""];
        }
        else {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            [selectedFriends replaceObjectAtIndex:indexPath.row withObject:[[friends objectAtIndex:indexPath.row] objectForKey:@"id"]];
        }
    }
    else {
        groupID = [[groupList objectAtIndex:indexPath.row] objectForKey:@"id"];
        currentChat = indexPath.row;
        Chat *chatView = [[Chat alloc] initWithStyle:UITableViewStylePlain];
        chatView.title = [groupList[indexPath.row] objectForKey:@"name"];
        [self.navigationController pushViewController:chatView animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

@end

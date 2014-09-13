//
//  GroupTable.m
//  ParseStarterProject
//
//  Created by Daniel Borstelmann on 9/12/14.
//
//

#import "GroupTable.h"
#import "ParseStarterProjectAppDelegate.h"

#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface GroupTable ()

@end

@implementation GroupTable

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
}

- (void)sendGroup {
    [addView removeFromSuperview];
    
    for (int i = 0; i < selectedFriends.count; i++) {
        if ([[selectedFriends objectAtIndex:i] isEqualToString:@""]) {
            [selectedFriends removeObjectAtIndex:i];
        }
    }
    
    [PFCloud callFunctionInBackground:@"newGroup"
                       withParameters:@{@"users": selectedFriends, @"name": groupName.text}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        // result is @"Hello world!"
                                        NSLog(@"%@", result);
                                    }
                                }];
        
//    PFObject *selFriends = [PFObject objectWithClassName:@"selectedFriends"];
//    selFriends[@"friends"] = selectedFriends;
//    selFriends[@"groupName"] = groupName.text;
//    [selFriends saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//    }];
}

- (void)_loadData {
    
    FBRequest *idReq = [FBRequest requestForMe];
    [idReq startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            
            facebookID = [userData objectForKey:@"id"];
        }
    }];
    
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
                friendListObject = [PFObject objectWithClassName:@"friendList"];
                friendListObject[@"array"] = friendList;
                [friendListObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [idList setObject:friendListObject.objectId forKey:@"friendListKey"];
                    [[PFUser currentUser] setObject:idList forKey:@"listOfObjects"];
                    [[PFUser currentUser] saveInBackground];
                }];
            }
            else {
                PFQuery *query = [PFQuery queryWithClassName:@"friendList"];
                [query getObjectInBackgroundWithId:[idList objectForKey:@"friendListKey"] block:^(PFObject *temp, NSError *error) {
                    friendListObject = temp;
                    temp[@"array"] = friendList;
                    [temp saveInBackground];
                }];
            }
            
        }
    }];
    
//    PFQuery *getGroups = [PFQuery queryWithClassName:@"groups"];
//    [getGroups getObjectInBackgroundWithId:[idList objectForKey:@"groupListKey"] block:^(PFObject *temp, NSError *error) {
//        
//    }];
}

- (void) logoutButtonAction:(id)sender  {
    [PFUser logOut]; // Log out
    
    // Return to Login view controller
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

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
        return 0;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [selectedFriends replaceObjectAtIndex:indexPath.row withObject:@""];
    }
    else {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedFriends replaceObjectAtIndex:indexPath.row withObject:[[friends objectAtIndex:indexPath.row] objectForKey:@"id"]];
    }
    NSLog(@"%@", selectedFriends);
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

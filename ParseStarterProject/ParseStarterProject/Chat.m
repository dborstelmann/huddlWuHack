//
//  Chat.m
//  ParseStarterProject
//
//  Created by Daniel Borstelmann on 9/13/14.
//
//

#import "Chat.h"
#import "ParseStarterProjectAppDelegate.h"
#import "Huddl.h"

@interface Chat ()

@end

@implementation Chat

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

- (void)viewDidLoad
{
    [self.tableView setBackgroundColor:UIColorFromRGB(lightGray)];
    currentHuddlData = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *test1 = [[NSMutableDictionary alloc] init];
    [test1 setObject:@"Italian" forKey:@"categories"];
    [test1 setObject:@"Sauce on the Side" forKey:@"name"];
    [test1 setObject:@"$$$" forKey:@"price"];
    [test1 setObject:@"7.7" forKey:@"rating"];
    [test1 setObject:@"0" forKey:@"upVotes"];
    [test1 setObject:@"0" forKey:@"downVotes"];
    
    NSMutableDictionary *test2 = [[NSMutableDictionary alloc] init];
    [test2 setObject:@"Ice Cream" forKey:@"categories"];
    [test2 setObject:@"Ted Drewes" forKey:@"name"];
    [test2 setObject:@"$$" forKey:@"price"];
    [test2 setObject:@"7.6" forKey:@"rating"];
    [test2 setObject:@"0" forKey:@"upVotes"];
    [test2 setObject:@"0" forKey:@"downVotes"];
    
    NSMutableDictionary *test3 = [[NSMutableDictionary alloc] init];
    [test3 setObject:@"Pizza" forKey:@"categories"];
    [test3 setObject:@"PW Pizza" forKey:@"name"];
    [test3 setObject:@"$$" forKey:@"price"];
    [test3 setObject:@"8.2" forKey:@"rating"];
    [test3 setObject:@"0" forKey:@"upVotes"];
    [test3 setObject:@"0" forKey:@"downVotes"];
    
    NSMutableDictionary *test4 = [[NSMutableDictionary alloc] init];
    [test4 setObject:@"Italian" forKey:@"categories"];
    [test4 setObject:@"Anthonio's Tavern" forKey:@"name"];
    [test4 setObject:@"$" forKey:@"price"];
    [test4 setObject:@"7.9" forKey:@"rating"];
    [test4 setObject:@"0" forKey:@"upVotes"];
    [test4 setObject:@"0" forKey:@"downVotes"];
    
    NSMutableDictionary *test5 = [[NSMutableDictionary alloc] init];
    [test5 setObject:@"Pizza" forKey:@"categories"];
    [test5 setObject:@"PI" forKey:@"name"];
    [test5 setObject:@"$$" forKey:@"price"];
    [test5 setObject:@"9.0" forKey:@"rating"];
    [test5 setObject:@"0" forKey:@"upVotes"];
    [test5 setObject:@"0" forKey:@"downVotes"];
    
    NSMutableDictionary *test6 = [[NSMutableDictionary alloc] init];
    [test6 setObject:@"American" forKey:@"categories"];
    [test6 setObject:@"Iron Barley" forKey:@"name"];
    [test6 setObject:@"$$" forKey:@"price"];
    [test6 setObject:@"8.4" forKey:@"rating"];
    [test6 setObject:@"0" forKey:@"upVotes"];
    [test6 setObject:@"0" forKey:@"downVotes"];
    
    NSMutableDictionary *test7 = [[NSMutableDictionary alloc] init];
    [test7 setObject:@"Barbeque" forKey:@"categories"];
    [test7 setObject:@"Pappy's Smokehouse" forKey:@"name"];
    [test7 setObject:@"$$" forKey:@"price"];
    [test7 setObject:@"9.5" forKey:@"rating"];
    [test7 setObject:@"0" forKey:@"upVotes"];
    [test7 setObject:@"0" forKey:@"downVotes"];
    
    [currentHuddlData addObject:test1];
    [currentHuddlData addObject:test2];
    [currentHuddlData addObject:test3];
    [currentHuddlData addObject:test4];
    [currentHuddlData addObject:test5];
    [currentHuddlData addObject:test6];
    [currentHuddlData addObject:test7];
    
    huddlList = [[NSMutableArray alloc] init];
    
    [PFCloud callFunctionInBackground:@"getHuddls"
                       withParameters:@{@"groupID": groupID}
                                block:^(NSArray *result, NSError *error) {
                                    if (!error) {
                                        NSLog(@"GET HUDDLS %@", result);
                                        [huddlList removeAllObjects];
                                        huddlList = [NSMutableArray arrayWithArray:result];
                                        [self.tableView reloadData];
                                    }
                                    
                                    
    }];
    
    chatMessages = [[NSMutableArray alloc] init];
    
    PFQuery *allQuery = [PFQuery queryWithClassName:@"HuddlGroup"];
    [allQuery getObjectInBackgroundWithId:[chatGroups objectAtIndex:currentChat] block:^(PFObject *temp, NSError *error) {
        chatMessages = temp[@"chats"];
        stringId = temp.objectId;
        [self.tableView reloadData];
        autoTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(retrievingFromParse) userInfo:nil repeats:YES];
    }];
    
    [super viewDidLoad];
    
}

- (void)retrievingFromParse {
    PFQuery *allQuery = [PFQuery queryWithClassName:@"HuddlGroup"];
    [allQuery getObjectInBackgroundWithId:[chatGroups objectAtIndex:currentChat] block:^(PFObject *temp, NSError *error) {
        chatMessages = temp[@"chats"];
        stringId = temp.objectId;
        [self.tableView reloadData];

    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat temp = 0;
    if (chatMessages.count < 10) {
        if (chatMessages.count == indexPath.row) {
            return 400;
        }
        else {
            temp = [self calcHeight:[[chatMessages objectAtIndex:indexPath.row] objectForKey:@"text"] fontSize:14 tableViewWidth:260];
            if (temp < 44) {
                temp = 44;
            }
            return temp + 10;
        }
    }
    else {
        temp = [self calcHeight:[[chatMessages objectAtIndex:indexPath.row] objectForKey:@"text"] fontSize:14 tableViewWidth:260];
        if (temp < 44) {
            temp = 44;
        }
        return temp + 10;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return chatMessages.count + 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [view setBackgroundColor:UIColorFromRGB(lightGray)];
    
    chatField = [[UITextField alloc] initWithFrame:CGRectMake(4, 4, self.view.frame.size.width - 80, 22)];
    chatField.delegate = self;
    chatField.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    chatField.returnKeyType = UIReturnKeyDone;
    [chatField setBorderStyle:UITextBorderStyleRoundedRect];
    [view addSubview:chatField];
    
    UIButton *send = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 68, 4, 58, 22)];
    [send setTitle:@"Send" forState:UIControlStateNormal];
    [send setTitleColor:UIColorFromRGB(huddlBlue) forState:UIControlStateNormal];
    [send.layer setBorderColor:UIColorFromRGB(huddlBlue).CGColor];
    [send.layer setBorderWidth:.5];
    [send.layer setCornerRadius:4];
    [send setBackgroundColor:[UIColor whiteColor]];
    [send addTarget:self action:@selector(sendChat) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:send];
    
    return view;
}

- (void)sendChat {
    if (![chatField.text isEqualToString:@""]) {
        [chatField resignFirstResponder];
        PFUser *user = [PFUser currentUser];
        [chatMessages addObject:@{@"text": chatField.text, @"owner": user.objectId}];
        NSLog(@"%@", chatMessages);
        PFObject *chatObject = [PFObject objectWithClassName:@"HuddlGroup"];
        chatObject[@"chats"] = chatMessages;
        chatObject.objectId = stringId;
        [chatObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            PFQuery *allQuery = [PFQuery queryWithClassName:@"HuddlGroup"];
            [allQuery getObjectInBackgroundWithId:[chatGroups objectAtIndex:currentChat] block:^(PFObject *temp, NSError *error) {
                [chatMessages removeAllObjects];
                chatMessages = temp[@"chats"];
                [self.tableView reloadData];
                autoTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(retrievingFromParse) userInfo:nil repeats:YES];
            }];
        }];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    //----------- PART 1 -------------
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *active = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 150, 40)];
    [active setTitle:@"ACTIVE HUDDLS: 6" forState:UIControlStateNormal];
    [active setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [active.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [active setBackgroundColor:UIColorFromRGB(huddlOrange)];
    [active.layer setCornerRadius:4];
    [active addTarget:self action:@selector(activeHuddls) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:active];
    
    UIButton *butt = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 130, 10, 120, 40)];
    [butt setTitle:@"NEW HUDDL" forState:UIControlStateNormal];
    [butt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [butt.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [butt setBackgroundColor:UIColorFromRGB(huddlOrange)];
    [butt.layer setCornerRadius:4];
    [butt addTarget:self action:@selector(newHuddl) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:butt];
    
    //----------- PART 2 -------------
    
    UIView *small = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 60)];
    [small setBackgroundColor:UIColorFromRGB(huddlBlue)];
    [view addSubview:small];
    
    UILabel *curLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 90, 30)];
    curLabel.textColor = [UIColor whiteColor];
    curLabel.text = @"CURRENT HUDDL:";
    curLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [small addSubview:curLabel];
    
    return view;
}

- (void)activeHuddls {
    
}

- (void)newHuddl {
    addPop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [addPop setBackgroundColor:UIColorFromRGB(darkGray)];
    [addPop setAlpha:.5];
    [self.view addSubview:addPop];
    
    addView = [[UIView alloc] initWithFrame:CGRectMake(40, 40, self.view.frame.size.width - 80, 180)];
    [addView.layer setCornerRadius:4];
    [addView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:addView];
    
    UILabel *huddlAddLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 100, 20)];
    huddlAddLabel.text = @"What:";
    huddlAddLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    huddlAddLabel.textColor = UIColorFromRGB(huddlOrange);
    huddlAddLabel.textAlignment = NSTextAlignmentLeft;
    [addView addSubview:huddlAddLabel];
    
    huddlName = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, self.view.frame.size.width - 100, 20)];
    huddlName.delegate = self;
    huddlName.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    huddlName.returnKeyType = UIReturnKeyDone;
    [huddlName setBorderStyle:UITextBorderStyleRoundedRect];
    [addView addSubview:huddlName];
    
    UILabel *huddlTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, self.view.frame.size.width - 100, 20)];
    huddlTimeLabel.text = @"When:";
    huddlTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    huddlTimeLabel.textColor = UIColorFromRGB(huddlOrange);
    huddlTimeLabel.textAlignment = NSTextAlignmentLeft;
    [addView addSubview:huddlTimeLabel];
    
    whenField = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 100, 20)];
    whenField.delegate = self;
    whenField.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    whenField.returnKeyType = UIReturnKeyDone;
    [whenField setBorderStyle:UITextBorderStyleRoundedRect];
    [addView addSubview:whenField];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 130, self.view.frame.size.width - 100, 40)];
    [addButton setBackgroundColor:UIColorFromRGB(huddlOrange)];
    [addButton.layer setCornerRadius:4];
    [addButton setTitle:@"Huddl Up" forState:UIControlStateNormal];
    [addButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    [addButton addTarget:self action:@selector(sendHuddl) forControlEvents:UIControlEventTouchUpInside];
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

- (void)sendHuddl {
    [addView removeFromSuperview];
    [addPop removeFromSuperview];
    
    huddlWhat = huddlName.text;
    huddlWhen = whenField.text;
    huddlLocation = @"St. Louis";
    
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [act setFrame:CGRectMake(((self.view.frame.size.width / 2) - 40), ((self.view.frame.size.height / 2) - 40), 80, 80)];
    [self.view addSubview:act];
    [act startAnimating];
    
    [PFCloud callFunctionInBackground:@"createFakeHuddl"
                       withParameters:@{@"groupID": groupID, @"topic": huddlWhat, @"time": huddlWhen, @"location": huddlLocation}
                                block:^(NSData *result, NSError *error) {
                                    if (!error) {
                                        [act stopAnimating];
                                        [addPop removeFromSuperview];
                                        [addView removeFromSuperview];
                                        NSLog(@"CREATE FAKE HUDDL %@", result);
                                        
//                                        NSString *jsonString = result;
//                                        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//                                        NSError *error = nil;
//                                        NSArray *myArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];

                                        
                                        
//                                        
//                                        [currentHuddlData removeAllObjects];
//                                        currentHuddlData = [NSMutableArray arrayWithArray:hi];
//                                        
//                                        NSLog(@"%@", currentHuddlData);
//                                        
                                        Huddl *huddlView = [[Huddl alloc] initWithStyle:UITableViewStylePlain];
                                        huddlView.title = huddlWhat;
                                        [self.navigationController pushViewController:huddlView animated:YES];
                                    }
                                    
                                    
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120;
}


- (CGFloat)calcHeight:(NSString *)inputText fontSize:(CGFloat)fontSize tableViewWidth:(CGFloat)tableWidth {
    NSString *text = inputText;
    CGFloat width = tableWidth;
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width - 50, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    CGFloat height = ceilf(size.height);
    
    
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *user = [PFUser currentUser];
    NSNumber *row = [NSNumber numberWithInteger:indexPath.row];
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:[row stringValue]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[row stringValue]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.row == chatMessages.count) {
        return cell;
    }
    if (chatMessages.count != 0) {
        
        if ([[[chatMessages objectAtIndex:indexPath.row] objectForKey:@"owner"] isEqualToString:user.objectId]) {
            UITextView *textLab = [[UITextView alloc] init];
            [textLab setEditable:NO];
            CGFloat temp = [self calcHeight:[[chatMessages objectAtIndex:indexPath.row] objectForKey:@"text"] fontSize:14 tableViewWidth:320];
            if (temp < 44) {
                temp = 44;
            }
            [textLab setFrame:CGRectMake(100, 10, 210, temp)];
            [textLab setText:[[chatMessages objectAtIndex:indexPath.row] objectForKey:@"text"]];
            [textLab setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
            [textLab setTextColor:[UIColor whiteColor]];
            [textLab.layer setCornerRadius:4];
            [textLab setBackgroundColor:UIColorFromRGB(huddlOrange)];
            [textLab setScrollEnabled:NO];
            [cell addSubview:textLab];
            
        }
        else {
            UITextView *textLab = [[UITextView alloc] init];
            [textLab setEditable:NO];
            CGFloat temp = [self calcHeight:[[chatMessages objectAtIndex:indexPath.row] objectForKey:@"text"] fontSize:14 tableViewWidth:320];
            if (temp < 44) {
                temp = 44;
            }
            [textLab setFrame:CGRectMake(10, 10, 210, temp)];
            [textLab setText:[[chatMessages objectAtIndex:indexPath.row] objectForKey:@"text"]];
            [textLab setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
            [textLab setTextColor:UIColorFromRGB(darkGray)];
            [textLab.layer setCornerRadius:4];
            [textLab setBackgroundColor:UIColorFromRGB(lightGray)];
            [textLab setScrollEnabled:NO];
            [cell addSubview:textLab];
        }
    }

    return cell;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [autoTimer invalidate];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

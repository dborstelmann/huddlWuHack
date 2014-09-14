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
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    //----------- PART 1 -------------
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, , 60)];
//    lab.textColor = UIColorFromRGB(huddlOrange);
//    lab.text = @"Number of Active Huddls: 6";
//    lab.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
//    [view addSubview:lab];
    
    UIButton *active = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 140, 40)];
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
}

- (void)sendHuddl {
    [addView removeFromSuperview];
    [addPop removeFromSuperview];
    
    //Code for new Huddl...
    
    //Needs work...
    
    Huddl *huddlController = [[Huddl alloc] initWithStyle:UITableViewStyleGrouped];
    huddlController.title = huddlName.text;
    [self.navigationController pushViewController:huddlController animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *row = [NSNumber numberWithInteger:indexPath.row];
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:[row stringValue]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[row stringValue]];
    }
    
    cell.textLabel.text = @"Chat text";
    
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    
    return YES;
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

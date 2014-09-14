//
//  Huddl.m
//  ParseStarterProject
//
//  Created by Daniel Borstelmann on 9/13/14.
//
//

#import "Huddl.h"
#import "ParseStarterProjectAppDelegate.h"

@interface Huddl ()

@end

@implementation Huddl

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2, 50)];
    [left setBackgroundColor:UIColorFromRGB(huddlBlue)];
    [view addSubview:left];
    UIView *right = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, 50)];
    [right setBackgroundColor:UIColorFromRGB(huddlBlue)];
    [view addSubview:right];
    UIView *middle = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 1, 0, 2, 50)];
    [middle setBackgroundColor:UIColorFromRGB(darkGray)];
    [view addSubview:middle];
    
    UILabel *what = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2, 30)];
    what.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    what.textColor = [UIColor whiteColor];
    what.text = @"What:";
    what.textAlignment = NSTextAlignmentCenter;
    [view addSubview:what];
    
    UILabel *whatActual = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width / 2, 30)];
    whatActual.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    whatActual.textColor = [UIColor whiteColor];
    whatActual.text = @"Dinner with the Bros";
    whatActual.textAlignment = NSTextAlignmentCenter;
    [view addSubview:whatActual];
    
    UILabel *when = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, 30)];
    when.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    when.textColor = [UIColor whiteColor];
    when.text = @"When:";
    when.textAlignment = NSTextAlignmentCenter;
    [view addSubview:when];
    
    UILabel *whenActual = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 20, self.view.frame.size.width / 2, 30)];
    whenActual.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    whenActual.textColor = [UIColor whiteColor];
    whenActual.text = @"Tonight at 6";
    whenActual.textAlignment = NSTextAlignmentCenter;
    [view addSubview:whenActual];
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *row = [NSNumber numberWithInteger:indexPath.row];
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:[row stringValue]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[row stringValue]];
    }
    
    UILabel *nameOf = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 240, 40)];
    nameOf.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    nameOf.textColor = UIColorFromRGB(darkGray);
    nameOf.text = @"Bobo Noodle House";
    
    UILabel *rating = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 60, 50)];
    rating.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
    rating.textColor = [UIColor whiteColor];
    rating.text = @"9.7";
    rating.textAlignment = NSTextAlignmentCenter;

    UIView *ratingView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 60, 50)];
    [ratingView.layer setCornerRadius:4];
    [ratingView setBackgroundColor:UIColorFromRGB(huddlOrange)];
    
    UILabel *categories = [[UILabel alloc] initWithFrame:CGRectMake(80, 36, 170, 20)];
    categories.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    categories.textColor = UIColorFromRGB(huddlBlue);
    categories.text = @"Asian";
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(80, 55, 170, 20)];
    price.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    price.textColor = UIColorFromRGB(huddlRed);
    price.text = @"Price: $$";
    
    UILabel *url = [[UILabel alloc] initWithFrame:CGRectMake(80, 74, 170, 20)];
    url.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    url.textColor = UIColorFromRGB(darkGray);
    url.text = @"bobonoodle.com";
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:@"bobonoodle.com"];
    [str addAttribute: NSLinkAttributeName value: @"bobonoodle.com" range: NSMakeRange(0, str.length)];
    url.attributedText = str;
    
    UIButton *up = [[UIButton alloc] initWithFrame:CGRectMake(250, 10, 40, 40)];
    [up setImage:[UIImage imageNamed:@"Up"] forState:UIControlStateNormal];
    UIButton *down = [[UIButton alloc] initWithFrame:CGRectMake(250, 50, 40, 40)];
    [down setImage:[UIImage imageNamed:@"Down"] forState:UIControlStateNormal];
    
    UILabel *upLab = [[UILabel alloc] initWithFrame:CGRectMake(285, 10, 30, 40)];
    upLab.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    upLab.textColor = UIColorFromRGB(huddlBlue);
    upLab.text = @"7";
    upLab.textAlignment = NSTextAlignmentCenter;
    UILabel *downLab = [[UILabel alloc] initWithFrame:CGRectMake(285, 50, 30, 40)];
    downLab.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    downLab.textColor = UIColorFromRGB(huddlRed);
    downLab.text = @"1";
    downLab.textAlignment = NSTextAlignmentCenter;
    
    [cell addSubview:nameOf];
    [cell addSubview:ratingView];
    [cell addSubview:rating];
    [cell addSubview:categories];
    [cell addSubview:price];
    [cell addSubview:url];
    [cell addSubview:up];
    [cell addSubview:down];
    [cell addSubview:upLab];
    [cell addSubview:downLab];
    
    return cell;
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

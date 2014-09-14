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
    NSNumber *row = [NSNumber numberWithInt:1000000%5];
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:[row stringValue]];
    
    UILabel *nameOf = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 240, 40)];

    UILabel *rating = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 60, 50)];

    UIView *ratingView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 60, 50)];

    UILabel *categories = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 170, 25)];

    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, 170, 25)];

    UIButton *up = [[UIButton alloc] initWithFrame:CGRectMake(250, 10, 40, 40)];

    UIButton *down = [[UIButton alloc] initWithFrame:CGRectMake(250, 50, 40, 40)];

    UILabel *upLab = [[UILabel alloc] initWithFrame:CGRectMake(285, 10, 30, 40)];
    UILabel *downLab = [[UILabel alloc] initWithFrame:CGRectMake(285, 50, 30, 40)];

    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    nameOf.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    nameOf.textColor = UIColorFromRGB(darkGray);
    nameOf.text = [[currentHuddlData objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    rating.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
    rating.textColor = [UIColor whiteColor];
    rating.text = [[currentHuddlData objectAtIndex:indexPath.row] objectForKey:@"rating"];
    rating.textAlignment = NSTextAlignmentCenter;
    
    [ratingView.layer setCornerRadius:4];
    [ratingView setBackgroundColor:UIColorFromRGB(huddlOrange)];
    
    categories.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    categories.textColor = UIColorFromRGB(huddlBlue);
    categories.text = [[currentHuddlData objectAtIndex:indexPath.row] objectForKey:@"categories"];
    
    price.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    price.textColor = UIColorFromRGB(huddlRed);
    price.text = [[currentHuddlData objectAtIndex:indexPath.row] objectForKey:@"price"];
    
    [up setImage:[UIImage imageNamed:@"Up"] forState:UIControlStateNormal];
    up.tag = indexPath.row;
    [up addTarget:self action:@selector(upHit:) forControlEvents:UIControlEventTouchUpInside];
    [down setImage:[UIImage imageNamed:@"Down"] forState:UIControlStateNormal];
    down.tag = indexPath.row;
    [down addTarget:self action:@selector(downHit:) forControlEvents:UIControlEventTouchUpInside];
    
    upLab.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    upLab.textColor = UIColorFromRGB(huddlBlue);
    upLab.text = [[currentHuddlData objectAtIndex:indexPath.row] objectForKey:@"upVotes"];
    upLab.textAlignment = NSTextAlignmentCenter;
    downLab.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    downLab.textColor = UIColorFromRGB(huddlRed);
    downLab.text = [[currentHuddlData objectAtIndex:indexPath.row] objectForKey:@"downVotes"];
    downLab.textAlignment = NSTextAlignmentCenter;
    
    nameOf.text = [[currentHuddlData objectAtIndex:indexPath.row] objectForKey:@"name"];
    rating.textAlignment = NSTextAlignmentCenter;
    categories.text = [[currentHuddlData objectAtIndex:indexPath.row] objectForKey:@"categories"];
    price.text = [[currentHuddlData objectAtIndex:indexPath.row] objectForKey:@"price"];
    upLab.text = [[currentHuddlData objectAtIndex:indexPath.row] objectForKey:@"upVotes"];
    downLab.text = [[currentHuddlData objectAtIndex:indexPath.row] objectForKey:@"downVotes"];
    
    [cell addSubview:nameOf];
    [cell addSubview:ratingView];
    [cell addSubview:rating];
    [cell addSubview:categories];
    [cell addSubview:price];
    [cell addSubview:up];
    [cell addSubview:down];
    [cell addSubview:upLab];
    [cell addSubview:downLab];
    
    NSLog(@"%@", currentHuddlData);
    
    return cell;
}

- (void)upHit:(UIButton *)sender {
    [currentHuddlData removeAllObjects];
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
    [test7 setObject:@"1" forKey:@"upVotes"];
    [test7 setObject:@"0" forKey:@"downVotes"];
    
    [currentHuddlData addObject:test7];
    [currentHuddlData addObject:test1];
    [currentHuddlData addObject:test2];
    [currentHuddlData addObject:test3];
    [currentHuddlData addObject:test4];
    [currentHuddlData addObject:test5];
    [currentHuddlData addObject:test6];
    [self.tableView reloadData];
}

- (void)downHit:(UIButton *)sender {
    
    NSLog(@"HI");
    [currentHuddlData removeAllObjects];

    
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
    [currentHuddlData addObject:test7];
    
    [self.tableView reloadData];
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

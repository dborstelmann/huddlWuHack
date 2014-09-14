//
//  ParseStarterProjectViewController.m
//  ParseStarterProject
//
//  Copyright 2014 Parse, Inc. All rights reserved.
//

#import "ParseStarterProjectViewController.h"
#import "ParseStarterProjectAppDelegate.h"
#import "GroupTable.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@implementation ParseStarterProjectViewController

#pragma mark - UIViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];

}



- (IBAction)loginButtonTouchHandler:(id)sender  {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"public_profile", @"user_friends"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
                
                NSMutableDictionary *firstIds = [[NSMutableDictionary alloc] init];
                [firstIds setObject:@"empty" forKey:@"friendListKey"];
                [firstIds setObject:@"empty" forKey:@"groupListKey"];
                [user setObject:firstIds forKey:@"listOfObjects"];
                idList = [[NSMutableDictionary alloc] initWithDictionary:firstIds];
                [user saveInBackground];
                
            } else {
                NSLog(@"User with facebook logged in!");
                
                idList = [[NSMutableDictionary alloc] initWithDictionary:[user objectForKey:@"listOfObjects"]];
            }
            
            [self _presentHomeAnimated:YES];
        }
    }];
    
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}

- (void)_presentHomeAnimated:(BOOL)animated {
    GroupTable *viewController = [[GroupTable alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [nav.navigationBar setBarTintColor:UIColorFromRGB(huddlOrange)];
    [nav.navigationBar setTintColor:[UIColor whiteColor]];
    [nav.navigationBar setTranslucent:NO];
    [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:18],NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

//
//  LoginViewController.m
//  ApplozicSwiftObjcSample
//
//  Created by Sunil on 26/05/21.
//

#import "LoginViewController.h"
#import "ApplozicSwift-Swift.h"
#import "ViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userIdField;
@property (weak, nonatomic) IBOutlet UITextField *displayField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator setHidden:YES];
}

- (IBAction)login:(id)sender {

    if (self.userIdField.text.length == 0) {
        NSLog(@"UserId cant be empty");
        return;
    }

    if (self.passwordField.text.length == 0){
        NSLog(@"Password cant be empty");
        return;
    }
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    self.view.userInteractionEnabled = NO;

    // Calling Applozic login with userId, password and display name
    ALUser * user = [[ALUser alloc] init];
    [user setUserId:[self.userIdField text]];
    if (self.userIdField.text.length > 0) {
        [user setDisplayName:[self.displayField text]];
        [ALUserDefaultsHandler setDisplayName:[self.displayField text]];
    }

    [user setPassword:[self.passwordField text]];
    [user setAuthenticationTypeId:(short)APPLOZIC];
    [self.activityIndicator startAnimating];
    [ALUserDefaultsHandler setUserAuthenticationTypeId:(short)APPLOZIC];
    [ALUserDefaultsHandler setUserId:user.userId];
    [ALUserDefaultsHandler setPassword:user.password];

    [[ALChatManager shared] connectUser:user completion:^(ALRegistrationResponse * response, NSError * error) {
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
        self.view.userInteractionEnabled = YES;

        if (error){
            NSLog(@"Error in login to applozic %@", error.localizedDescription);
            return;
        }

        // Success launching a chat list screen

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
        ViewController *viewController = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:viewController];
        navVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:navVC
                           animated:YES
                         completion:nil];

    }];
}


@end

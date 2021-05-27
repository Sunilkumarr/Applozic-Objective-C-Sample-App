//
//  ViewController.m
//  ApplozicSwiftObjcSample
//
//  Created by apple on 26/05/21.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)launchConversations:(id)sender {
    [ALChatManager.shared launchChatListFrom:self];
}

- (IBAction)logout:(id)sender {
    [ALChatManager.shared logoutUserWithCompletion:^(BOOL sucess) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
}

@end

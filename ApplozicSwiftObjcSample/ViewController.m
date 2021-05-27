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
    self.chatManager = [[ALChatManager alloc] initWithApplicationKey:@"applozic-sample-app"];
}

- (IBAction)launchConversations:(id)sender {
    [self.chatManager launchChatListFrom:self];
}

- (IBAction)logout:(id)sender {
    [self.chatManager logoutUserWithCompletion:^(BOOL sucess) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
}

@end

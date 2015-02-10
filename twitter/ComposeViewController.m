//
//  ComposeViewController.m
//  twitter
//
//  Created by Sameer Shah on 2/9/15.
//  Copyright (c) 2015 Sameer Shah. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface ComposeViewController ()
@property (strong, nonatomic) IBOutlet UITextField *tweetTextView;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *twitterHandleLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweet)];
    self.user = [User currentUser];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    self.userNameLabel.text = self.user.name;
    self.twitterHandleLabel.text = self.user.screenName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTweet {
    NSString *status = self.tweetTextView.text;
    if (status.length > 0 && status.length <= 140) {
        [[TwitterClient sharedInstance] updateStatus:status completion:^(NSDictionary *response, NSError *error) {
        //<#code#>
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

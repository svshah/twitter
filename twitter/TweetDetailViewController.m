//
//  TweetDetailViewController.m
//  twitter
//
//  Created by Sameer Shah on 2/9/15.
//  Copyright (c) 2015 Sameer Shah. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Tweets.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"

@interface TweetDetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *twitterHandleLabel;
@property (strong, nonatomic) IBOutlet UILabel *tweetLabel;
@property (strong, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (strong, nonatomic) IBOutlet UILabel *retweetLabel;
@property (strong, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (strong, nonatomic) IBOutlet UIImageView *replyImageView;
@property (strong, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (strong, nonatomic) IBOutlet UIImageView *favoriteImageView;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReplyClick)];

    //populate all the view details
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.userNameLabel.text = self.tweet.user.name;
    self.twitterHandleLabel.text = self.tweet.user.screenName;
    self.tweetLabel.text = self.tweet.text;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy, HH:mm a"];
    self.createdAtLabel.text = [formatter stringFromDate:self.tweet.createdAt];
    self.retweetLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.retweetCount];
    self.favoriteLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.favoriteCount];
    
    
    [self.replyImageView setImageWithURL:[NSURL URLWithString:@"https://g.twimg.com/dev/documentation/image/reply.png"]];
    [self.replyImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *replyTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onReplyClick)];
    [replyTap setNumberOfTapsRequired:1];
    [self.replyImageView addGestureRecognizer:replyTap];
    
    
    [self.favoriteImageView setImageWithURL:[NSURL URLWithString:@"https://g.twimg.com/dev/documentation/image/favorite.png"]];
    [self.favoriteImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFavoriteClick)];
    [singleTap setNumberOfTapsRequired:1];
    [self.favoriteImageView addGestureRecognizer:singleTap];
    
    
    [self.retweetImageView setImageWithURL:[NSURL URLWithString:@"https://g.twimg.com/dev/documentation/image/retweet.png"]];
    [self.retweetImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *retweetTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRetweetClick)];
    [retweetTap setNumberOfTapsRequired:1];
    [self.retweetImageView addGestureRecognizer:retweetTap];
    
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

- (void)onHome {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onReplyClick {
    ComposeViewController *cv = [[ComposeViewController alloc] init];
    cv.replyText = [NSString stringWithFormat:@"@%@",self.tweet.user.screenName];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cv];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onFavoriteClick {
    [[TwitterClient sharedInstance]favoriteForId:self.tweet.id completion:^(NSDictionary *response, NSError *error) {
        if (response != nil) {
            NSLog(@"response=%@",response);
            self.tweet.favoriteCount++;
            self.favoriteLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.favoriteCount];
            [self.favoriteImageView setImageWithURL:[NSURL URLWithString:@"https://g.twimg.com/dev/documentation/image/favorite_on.png"]];
        }
    }];
}

- (void)onRetweetClick {
    [[TwitterClient sharedInstance]retweetForId:self.tweet.id completion:^(NSDictionary *response, NSError *error) {
        if (response != nil) {
            NSLog(@"response=%@",response);
            self.tweet.retweetCount++;
            self.retweetLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.retweetCount];
            [self.retweetImageView setImageWithURL:[NSURL URLWithString:@"https://g.twimg.com/dev/documentation/image/retweet_on.png"]];
        }
    }];
}

@end

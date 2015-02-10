//
//  ComposeViewController.h
//  twitter
//
//  Created by Sameer Shah on 2/9/15.
//  Copyright (c) 2015 Sameer Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ComposeViewController : UIViewController

@property (nonatomic, strong) User *user;
@property (strong, nonatomic) IBOutlet UITextField *tweetTextView;
@property (strong, nonatomic) NSString *replyText;

@end

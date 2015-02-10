//
//  TweetCell.h
//  twitter
//
//  Created by Sameer Shah on 2/8/15.
//  Copyright (c) 2015 Sameer Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweets.h"
#import "ComposeViewController.h"

@class TweetCell;

@protocol TweetCellDelegate <NSObject>

- (void) loadComposeViewController:(UINavigationController *) composeViewController didClickReply:(NSString *)handle;


@end

@interface TweetCell : UITableViewCell

@property (strong, nonatomic) Tweets *tweet;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;

@end

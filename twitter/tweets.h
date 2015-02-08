//
//  Tweets.h
//  twitter
//
//  Created by Sameer Shah on 2/7/15.
//  Copyright (c) 2015 Sameer Shah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweets : NSObject

@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSDate *createdAt;
@property (nonatomic,strong) User *user;

- (id) initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end

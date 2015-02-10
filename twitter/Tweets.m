//
//  Tweets.m
//  twitter
//
//  Created by Sameer Shah on 2/7/15.
//  Copyright (c) 2015 Sameer Shah. All rights reserved.
//

#import "Tweets.h"
#import "User.h"

@implementation Tweets

- (id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super self];
    
    if (self) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        self.createdAt = [formatter dateFromString:dictionary[@"created_at"]];
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
        self.id = [dictionary[@"id"] integerValue];
     }
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweetsArray = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweetsArray addObject:[[Tweets alloc] initWithDictionary:dictionary]];
    }
    return tweetsArray;
}

@end

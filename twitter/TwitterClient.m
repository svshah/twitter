//
//  TwitterClient.m
//  twitter
//
//  Created by Sameer Shah on 2/4/15.
//  Copyright (c) 2015 Sameer Shah. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweets.h"

NSString * const kTwitterConsumerKey = @"gDFp0OaRcLOydAf47C4IJ2R7N";
NSString * const kTwitterConsumerSecret = @"IvkKA5eyIs13BXdalYm3SfZnFKjjMpLQrfvUYqMqXJ4FguFPXO";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic,strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"sstwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"got the request token%@",requestToken.token);
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@",requestToken.token]];
        
        [[UIApplication sharedApplication] openURL:authURL];
    }  failure:^(NSError *error) {
        NSLog(@"Failed to get the request token");
        self.loginCompletion(nil, error);
        
    }];
}

- (void)openUrl:(NSURL *)url {
    
    [[TwitterClient sharedInstance] fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"Got the access token");
        [self.requestSerializer saveAccessToken:accessToken];
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response %@",responseObject);
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            self.loginCompletion(user, nil);
            NSLog(@"user name = %@", user.name);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed to get current user %@",error);
            self.loginCompletion(nil, error);
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the access token");
        self.loginCompletion(nil, error);
    }];

}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response %@",responseObject);
        NSArray *tweetsArray = [Tweets tweetsWithArray:responseObject];
        completion(tweetsArray, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        completion(nil, error);
    }];
}

- (void)updateStatus:(NSString *)status completion:(void (^)(NSDictionary *response , NSError *error))completion {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params  setObject:status forKey:@"status"];
    [self POST:@"1.1/statuses/update.json" parameters:params constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"tweet %@ composed",status);
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error %@",error);
        completion(nil,error);
    }];
}

@end

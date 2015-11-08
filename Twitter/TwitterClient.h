//
//  TwitterClient.h
//  Twitter
//
//  Created by Jim Challenger on 11/4/15.
//  Copyright © 2015 Jim Challenger. All rights reserved.
//

#import <BDBOAuth1RequestOperationManager.h>
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)publishTweetWithParams:(NSDictionary *)params completion:(void (^)(NSObject *tweet, NSError *error))completion;

@end

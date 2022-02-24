//
//  RudderSingularFactory.m
//  Pods-Rudder-Singular
//
//  Created by Abhishek Pandey on 07/07/21.
//

#import "RudderSingularFactory.h"
#import "RudderSingularIntegration.h"

@implementation RudderSingularFactory

+ (instancetype)instance {
    static RudderSingularFactory *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (nonnull NSString *)key {
    return @"Singular";
}

- (nonnull id<RSIntegration>)initiate:(nonnull NSDictionary *)config client:(nonnull RSClient *)client rudderConfig:(nonnull RSConfig *)rudderConfig {
    return [[RudderSingularIntegration alloc] initWithConfig:config withAnalytics:client];
}


@end

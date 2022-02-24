//
//  RudderSingularIntegration.m
//  Pods-Rudder-Singular
//
//  Created by Abhishek Pandey on 07/07/21.
//

#import "RudderSingularIntegration.h"

@implementation RudderSingularIntegration

- (instancetype)initWithConfig:(NSDictionary *)config withAnalytics:(RSClient *)client {
    self = [super init];
    if (self)
    {
        [RSLogger logDebug:@"Initializing Singular Factory"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (config == nil)
            {
                [RSLogger logError:@"Failed to Initialize Singular Factory as Config is null"];
            }
        });
    }
    return self;
}

- (void) processRudderEvent: (nonnull RSMessage *) message {
}


- (void)dump:(nonnull RSMessage *)message {
    @try
    {
        if (message != nil)
        {
            dispatch_async(dispatch_get_main_queue(),^{
                [self processRudderEvent:message];
            });
        }
    }
    @catch (NSException *ex)
    {
        [RSLogger logError:[[NSString alloc] initWithFormat:@"%@", ex]];
    }
}

- (void)reset {
    [RSLogger logDebug:@"Singular Factory doesn't support Reset Call"];
}

- (void)flush {
    
}

@end

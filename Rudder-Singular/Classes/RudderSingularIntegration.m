//
//  RudderSingularIntegration.m
//  Pods-Rudder-Singular
//
//  Created by Abhishek Pandey on 07/07/21.
//

#import "RudderSingularIntegration.h"
#import <Singular/Singular.h>
#import <Singular/SingularConfig.h>

static bool isSKANEnabled = NO;
static bool isManualMode = NO;
static void(^conversionValueUpdatedCallback)(NSInteger);
static int waitForTrackingAuthorizationWithTimeoutInterval = 0;
static bool isInitialized = NO;

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
                return;
            }
            
            NSString *apiKey = config[@"apiKey"];
            NSString *apiSecret = config[@"apiSecret"];

            if (!apiKey || !apiSecret){
               return;
            }
            
            SingularConfig* config = [[SingularConfig alloc] initWithApiKey:apiKey andSecret:apiSecret];
            
            config.skAdNetworkEnabled = isSKANEnabled;
            config.manualSkanConversionManagement = isManualMode;
            config.conversionValueUpdatedCallback = conversionValueUpdatedCallback;
            config.waitForTrackingAuthorizationWithTimeoutInterval = waitForTrackingAuthorizationWithTimeoutInterval;
            
            [Singular start:config];
            
            isInitialized = YES;
        });
    }
    return self;
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

- (void) processRudderEvent: (nonnull RSMessage *) message {
    NSString *type = message.type;
    if ([type isEqualToString:@"identify"])
    {
        if(message.userId && [message.userId length] > 0){
                [Singular setCustomUserId:message.userId];
        }
    }
    else if ([type isEqualToString:@"track"])
    {
        if (message.event) {
            NSMutableDictionary* eventProperties = [message.properties mutableCopy];
            if (eventProperties != NULL && [eventProperties count] > 0) {
                // If it is a revenue event
                if([eventProperties objectForKey:@"revenue"] &&
                   [[eventProperties objectForKey:@"revenue"] doubleValue] != 0) {
                    double revenue = [[eventProperties objectForKey:@"revenue"] doubleValue];
                    NSString* currency = @"USD";
                    if([eventProperties objectForKey:@"currency"]) {
                        currency = [eventProperties objectForKey:@"currency"];
                    }
                    [Singular customRevenue:message.event currency:currency amount:revenue];
                    return;
                }
                [Singular event:message.event withArgs:eventProperties];
                return;
            }
            [Singular event:message.event];
            return;
        }
        [RSLogger logDebug:@"Event name is not present."];
    }
    else if ([type isEqualToString:@"screen"])
    {
        if (message.event)
        {
            if (message.properties)
            {
                [Singular event:[NSString stringWithFormat:@"screen view %@", message.event] withArgs:message.properties];
                return;
            }
        }
        [RSLogger logDebug:@"Event name is not present."];
    }
    else
    {
        [RSLogger logDebug:@"Singular Integration: Message type is not supported"];
    }
}

- (void)reset {
    [Singular unsetCustomUserId];
    [RSLogger logDebug:@"Reset API is called."];
}

- (void)flush {
    [RSLogger logDebug:@"Singular Factory doesn't support Flush Call"];
}

+ (void)setSKANOptions:(BOOL)skAdNetworkEnabled isManualSkanConversionManagementMode:(BOOL)manualMode withWaitForTrackingAuthorizationWithTimeoutInterval:(NSNumber* _Nullable)waitTrackingAuthorizationWithTimeoutInterval withConversionValueUpdatedHandler:(void(^_Nullable)(NSInteger))conversionValueUpdatedHandler {
    if (isInitialized) {
        NSLog(@"Singular Warning: setSKANOptions should be called before init");
    }

    isSKANEnabled = skAdNetworkEnabled;
    isManualMode = manualMode;
    conversionValueUpdatedCallback = conversionValueUpdatedHandler;
    waitForTrackingAuthorizationWithTimeoutInterval = waitTrackingAuthorizationWithTimeoutInterval ? [waitTrackingAuthorizationWithTimeoutInterval intValue] : 0;
}

@end

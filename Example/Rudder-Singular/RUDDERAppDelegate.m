//
//  RUDDERAppDelegate.m
//  Rudder-Singular
//
//  Created by Abhishek on 07/07/2021.
//  Copyright (c) 2019 arnab. All rights reserved.
//

#import "RUDDERAppDelegate.h"
#import <Rudder/Rudder.h>
#import <RudderSingularFactory.h>
#import <RudderSingularIntegration.h>

@implementation RUDDERAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSString *writeKey = @"<WRITE_KEY>";
    NSString *dataPlaneUrl = @"<DATA_PLANE_URL>";

    [RudderSingularIntegration setSKANOptions:YES
         isManualSkanConversionManagementMode:YES
withWaitForTrackingAuthorizationWithTimeoutInterval:@0
            withConversionValueUpdatedHandler:^(NSInteger conversionValue){
        // Receive a callback whenever the Conversion Value is updated
        NSLog(@"Your SKAN handler %ld",conversionValue);
    }];
  
    RSConfigBuilder *configBuilder = [[RSConfigBuilder alloc] init];
    [configBuilder withDataPlaneUrl:dataPlaneUrl];
    [configBuilder withLoglevel:RSLogLevelNone];
    [configBuilder withControlPlaneUrl:@"<CONTROL_PLANE_URL>"];
    [configBuilder withFactory:[RudderSingularFactory instance]];
    [configBuilder withTrackLifecycleEvens:NO];
    [RSClient getInstance:writeKey config:[configBuilder build]];
    
    [self makeEvents];
    
//    NSLog(@"%@",[self identifierForVendor]);
    return YES;
}

-(void) makeEvents {
    [self identifyEvent];
    [self revenueEvent];
    [self trackEventWithProperties];
    [self trackEventWithoutProperties];
    [self screenEventsWithProperties];
    [self screenEventsWithoutProperties];
}

-(void) identifyEvent {
    [[RSClient getInstance] identify:@"iOS User"];
}

-(void) revenueEvent {
    [[RSClient getInstance] track:@"Order Completed" properties:@{
        @"revenue" : @123,
        @"currency" : @"INR"
    }];
}

-(void) trackEventWithProperties {
    [[RSClient sharedInstance] track:@"Checkout Started" properties:@{
        @"orderId" : @"199",
        @"currency" : @"USD",
        @"products" : @[
                @{
                    @"productId" : @"4011",
                    @"name": @"Shirt",
                    @"price" : @12,
                    @"quantity" : @1
                },
                @{
                    @"product_id" : @"4012",
                    @"name": @"short",
                    @"price" : @21,
                    @"quantity" : @3
                }
        ]
    }];
}

-(void) trackEventWithoutProperties {
    [[RSClient getInstance] track:@"Custom Event"];
}

-(void) screenEventsWithProperties {
    [[RSClient getInstance] screen:@"Main Screen" properties:@{
        @"width" : @5,
        @"pixels" : @"1080p"
    }];
}

-(void) screenEventsWithoutProperties {
    [[RSClient getInstance] screen:@"Home Screen"];
}

// Needed only for testing: This IDFV key needs to be registered at Singular for testing the setup
- (NSString *)identifierForVendor {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

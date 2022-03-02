//
//  RudderSingularIntegration.h
//  Pods-Rudder-Singular
//
//  Created by Abhishek Pandey on 07/07/21.
//

#import <Foundation/Foundation.h>
#import <Rudder/Rudder.h>



NS_ASSUME_NONNULL_BEGIN

@interface RudderSingularIntegration : NSObject<RSIntegration>


- (instancetype)initWithConfig:(NSDictionary *)config withAnalytics:(RSClient *)client;
+ (void)setSKANOptions:(BOOL)skAdNetworkEnabled isManualSkanConversionManagementMode:(BOOL)manualMode withWaitForTrackingAuthorizationWithTimeoutInterval:(NSNumber* _Nullable)waitTrackingAuthorizationWithTimeoutInterval withConversionValueUpdatedHandler:(void(^_Nullable)(NSInteger))conversionValueUpdatedHandler;

@end

NS_ASSUME_NONNULL_END

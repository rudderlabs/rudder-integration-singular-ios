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

@end

NS_ASSUME_NONNULL_END

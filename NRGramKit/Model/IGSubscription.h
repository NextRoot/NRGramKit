//
//  Subscription.h
//  Instamap
//
//  Created by Raul Andrisan on 5/8/11.
//  Copyright (c) 2011 NextRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface IGSubscription : NSObject<NSCoding> {
@private
}

@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSString * object;
@property (nonatomic, retain) NSString * Id;
@property (nonatomic, retain) NSString * object_id;
@property (nonatomic, retain) NSString * aspect;
@property (nonatomic, retain) NSString * callback_url;



+(IGSubscription*)subscriptionWithDictionary:(NSDictionary*)dict;
+(IGSubscription*)subscriptionFor:(NSString*)object withId:(NSString*)Id name:(NSString*)name;

@end

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
@property (nonatomic, retain) NSString * object;
@property (nonatomic, retain) NSString * Id;
@property (nonatomic, retain) NSString * geographyId;
@property (nonatomic, retain) NSString * object_name;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSNumber * isEnabled;
@property (assign) int mediaCount;
@property (assign) BOOL isSelected;
@property (retain) NSString* maxTagId;
@property (retain) NSString* minTagId;
@property (readonly) NSMutableArray* currentMedia;
@property (assign) BOOL loadedAllMedia;
@property (readonly) NSString* key;

+(IGSubscription*)subscriptionFor:(NSString*)object withId:(NSString*)Id name:(NSString*)name;

@end

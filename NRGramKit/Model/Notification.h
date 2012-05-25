//
//  Notification.h
//  Instamap
//
//  Created by Raul Andrisan on 3/27/11.
//  Copyright 2011 NextRoot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Notification : NSObject {
    
}
@property (nonatomic,retain) NSString* changed_aspect;
@property (nonatomic,retain) NSString* object;
@property (nonatomic,retain) NSString* object_id;
@property (nonatomic,retain) NSString* subscription_id;
@property (nonatomic,retain) NSString* time;
-initWithDictionary:(NSDictionary*)dict;
@end

//
//  Notification.m
//  Instamap
//
//  Created by Raul Andrisan on 3/27/11.
//  Copyright 2011 NextRoot. All rights reserved.
//

#import "Notification.h"


@implementation Notification
@synthesize time,object,object_id,changed_aspect,subscription_id;

- initWithDictionary:(NSDictionary*)dict
{
    if((self=[super init]))
    {
        self.time = [dict objectForKey:@"time"];
        self.changed_aspect = [dict objectForKey:@"changed_aspect"]; 
        self.object = [dict objectForKey:@"object"]; 
        self.object_id = [dict objectForKey:@"object_id"]; 
        self.subscription_id = [dict objectForKey:@"subscription_id"]; 
    }
    return self;
}

@end

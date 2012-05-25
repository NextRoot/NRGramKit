//
//  Subscription.m
//  Instamap
//
//  Created by Raul Andrisan on 5/8/11.
//  Copyright (c) 2011 NextRoot. All rights reserved.
//

#import "IGSubscription.h"

@implementation IGSubscription
@synthesize radius;
@synthesize object;
@synthesize Id;
@synthesize geographyId;
@synthesize object_name;
@synthesize lat;
@synthesize lng;
@synthesize isEnabled;
@synthesize mediaCount,isSelected,maxTagId,minTagId,currentMedia,loadedAllMedia;

- (id)init
{
    self = [super init];
    if(self!=nil)
    {
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.radius forKey:@"radius"];
    [encoder encodeObject:self.object forKey:@"object"];
        [encoder encodeObject:self.Id forKey:@"Id"];
        [encoder encodeObject:self.geographyId forKey:@"geographyId"];
        [encoder encodeObject:self.object_name forKey:@"object_name"];
        [encoder encodeObject:self.lat forKey:@"lat"];
        [encoder encodeObject:self.lng forKey:@"lng"];    
}

- (id)initWithCoder:(NSCoder *)decoder {

    self = [super init];
    if(self)
    {
        self.object =[decoder decodeObjectForKey:@"object"];
        self.object_name = [decoder decodeObjectForKey:@"object_name"];
        self.Id= [decoder decodeObjectForKey:@"Id"];
        self.geographyId = [decoder decodeObjectForKey:@"geographyId"];
        self.lat = [decoder decodeObjectForKey:@"lat"];
        self.lng = [decoder decodeObjectForKey:@"lng"];
        self.radius = [decoder decodeObjectForKey:@"radius"];
    }
    
    return self;
}

+ (IGSubscription *)subscriptionFor:(NSString*)object withId:(NSString*)Id name:(NSString*)name
{
    IGSubscription* sub = [[IGSubscription alloc]init];
    
    sub.object = object;
    sub.Id = Id;
    sub.object_name = name;
    sub.isEnabled = [NSNumber numberWithBool:YES];
    
    return sub;
}

- (NSMutableArray *)currentMedia
{
    NSMutableArray* arr = nil;
    NSString* key = [NSString stringWithFormat:@"%@-%@",self.object,self.Id];
//    arr = [[InstagramSubscriptionManager sharedInstance].subscriptionMedia objectForKey:key];
//    if(arr==nil)
//    {
//        arr = [[NSMutableArray alloc]init];
//        [[InstagramSubscriptionManager sharedInstance].subscriptionMedia setObject:arr forKey:key];
//        [arr release];
//    }
    return arr;
}

- (NSString *)key
{
    return [NSString stringWithFormat:@"%@-%@",self.object,self.Id];
}

@end

//
//  Subscription.m
//  Instamap
//
//  Created by Raul Andrisan on 5/8/11.
//  Copyright (c) 2011 NextRoot. All rights reserved.
//

#import "IGSubscription.h"

@implementation IGSubscription

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
    [encoder encodeObject:self.lat forKey:@"lat"];
    [encoder encodeObject:self.lng forKey:@"lng"];
    [encoder encodeObject:self.object forKey:@"object"];
    [encoder encodeObject:self.Id forKey:@"Id"];
    [encoder encodeObject:self.object_id forKey:@"object_id"];
    [encoder encodeObject:self.aspect forKey:@"aspect"];
    [encoder encodeObject:self.callback_url forKey:@"callback_url"];
}

- (id)initWithCoder:(NSCoder *)decoder {

    self = [super init];
    if(self)
    {
        self.lat = [decoder decodeObjectForKey:@"lat"];
        self.lng = [decoder decodeObjectForKey:@"lng"];
        self.radius = [decoder decodeObjectForKey:@"radius"];
        self.object =[decoder decodeObjectForKey:@"object"];
        self.object_id = [decoder decodeObjectForKey:@"object_id"];
        self.Id= [decoder decodeObjectForKey:@"Id"];
        self.aspect = [decoder decodeObjectForKey:@"aspect"];
        self.callback_url = [decoder decodeObjectForKey:@"callback_url"];
    }
    
    return self;
}

+(IGSubscription *)subscriptionWithDictionary:(NSDictionary *)dict
{
    IGSubscription* sub = [[IGSubscription alloc]init];
    
    sub.aspect = dict[@"aspect"];
    sub.callback_url = dict[@"callback_url"];
    sub.Id = dict[@"id"];
    sub.object = dict[@"object"];
    sub.object_id = [dict[@"object_id"] isKindOfClass:[NSNull class]]?nil:dict[@"object_id"];
    
    return sub;

}

+ (IGSubscription *)subscriptionFor:(NSString*)object withId:(NSString*)Id name:(NSString*)name
{
    IGSubscription* sub = [[IGSubscription alloc]init];
    
    sub.object = object;
    sub.Id = Id;
    sub.object_id = name;
    
    return sub;
}


-(NSString *)description
{
    return [NSString stringWithFormat:@"subscription - %@ - %@ - %@",self.Id,self.object,self.object_id];
}

@end

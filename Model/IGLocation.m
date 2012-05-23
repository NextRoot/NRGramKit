//
//  IGLocation.m
//  Instamap
//
//  Created by Raul Andrisan on 6/26/11.
//  Copyright 2011 NextRoot. All rights reserved.
//

#import "IGLocation.h"


@implementation IGLocation
@synthesize Id,name,latitude,longitude;
+(IGLocation*)locationWithDictionary:(NSDictionary*)dict
{
    IGLocation* location = [[IGLocation alloc]init];    
    if([[dict objectForKey:@"id"] isKindOfClass:[NSString class]])
    {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * myNumber = [f numberFromString:[dict objectForKey:@"id"]];
        location.Id = myNumber;
    }
    else
    {
        location.Id = [dict objectForKey:@"id"];
    }
    
    
    location.name = [dict objectForKey:@"name"];
    location.longitude = [dict objectForKey:@"longitude"];
    location.latitude = [dict objectForKey:@"latitude"];
    return location;
    
}
@end

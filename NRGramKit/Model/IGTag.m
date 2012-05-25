//
//  IGTag.m
//  Instamap
//
//  Created by Raul Andrisan on 6/26/11.
//  Copyright 2011 NextRoot. All rights reserved.
//

#import "IGTag.h"


@implementation IGTag
@synthesize name,mediaCount;
+(IGTag*)tagWithDictionary:(NSDictionary*)dict
{
    IGTag* tag = [[IGTag alloc]init];
    
    
    tag.mediaCount = [dict objectForKey:@"media_count"];
    tag.name = [dict objectForKey:@"name"];
    
    return tag;
}
+(IGTag*)tagWithString:(NSString*)atag;
{
   
    IGTag* tag = [[IGTag alloc]init];    
    
    tag.mediaCount = [NSNumber numberWithInt:0];
    tag.name = atag;
    
    return tag;
    
}
@end

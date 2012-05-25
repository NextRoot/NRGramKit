//
//  IGComment.m
//  Instamap
//
//  Created by Raul Andrisan on 6/26/11.
//  Copyright 2011 NextRoot. All rights reserved.
//

#import "IGComment.h"


@implementation IGComment
@synthesize Id,from,text,createdTime,mediaId;
+(IGComment*)commentWithDictionary:(NSDictionary*)dict
{
    IGComment* comment = [[IGComment alloc]init];
    
    comment.createdTime = [dict objectForKey:@"created_time"];
    comment.text = [dict objectForKey:@"text"];
    comment.from = [IGUser userWithDictionary:[dict objectForKey:@"from"]];
    comment.Id = [dict objectForKey:@"id"];
    
    return comment;
}
@end

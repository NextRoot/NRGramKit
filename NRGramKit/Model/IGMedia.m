//
//  IGMedia.m
//  Instamap
//
//  Created by Raul Andrisan on 6/26/11.
//  Copyright 2011 NextRoot. All rights reserved.
//

#import "IGMedia.h"

@implementation IGMedia
@synthesize Id,link,tags,type,user,image,likes,filter,caption,section,comments,location,likes_count,created_time,userHasLiked,comment_count,received_time;

+(IGMedia*)mediaWithDictionary:(NSDictionary*)dict
{
    
    IGMedia* media = [[IGMedia alloc]init];
    
    media.Id = [dict objectForKey:@"id"];
    media.type = [dict objectForKey:@"type"];
    media.filter = [dict objectForKey:@"filter"];
    media.link = [dict objectForKey:@"link"];
    
    media.created_time = [dict objectForKey:@"created_time"];
    
    if([media.received_time longValue]==0)
        media.received_time = [NSNumber numberWithLong:(long)[[NSDate date] timeIntervalSince1970]];
    
    media.image = [IGImage imageWithDictionary:[dict objectForKey:@"images"]];
    media.user = [IGUser userWithDictionary:[dict objectForKey:@"user"]];
    
    NSMutableArray* tagArray = [[NSMutableArray alloc]init];
    for(NSString* tagString in [dict objectForKey:@"tags"])
    {
        [tagArray addObject:[IGTag tagWithString:tagString]];
    }
    media.tags = tagArray;
    
    if([dict objectForKey:@"likes"]!=nil)
    {
        NSDictionary* likesDict = [dict objectForKey:@"likes"];
        media.likes_count =  [likesDict objectForKey:@"count"];
        
//        NSArray* likesArray =[dict objectForKey:@"data"];
//        NSMutableArray* likeArray = [[[NSMutableArray alloc]init] autorelease];
//        for (NSDictionary* likeDict in likesArray) {
//            [likeArray addObject:[IGUser userWithDictionary:likeDict]];
//        }
//        media.likes = likeArray;
    }
    
    if([dict objectForKey:@"comments"]!=[NSNull null])
    {
        NSDictionary* commentsDict = [dict objectForKey:@"comments"];
        media.comment_count =  [commentsDict objectForKey:@"count"];
//        NSArray* commentsArray =[dict objectForKey:@"data"];
//        NSMutableArray* commArray = [[[NSMutableArray alloc]init] autorelease];
//        for (NSDictionary* commDict in commentsArray) {
//            [commArray addObject:[IGUser userWithDictionary:commDict]];
//        }
//        media.comments = commArray;
    }
    
    if([dict objectForKey:@"location"]!=[NSNull null])
        media.location = [IGLocation locationWithDictionary:[dict objectForKey:@"location"]];
    
    if([dict objectForKey:@"caption"]!=[NSNull null])
        media.caption= [IGComment commentWithDictionary:[dict objectForKey:@"caption"]];
    
    if([dict objectForKey:@"user_has_liked"]!=nil)
        media.userHasLiked = [dict objectForKey:@"user_has_liked"];
    
    
    return media;
}

@end

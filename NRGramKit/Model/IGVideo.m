//
//  IGVideo.m
//  NRGramKit
//
//  Created by shiami on 12/11/13.
//  Copyright (c) 2013 NextRoot. All rights reserved.
//

#import "IGVideo.h"

@implementation IGVideo
+(IGVideo *)videoWithDictionary:(NSDictionary *)dict
{
    IGVideo* video = [[IGVideo alloc]init];
    NSDictionary* thumbnailDictionary = [dict objectForKey:@"thumbnail"];
    NSDictionary* standardDictionary = [dict objectForKey:@"standard_resolution"];
    NSDictionary* lowDictionary = [dict objectForKey:@"low_resolution"];
    
    video.low_resolution =[lowDictionary objectForKey:@"url"];
    video.standard_resolution =[standardDictionary objectForKey:@"url"];
    video.thumbnail =[thumbnailDictionary objectForKey:@"url"];
    
    return video;
}
@end

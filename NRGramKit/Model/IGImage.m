//
//  IGImage.m
//  Instamap
//
//  Created by Raul Andrisan on 6/26/11.
//  Copyright 2011 NextRoot. All rights reserved.
//

#import "IGImage.h"

@implementation IGImage
@synthesize thumbnail,low_resolution,standard_resolution,preferedThumbnail;
+(IGImage*)imageWithDictionary:(NSDictionary*)dict
{
    IGImage* image = [[IGImage alloc]init];
    NSDictionary* thumbnailDictionary = [dict objectForKey:@"thumbnail"];
    NSDictionary* standardDictionary = [dict objectForKey:@"standard_resolution"];
    NSDictionary* lowDictionary = [dict objectForKey:@"low_resolution"];
    
    image.low_resolution =[lowDictionary objectForKey:@"url"];
    image.standard_resolution =[standardDictionary objectForKey:@"url"];
    image.thumbnail =[thumbnailDictionary objectForKey:@"url"];
    
    return image;
}

-(NSString *)preferedThumbnail
{
    return self.thumbnail;
//    if([InstagramSubscriptionManager sharedInstance].isUsingHighQualityImages)
//    {
//        return self.low_resolution;
//    }
//    else
//    {
//        return self.thumbnail;
//    }
}
@end

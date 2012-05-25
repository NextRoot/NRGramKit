//
//  IGMedia.h
//  Instamap
//
//  Created by Raul Andrisan on 6/26/11.
//  Copyright 2011 NextRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGComment.h"
#import "IGImage.h"
#import "IGLocation.h"
#import "IGUser.h"
#import "IGTag.h"

@interface IGMedia : NSObject {
    
}
@property (nonatomic, retain) NSNumber * comment_count;
@property (nonatomic, retain) NSString * Id;
@property (nonatomic, retain) NSString * created_time;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * userHasLiked;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * filter;
@property (nonatomic, retain) NSNumber * likes_count;
@property (nonatomic, retain) NSNumber * received_time;
@property (nonatomic, retain) NSNumber * section;
@property (nonatomic, retain) NSArray* comments;
@property (nonatomic, retain) IGComment * caption;
@property (nonatomic, retain) NSArray* tags;
@property (nonatomic, retain) NSArray* likes;
@property (nonatomic, retain) IGImage * image;
@property (nonatomic, retain) IGLocation * location;
@property (nonatomic, retain) IGUser * user;
+(IGMedia*)mediaWithDictionary:(NSDictionary*)dict;
@end

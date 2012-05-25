//
//  IGComment.h
//  Instamap
//
//  Created by Raul Andrisan on 6/26/11.
//  Copyright 2011 NextRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGUser.h"

@interface IGComment : NSObject {
    
}
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * createdTime;
@property (nonatomic, retain) NSString * Id;
@property (nonatomic, retain) IGUser * from;
@property (nonatomic,retain) NSString* mediaId;

+(IGComment*)commentWithDictionary:(NSDictionary*)dict;
@end

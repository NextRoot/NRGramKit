//
//  IGTag.h
//  Instamap
//
//  Created by Raul Andrisan on 6/26/11.
//  Copyright 2011 NextRoot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IGTag : NSObject {
    
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * mediaCount;
+(IGTag*)tagWithDictionary:(NSDictionary*)dict;
+(IGTag*)tagWithString:(NSString*)tag;

@end

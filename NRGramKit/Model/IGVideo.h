//
//  IGVideo.h
//  NRGramKit
//
//  Created by shiami on 12/11/13.
//  Copyright (c) 2013 NextRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGVideo : NSObject {
    
}

@property (nonatomic, retain) NSString * low_resolution;
@property (nonatomic, retain) NSString * standard_resolution;
@property (nonatomic, retain) NSString * thumbnail;
+(IGVideo*)videoWithDictionary:(NSDictionary*)dict;

@end

//
//  IGPagination.h
//  Instamap
//
//  Created by Raul Andrisan on 11/17/11.
//  Copyright (c) 2011 NextRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGPagination : NSObject

@property (retain) NSString* nextMaxId;
@property (retain) NSString* nextMinId;
@property (retain) NSString* nextUrl;

+(IGPagination*)paginationWithDictionary:(NSDictionary*)dict;

@end

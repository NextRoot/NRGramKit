//
//  InstagramEngine.h
//  Instamap
//
//  Created by Raul Andrisan on 12/16/11.
//  Copyright (c) 2011 NextRoot. All rights reserved.
//
#import "AFNetworking.h"

@interface InstagramEngine:NSObject


typedef void (^InstagramBodyResponseBlock)(NSDictionary* body);

+(InstagramEngine*)sharedEngine;

-(AFJSONRequestOperation*)bodyForPath:(NSString*)path
                                 verb:(NSString*)verb
                                 body:(NSMutableDictionary*)body
                         onCompletion:(InstagramBodyResponseBlock) completionBlock
                              onError:(void (^)( NSError *error)) errorBlock;

@end

//
//  InstagramEngine.m
//  Instamap
//
//  Created by Raul Andrisan on 12/16/11.
//  Copyright (c) 2011 NextRoot. All rights reserved.
//

#import "InstagramEngine.h"
#define BASE_URL @"https://api.instagram.com"


@implementation InstagramEngine

InstagramEngine* _sharedIGEngine;

+(InstagramEngine*)sharedEngine
{
    if(_sharedIGEngine==nil)
    {
        _sharedIGEngine = [[InstagramEngine alloc] init];
    }
    return _sharedIGEngine;
}


-(AFJSONRequestOperation*)bodyForPath:(NSString*)path
                             verb:(NSString*)verb 
                             body:(NSMutableDictionary*)body
                     onCompletion:(InstagramBodyResponseBlock) completionBlock
                          onError:(void (^)( NSError *error)) errorBlock
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,path]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:verb];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        errorBlock(error);
    }];
    [op start];
    
    return op;   
}

@end

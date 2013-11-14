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


-(AFHTTPRequestOperation*)bodyForPath:(NSString*)path
                             verb:(NSString*)verb 
                             body:(NSMutableDictionary*)body
                     onCompletion:(InstagramBodyResponseBlock) completionBlock
                          onError:(void (^)( NSError *error)) errorBlock
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,path]];
    
    AFHTTPClient* client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest* request = [client requestWithMethod:verb path:path parameters:body];
    
    
    AFHTTPRequestOperation* operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError* error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        completionBlock(object);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(error);
    }];

    

    [client enqueueHTTPRequestOperation:operation];
    
    return operation;
}

@end

//
//  InstagramEngine.m
//  Instamap
//
//  Created by Raul Andrisan on 12/16/11.
//  Copyright (c) 2011 NextRoot. All rights reserved.
//

#import "InstagramEngine.h"
#import "JSONKit.h"

@implementation InstagramEngine

InstagramEngine* _sharedEngine;

+(InstagramEngine*)sharedEngine
{
    if(_sharedEngine==nil)
    {
        _sharedEngine = [[InstagramEngine alloc] initWithHostName:@"api.instagram.com" customHeaderFields:nil];
    }
    return _sharedEngine;
}

-(MKNetworkOperation*)bodyForPath:(NSString*)path 
                             verb:(NSString*)verb 
                             body:(NSMutableDictionary*)body
                     onCompletion:(InstagramBodyResponseBlock) completionBlock
                          onError:(MKNKErrorBlock) errorBlock
{
    MKNetworkOperation *op = [self operationWithPath:path
                                              params:body 
                                          httpMethod:verb
                                                 ssl:YES];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation)
     {
         // the completionBlock will be called twice. 
         // if you are interested only in new values, move that code within the else block
         
         if(![completedOperation isCachedResponse])
         {
             NSString *valueString = [completedOperation responseString];       
             completionBlock([valueString objectFromJSONString]);
         }
         
     }onError:^(NSError* error) {
         
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;   
}

@end

//
//  IGMetadata.m
//  Instamap
//
//  Created by Raul Andrisan on 3/23/11.
//  Copyright 2011 NextRoot. All rights reserved.
//

#import "IGMetadata.h"


@implementation IGMetadata
@synthesize code,error_type,error_message;
+(IGMetadata*)metadataWithDictionary:(NSDictionary*)dict
{
    IGMetadata* metadata = [[IGMetadata alloc] init];
       
    metadata.code = [dict objectForKey:@"code"];
    metadata.error_message = [dict objectForKey:@"error_message"]; 
    metadata.error_type = [dict objectForKey:@"error_type"]; 
   
    return metadata;
}
@end

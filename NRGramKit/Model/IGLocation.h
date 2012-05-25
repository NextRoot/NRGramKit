//
//  IGLocation.h
//  Instamap
//
//  Created by Raul Andrisan on 6/26/11.
//  Copyright 2011 NextRoot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IGLocation : NSObject {
    
}
@property (nonatomic, retain) NSNumber * Id;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
+(IGLocation*)locationWithDictionary:(NSDictionary*)dict;
@end

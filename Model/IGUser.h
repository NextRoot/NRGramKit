//
//  IGUser.h
//  Instamap
//
//  Created by Raul Andrisan on 6/26/11.
//  Copyright 2011 NextRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGUser : NSObject<NSCoding> {
    
}
@property (nonatomic, retain) NSString * full_name;
@property (nonatomic, retain) NSNumber * media_count;
@property (nonatomic, retain) NSString * Id;
@property (nonatomic, retain) NSNumber * followed_by_count;
@property (nonatomic, retain) NSString * profile_picture;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSNumber * follows_count;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSString * website;

+(IGUser*)userWithDictionary:(NSDictionary*)dict;
@end

//
//  Instagram.h
//  Instamap
//
//  Created by Raul Andrisan on 3/21/11.
//  Copyright 2011 NextRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGMetadata.h"
#import "Notification.h"
#import "IGUser.h"
#import "IGMedia.h"
#import "IGTag.h"
#import "IGComment.h"
#import "IGLocation.h"
#import "IGImage.h"
#import "IGPagination.h"
#import "IGSubscription.h"


typedef void (^UserResultBlock)(IGUser*);
typedef void (^MediaResultBlock)(IGMedia*);
typedef void (^LocationResultBlock)(IGLocation*);
typedef void (^SubscriptionsResultBlock)(NSArray* subscriptions);
typedef void (^SubscriptionResultBlock)(IGSubscription* subscription);
typedef void (^TagResultBlock)(IGTag*);
typedef void (^UserArrayResultBlock)(NSArray*);
typedef void (^CommentArrayResultBlock)(NSArray*,IGPagination*);
typedef void (^MediaArrayResultBlock)(NSArray*,IGPagination*);
typedef void (^LocationArrayResultBlock)(NSArray*);
typedef void (^TagArrayResultBlock)(NSArray*);
typedef void (^PaginationDictionaryResultBlock)(IGPagination*,NSDictionary*);
typedef void (^PaginationDataMetaResultBlock)(NSDictionary*,NSDictionary*,NSDictionary*);
typedef void (^SubscriptionArrayResultBlock)(NSArray*);
typedef void (^LoginResultBlock)(IGUser* user,NSString* error);
typedef void (^OperationSuccessBlock)(BOOL);
typedef void (^LoginLoadingBlock)(BOOL);

typedef enum {
    IGIncomingRelationshipFollowedBy,
    IGIncomingRelationshipRequestedBy,
    IGIncomingRelationshipBlockedByYou,
    IGIncomingRelationshipNone
} IGIncomingRelationshipStatus;

typedef enum {
    IGOutgoingRelationshipFollows,
    IGOutgoingRelationshipRequested,
    IGOutgoingRelationshipNone
} IGOutgoingRelationshipStatus;

typedef enum {
    IGSubscriptionTypeUsers,
    IGSubscriptionTypeLocation,
    IGSubscriptionTypeTag,
    IGSubscriptionTypeGeography,
    IGSubscriptionTypeAll
} IGSubscriptionType;

typedef enum {
    IGRelationshipActionFollow,
    IGRelationshipActionUnfollow,
    IGRelationshipActionBlock,
    IGRelationshipActionUnblock,
    IGRelationshipActionApprove,
    IGRelationshipActionDeny
} IGRelationshipAction;

typedef void(^RelationshipResultBlock)(IGIncomingRelationshipStatus,IGOutgoingRelationshipStatus);



@interface NRGramKit : NSObject {
}
+(BOOL) isLoggedIn;
+(IGUser*) loggedInUser;
+(void)loginInWebView:(UIWebView*)webview loginLoadingCallback:(LoginLoadingBlock)loadingCallback finishedCallback:(LoginResultBlock)callback;
+(void)logout;
+(void)getUrl:(id)url withCallback:(PaginationDictionaryResultBlock)callback;
+(void)getUrl:(id)url withCompleteCallback:(PaginationDataMetaResultBlock)callback;
+(void)setAccessToken:(NSString*)accessToken;

+(void)getUserWithId:(NSString*)Id withCallback: (UserResultBlock)callback;
+(void)getUserWithName:(NSString*)name limit:(int)limit withCallback: (UserArrayResultBlock)callback;
+(void)getUserWithName:(NSString*)name withCallback: (UserArrayResultBlock)callback;

+(void)getUsersWhoFollowUserWithId:(NSString*)Id count:(int)count withCallback: (UserArrayResultBlock)callback;
+(void)getUsersFollowingUserWithId:(NSString*)Id count:(int)count withCallback: (UserArrayResultBlock)callback;
+(void)getRelationshipWithUser:(NSString*)Id withCallback:(RelationshipResultBlock)callback;
+(void)postRelationship:(IGRelationshipAction)action withUser:(NSString*)Id withCallback:(OperationSuccessBlock)callback;

+(void)getMediaInUserFeedWithCallback: (MediaArrayResultBlock)callback;
+(void)getMediaInUserFeedWithCount:(int)count maxId:(NSString*)maxId minId:(NSString*)minId withCallback: (MediaArrayResultBlock)callback;

+(void)getMediaInUserLikedCount:(int)count withCallback:(MediaArrayResultBlock)callback;
+(void)getMediaInUserLikedCount:(int)count maxLikeId:(NSString*)maxLikeId withCallback:(MediaArrayResultBlock)callback;
+(void)getMediaRecentInUserWithId:(NSString*)Id count:(int)count minId:(NSString*)minId maxId:(NSString*)maxId minTimestamp:(NSDate*)minTimestamp maxTimestamp:(NSDate*)maxTimestamp withCallback:(MediaArrayResultBlock)callback;
+(void)getMediaRecentInLocationWithId:(NSString*)Id count:(int)count minId:(NSString*)minId maxId:(NSString*)maxId minTimestamp:(NSDate*)minTimestamp maxTimestamp:(NSDate*)maxTimestamp withCallback:(MediaArrayResultBlock)callback;

+(void)getMediaRecentInTagWithName:(NSString*)name count:(int)count maxTagId:(NSString*)maxTagId minTagId:(NSString*)minTagId withCallback:(MediaArrayResultBlock)callback;
+(void)getMediaRecentInGeographyWithId:(NSString*)Id count:(int)count
     withCallback:(MediaArrayResultBlock)callback;
+(void)getMediaWithId:(NSString*)Id withCallback: (MediaResultBlock)callback;
+(void)getMediaSearchAtLatitude:(double)lat longitude:(double)lng radius:(int)radius count:(int)count earlierThan:(NSDate*)earlierDate laterThen:(NSDate*)laterDate withCallback:  (MediaArrayResultBlock)callback;
+(void)getMediaPopularCount:(int)count withCallback:(MediaArrayResultBlock)callback;

+(void)getLocationWithId:(NSString*)Id withCallback: (LocationResultBlock)callback;
+(void)getLocationsSearchAtLatitude:(double)lat longitude:(double)lng radius:(int)radius withCallback: (LocationArrayResultBlock)callback;

+(void)getTagWithName:(NSString*)name withCallback: (TagResultBlock)callback;
+(void)getTagSearchWithName:(NSString*)name withCallback: (TagArrayResultBlock)callback;

+(void)getCommentsInMediaWithId:(NSString*)mediaId count:(int)count withCallback:(CommentArrayResultBlock)callback;
+(void)postComment:(NSString*)message inMediaWithId:(NSString*)mediaId withCallback:(OperationSuccessBlock)callback;
+(void)removeCommentWithId:(NSString*)commentId inMediaWithId:(NSString*)mediaId withCallback:(OperationSuccessBlock)callback;

+(void)getLikesInMediaWithId:(NSString*)mediaId count:(int)count withCallback:(CommentArrayResultBlock)callback;
+(void)postLikeInMediaWithId:(NSString*)mediaId withCallback:(OperationSuccessBlock)callback;
+(void)removeLikeInMediaWithId:(NSString*)mediaId withCallback:(OperationSuccessBlock)callback;


+(void)removeSubscriptionWithType:(IGSubscriptionType)subscriptionType withCallback:(OperationSuccessBlock)callback;
+(void)removeSubscriptionWithId:(NSString*)subscriptionId withCallback:(OperationSuccessBlock)callback;
+(void)getSubscriptionsWithCallback:(SubscriptionsResultBlock)callback;

+(void)addSubscriptionForUsersWithCallback:(SubscriptionResultBlock)callback;
+(void)addSubscriptionForLocation:(NSString*)locationId withCallback:(SubscriptionResultBlock)callback;
+(void)addSubscriptionForTag:(NSString*)tag withCallback:(SubscriptionResultBlock)callback;
+(void)addSubscriptionForLat:(double)lat lng:(double)lng radius:(int)radius withCallback:(SubscriptionResultBlock)callback;

@end

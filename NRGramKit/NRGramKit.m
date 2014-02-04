//
//  Instagram.m
//  Instamap
//
//  Created by Raul Andrisan on 3/21/11.
//  Copyright 2011 NextRoot. All rights reserved.
//

#import "NRGramKit.h"
#import "InstagramEngine.h"
#import "InstagramLoginDelegate.h"

#define kInstagramApiBaseUrl                            @"/v1"
#define kInstagramApiBaseUrlComplete                    @"https://api.instagram.com/v1"

#define kAccessTokenKey                                 @"NSGramKit_access_token"
#define kLoggedInUserKey                                @"NSGramKit_logged_in_user"

static NSString* access_token;
static NSString* client_id;
static NSString* client_secret;
static NSString* callback_url;

@implementation NRGramKit


+(void)initialize
{
    access_token = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessTokenKey];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"NRGramKitConfigs" ofType:@"plist"];
    NSDictionary* configs = [[NSDictionary alloc]initWithContentsOfFile:path];
    callback_url = configs[@"InstagramClientCallbackURL"];
    client_id = configs[@"InstagramClientId"];
    client_secret = configs[@"InstagramClientSecret"];
    
}

+(void)setClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret andClientCallbackURL:(NSString *)callbackURL
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"NRGramKitConfigs" ofType:@"plist"];
    NSMutableDictionary* configs = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    if (clientId) {
        client_id = clientId;
        [configs setObject:clientId forKey:@"InstagramClientId"];
    }
    if (clientSecret) {
        [configs setObject:clientSecret forKey:@"InstagramClientSecret"];
    }
    if (callbackURL) {
        callback_url = callbackURL;
        [configs setObject:callbackURL forKey:@"InstagramClientCallbackURL"];
    }
    
    [configs writeToFile:path atomically:YES];
}

+(void)setAccessToken:(NSString*)accessToken;
{
    if(accessToken!=nil)
    {
        access_token = accessToken;
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kAccessTokenKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessTokenKey];
    }
}

+(void)setLoggedInUser:(IGUser*)user
{
   if(user!=nil)
   {
         NSData* data = [NSKeyedArchiver archivedDataWithRootObject:user];
         [[NSUserDefaults standardUserDefaults] setObject:data forKey:kLoggedInUserKey];
         [[NSUserDefaults standardUserDefaults] synchronize];
   }
   else {
       [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoggedInUserKey];
   }
     
}


+(BOOL) isLoggedIn
{
    IGUser* user = [NRGramKit loggedInUser];
    return user!=nil && access_token!=nil;
}

+(IGUser*)loggedInUser
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey: kLoggedInUserKey];
    if(myEncodedObject!=nil)
    {
        IGUser* obj = (IGUser*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        return obj;
    }
    else
    {
        return nil;
    }
}


+(void)loginInWebView:(UIWebView*)webview loginLoadingCallback:(LoginLoadingBlock)loadingCallback finishedCallback:(LoginResultBlock)callback
{
    InstagramLoginDelegate* loginDelegate = [[InstagramLoginDelegate alloc]init];
    __block id delegate = loginDelegate;
    webview.delegate = delegate;
    
    loginDelegate.onSuccess = ^(NSString* accessToken)
    {
        [self setAccessToken:accessToken];
        [NRGramKit getUserWithId:@"self" withCallback:^(IGUser* user)
         {
             [self setLoggedInUser:user];
             delegate = nil;
             callback(user,nil);
         }];
        
    };
    
    loginDelegate.onError = ^(NSString* error)
    {
        delegate = nil;
        
        callback(nil,error);
    };  
    
    loginDelegate.onLoadingChanged = ^(BOOL loading){
        loadingCallback(loading);
    };
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    NSString* returnUrl = callback_url;
    NSString* authUrl = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&display=touch&scope=likes+comments+relationships",client_id,returnUrl];
    [webview loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:authUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0]];
}



+(void)logout
{
    [self setAccessToken:nil];
    [self setLoggedInUser:nil];
}

+(void)getUrl:(id)url withCallback:(PaginationDictionaryResultBlock)callback
{
    [self getUrl:url withCompleteCallback:^(NSDictionary* pagination,NSDictionary* data,NSDictionary* meta)
     {
         IGPagination* pg = nil;
         if(pagination!=nil && [pagination isKindOfClass:[NSDictionary class]])
         {
             pg = [IGPagination paginationWithDictionary:pagination];
         }
         callback(pg,data);
     }];
}

+(void)requestUrl:(id)url verb:(NSString*)verb params:(NSMutableDictionary*)params withCompleteCallback:(PaginationDataMetaResultBlock)callback
{
    [[InstagramEngine sharedEngine] bodyForPath:url verb:verb body:params onCompletion:^(NSDictionary* body)
     {
         
         if([body isKindOfClass:[NSDictionary class]])
         {
             NSNumber* code = [body objectForKey:@"code"];
             NSString* error_type = nil;
             IGMetadata* metadata = nil;
             if(code==nil)
             {
                 NSDictionary* meta = [body objectForKey:@"meta"];
                 metadata =[IGMetadata metadataWithDictionary:meta];
                 code = metadata.code;
                 error_type = metadata.error_type;
             }
             
             if(code==nil || (code!=nil && [code intValue]==200))
             {
                 NSDictionary* data = [body objectForKey:@"data"];
                 NSDictionary* pagination = [body objectForKey:@"pagination"];
                 NSDictionary* meta = [body objectForKey:@"meta"];
                 callback(pagination,data,meta);
             }
             else
             {
                 NSLog(@"%@",body);
                 if([code intValue]==400) //400 - OAuthAccessTokenException - Access Token expired or revoked
                 {
                     if(error_type!=nil)
                     {
                         if([error_type isEqualToString:@"OAuthAccessTokenException"])
                         {
                             callback(nil,nil,[body objectForKey:@"meta"]);
                         }
                         else if ([error_type isEqualToString:@"APINotAllowedError"]) {
                             callback(nil,nil,[body objectForKey:@"meta"]);
                         }
                         else if ([error_type isEqualToString:@"OAuthParameterException"]) {
                            callback(nil,nil,[body objectForKey:@"meta"]);
                         }
                         else
                         {
                             //APINotAllowedError - for not viewable tags :)
                             //nothing again
                         }
                     }
                 }
                 if([code intValue]==420)//420 - OAuthRateLimitException - Rate limit exceeded 5000
                 {                                              
                     callback(nil,nil,[body objectForKey:@"meta"]);
                 }
                 if([code intValue]==503) //too many requests to quickly
                 {
                     //do nothing just ignore this :D
                 }
             }
         }
         
         else
         {
             NSLog(@"%@",body);
             callback(nil,nil,nil);
         }
     }
    
     onError:^(NSError* error)
     {
         if (error) {
             NSLog(@"Error: %@", error);
             callback(nil,nil,nil);
         }
     }];
}

+(void)getUrl:(id)url withCompleteCallback:(PaginationDataMetaResultBlock)callback
{
    [self requestUrl:url verb:@"GET" params:nil withCompleteCallback:callback];
}

#pragma mark - User -

+(void)getUserWithId:(NSString*)Id withCallback: (UserResultBlock)callback{
    
    NSString* url = [NSString stringWithFormat:@"%@/%@/%@?access_token=%@",kInstagramApiBaseUrl,@"users",Id,access_token];
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         IGUser* user = [IGUser userWithDictionary:dict];
         if([Id isEqualToString:@"self"])
         {
             user.Id = @"self";
         }
         callback(user);
     }];
}

+(void)getUserWithName:(NSString*)name withCallback: (UserArrayResultBlock)callback{
    return [self getUserWithName:name limit:20 withCallback:callback];
}

+(void)getUserWithName:(NSString*)name limit:(int)limit withCallback: (UserArrayResultBlock)callback{
    NSString* currentParam = [self isLoggedIn]?@"access_token":@"client_id";
    NSString* currentParamValue  = [self isLoggedIn]?access_token:client_id;
    NSString* url = [NSString stringWithFormat:@"%@/%@/%@?q=%@&%@=%@&count=%d",kInstagramApiBaseUrl,@"users",@"search",name,currentParam,currentParamValue,limit];
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         NSMutableArray* array = [[NSMutableArray alloc]init];
         for (NSDictionary* userD in dict) {
             [array addObject:[IGUser userWithDictionary:userD]];
         }
         callback(array);
     }];
}

+(void)getUsersWhoFollowUserWithId:(NSString*)Id count:(int)count withCallback: (UserArrayResultBlock)callback
{
    NSString* currentParam = [self isLoggedIn]?@"access_token":@"client_id";
    NSString* currentParamValue  = [self isLoggedIn]?access_token:client_id;
    
    NSString* url = [NSString stringWithFormat:@"%@/%@/%@/%@?count=%d&%@=%@",kInstagramApiBaseUrl,@"users",Id,@"followed-by",count,currentParam,currentParamValue];
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         NSMutableArray* array = [[NSMutableArray alloc]init];
         for (NSDictionary* userD in dict) {
             [array addObject:[IGUser userWithDictionary:userD]];
         }
         callback(array);
     }];
}

+(void)getUsersFollowingUserWithId:(NSString*)Id count:(int)count withCallback: (UserArrayResultBlock)callback
{
    NSString* currentParam = [self isLoggedIn]?@"access_token":@"client_id";
    NSString* currentParamValue  = [self isLoggedIn]?access_token:client_id;
    
    NSString* url = [NSString stringWithFormat:@"%@/%@/%@/%@?count=%d&%@=%@",kInstagramApiBaseUrl,@"users",Id,@"follows",count,currentParam,currentParamValue];
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         NSMutableArray* array = [[NSMutableArray alloc]init];
         for (NSDictionary* userD in dict) {
             [array addObject:[IGUser userWithDictionary:userD]];
         }
         callback(array);
     }];
}

+(void)getRelationshipWithUser:(NSString*)Id withCallback:(RelationshipResultBlock)callback
{
    NSString* url = [NSString stringWithFormat:@"%@/%@/%@/%@?access_token=%@",kInstagramApiBaseUrl,@"users",Id,@"relationship",access_token];
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         NSLog(@"%@",dict);
         IGIncomingRelationshipStatus incoming = IGIncomingRelationshipNone;
         IGOutgoingRelationshipStatus outgoing = IGOutgoingRelationshipNone;
         
         NSString* outgoingStatus = [dict objectForKey:@"outgoing_status"];
         NSString* incomingStatus = [dict objectForKey:@"incoming_status"];
         
         if([outgoingStatus isEqualToString:@"follows"]) outgoing = IGOutgoingRelationshipFollows;
         else if([outgoingStatus isEqualToString:@"requested"]) outgoing = IGOutgoingRelationshipRequested;
         
         if([incomingStatus isEqualToString:@"followed_by"]) incoming = IGIncomingRelationshipFollowedBy;
         else if([incomingStatus isEqualToString:@"requested_by"]) incoming = IGIncomingRelationshipRequestedBy;
         else if([incomingStatus isEqualToString:@"blocked_by_you"]) incoming = IGIncomingRelationshipBlockedByYou;
         
         callback(incoming,outgoing);
     }];
}

+(void)postRelationship:(IGRelationshipAction)action withUser:(NSString*)Id withCallback:(OperationSuccessBlock)callback;
{
    NSString* url = [NSString stringWithFormat:@"/v1/%@/%@/%@",@"users",Id,@"relationship"];
    NSString* actionString;
    
    switch (action) {
        case IGRelationshipActionFollow:
            actionString = @"follow";
            break;
        case IGRelationshipActionUnfollow:
            actionString = @"unfollow";
            break;
        case IGRelationshipActionApprove:
            actionString = @"approve";
            break;
        case IGRelationshipActionDeny:
            actionString = @"deny";
            break;
        case IGRelationshipActionBlock:
            actionString = @"block";
            break;
        case IGRelationshipActionUnblock:
            actionString = @"unblock";
            break;
    }
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   access_token,@"access_token",
                                   actionString,@"action",
                                   nil];
    
    [self requestUrl:url verb:@"POST" params:params withCompleteCallback:^(NSDictionary* pagination,NSDictionary* data,NSDictionary* meta)
     {
         NSString* code= [meta objectForKey:@"code"];
         if([code intValue]==200) callback(YES);
         else callback(NO);
     }];
}

#pragma mark - Media -

+(void)getMediaInUserFeedWithCount:(int)count maxId:(NSString*)maxId minId:(NSString*)minId withCallback: (MediaArrayResultBlock)callback{
    NSString* minIdParam = minId!=nil?[NSString stringWithFormat:@"&min_id=%@",minId]:@"";
    NSString* maxIdParam = maxId!=nil?[NSString stringWithFormat:@"&max_id=%@",maxId]:@"";
    NSString* countParam = count>0?[NSString stringWithFormat:@"&count=%d",count]:@"";
    NSString* url = [NSString stringWithFormat:@"%@/%@/%@?&access_token=%@%@%@%@",kInstagramApiBaseUrl,@"users",@"self/feed",access_token,maxIdParam,minIdParam,countParam];
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         NSMutableArray* array = [[NSMutableArray alloc]init];
         for (NSDictionary* mediaD in dict) {
             [array addObject:[IGMedia mediaWithDictionary:mediaD]];
         }
         for(IGMedia* m in array)
         {
             m.section = [NSNumber numberWithInt:1];
         }
         callback(array,pagination);
     }]; 
}

+(void)getMediaInUserFeedWithCallback: (MediaArrayResultBlock)callback
{
    [self getMediaInUserFeedWithCount:64 maxId:nil minId:nil withCallback:callback];
}

+(void)getMediaInUserLikedCount:(int)count maxLikeId:(NSString*)maxLikeId withCallback:(MediaArrayResultBlock)callback;
{
    NSString* maxLikeIdParam = maxLikeId!=nil?[NSString stringWithFormat:@"&max_like_id=%@",maxLikeId]:@"";
    NSString* url = [NSString stringWithFormat:@"%@/%@/%@?&count=%d&access_token=%@%@",kInstagramApiBaseUrl,@"users",@"self/media/liked",count,access_token,maxLikeIdParam];
    [NRGramKit getUrl:url withCompleteCallback:^(NSDictionary* pagination,NSDictionary* dict,NSDictionary* meta)
     {
         NSMutableArray* array = [[NSMutableArray alloc]init];
         for (NSDictionary* mediaD in dict) {
             [array addObject:[IGMedia mediaWithDictionary:mediaD]];
         }
         for(IGMedia* m in array)
         {
             m.section = [NSNumber numberWithInt:3];
         }
       
         callback(array,[IGPagination paginationWithDictionary:pagination]);
     }]; 
}

+(void)getMediaInUserLikedCount:(int)count withCallback:(MediaArrayResultBlock)callback 
{
    [self getMediaInUserLikedCount:count maxLikeId:nil withCallback:callback];
}

+(void)getMediaRecentInUserWithId:(NSString*)Id count:(int)count minId:(NSString*)minId maxId:(NSString*)maxId minTimestamp:(NSDate*)minTimestamp maxTimestamp:(NSDate*)maxTimestamp withCallback:(MediaArrayResultBlock)callback{
    NSString* currentParam = [self isLoggedIn]?@"access_token":@"client_id";
    NSString* currentParamValue  = [self isLoggedIn]?access_token:client_id;
    
    NSString* countParam = count>0?[NSString stringWithFormat:@"&count=%d",count]:@"";
    
    NSString* earlierParam = maxTimestamp!=nil?[NSString stringWithFormat:@"&max_timestamp=%d",(int)[maxTimestamp timeIntervalSince1970]]:@"";
    NSString* laterParam = minTimestamp!=nil?[NSString stringWithFormat:@"&min_timestamp=%d",(int)[minTimestamp timeIntervalSince1970]]:@"";
    
    
    NSString* minIdParam = minId!=nil?[NSString stringWithFormat:@"&min_id=%@",minId]:@"";
    NSString* maxIdParam = maxId!=nil?[NSString stringWithFormat:@"&max_id=%@",maxId]:@"";
    
    NSString* url = [NSString stringWithFormat:@"%@/%@/%@/%@?%@=%@%@%@%@%@%@",kInstagramApiBaseUrl,@"users",Id,@"media/recent",currentParam,currentParamValue,countParam,earlierParam,laterParam,minIdParam,maxIdParam];
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         NSMutableArray* array = [[NSMutableArray alloc]init];
         for (NSDictionary* mediaD in dict) {
             [array addObject:[IGMedia mediaWithDictionary:mediaD]];
         }
         callback(array,pagination);
     }]; 
}

+(void)getMediaRecentInLocationWithId:(NSString*)Id count:(int)count minId:(NSString*)minId maxId:(NSString*)maxId minTimestamp:(NSDate*)minTimestamp maxTimestamp:(NSDate*)maxTimestamp withCallback:(MediaArrayResultBlock)callback
{
    NSString* currentParam = [self isLoggedIn]?@"access_token":@"client_id";
    NSString* currentParamValue  = [self isLoggedIn]?access_token:client_id;
    
    NSString* earlierParam = maxTimestamp!=nil?[NSString stringWithFormat:@"&max_timestamp=%d",(int)[maxTimestamp timeIntervalSince1970]]:@"";
    NSString* laterParam = minTimestamp!=nil?[NSString stringWithFormat:@"&min_timestamp=%d",(int)[minTimestamp timeIntervalSince1970]]:@"";
    
    
    NSString* minIdParam = minId!=nil?[NSString stringWithFormat:@"&min_id=%@",minId]:@"";
    NSString* maxIdParam = maxId!=nil?[NSString stringWithFormat:@"&max_id=%@",maxId]:@"";
    
    NSString* url = [NSString stringWithFormat:@"%@/%@/%@/%@?count=%d&%@=%@%@%@%@%@",kInstagramApiBaseUrl,@"locations",Id,@"media/recent",count,currentParam,currentParamValue,earlierParam,laterParam,minIdParam,maxIdParam];
    
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         NSMutableArray* array = [[NSMutableArray alloc]init];
         for (NSDictionary* mediaD in dict) {
             [array addObject:[IGMedia mediaWithDictionary:mediaD]];
         }
         callback(array,pagination);
     }]; 
}

+(void)getMediaRecentInTagWithName:(NSString*)name count:(int)count maxTagId:(NSString*)maxTagId minTagId:(NSString*)minTagId withCallback:(MediaArrayResultBlock)callback {
    NSString* currentParam = [self isLoggedIn]?@"access_token":@"client_id";
    NSString* currentParamValue  = [self isLoggedIn]?access_token:client_id;
    
    NSString* minTagIdParam = minTagId!=nil?[NSString stringWithFormat:@"&min_tag_id=%@",minTagId]:@"";
    NSString* maxTagIdParam = maxTagId!=nil?[NSString stringWithFormat:@"&max_tag_id=%@",maxTagId]:@"";
    NSString* countParam = count>0?[NSString stringWithFormat:@"&count=%d",count]:@"";
    
    NSString* url = [NSString stringWithFormat:@"%@/%@/%@/%@?%@=%@%@%@%@",kInstagramApiBaseUrl,@"tags",name,@"media/recent",currentParam,currentParamValue,countParam,minTagIdParam,maxTagIdParam];
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         NSMutableArray* array = [[NSMutableArray alloc]init];
         for (NSDictionary* mediaD in dict) {
             [array addObject:[IGMedia mediaWithDictionary:mediaD]];
         }
         callback(array,pagination);
     }];
}

+(void)getMediaRecentInGeographyWithId:(NSString*)Id count:(int)count
                          withCallback:(MediaArrayResultBlock)callback {
    NSString* currentParam = [self isLoggedIn]?@"access_token":@"client_id";
    NSString* currentParamValue  = [self isLoggedIn]?access_token:client_id;
    NSString* url = [NSString stringWithFormat:@"%@/%@/%@/%@?count=%d&%@=%@",kInstagramApiBaseUrl,@"geographies",Id,@"media/recent",count,currentParam,currentParamValue];
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         NSMutableArray* array = [[NSMutableArray alloc]init];
         for (NSDictionary* mediaD in dict) {
             [array addObject:[IGMedia mediaWithDictionary:mediaD]];
         }
         callback(array,pagination);
     }];
}

+(void)getMediaWithId:(NSString*)Id withCallback: (MediaResultBlock)callback {
    NSString* currentParam = [self isLoggedIn]?@"access_token":@"client_id";
    NSString* currentParamValue  = [self isLoggedIn]?access_token:client_id;

    NSString* url = [NSString stringWithFormat:@"%@/%@/%@?%@=%@",kInstagramApiBaseUrl,@"media",Id,currentParam, currentParamValue];
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         
         callback([IGMedia mediaWithDictionary:dict]);
     }];
}

+(void)getMediaSearchAtLatitude:(double)lat longitude:(double)lng radius:(int)radius count:(int)count earlierThan:(NSDate*)earlierDate laterThen:(NSDate*)laterDate withCallback: (MediaArrayResultBlock)callback {
    NSString* currentParam = [self isLoggedIn]?@"access_token":@"client_id";
    NSString* currentParamValue  = [self isLoggedIn]?access_token:client_id;
    
    NSString* earlierParam = earlierDate!=nil?[NSString stringWithFormat:@"&max_timestamp=%d",(int)[earlierDate timeIntervalSince1970]]:@"";
    
    NSString* laterParam = laterDate!=nil?[NSString stringWithFormat:@"&min_timestamp=%d",(int)[laterDate timeIntervalSince1970]]:@"";
      NSString* countParam = count>0?[NSString stringWithFormat:@"&count=%d",count]:@"";

    NSString* url = [NSString stringWithFormat:@"%@/%@/%@?lat=%f&lng=%f&radius=%d&%@=%@%@%@%@",kInstagramApiBaseUrl,@"media",@"search",lat,lng,radius,currentParam, currentParamValue,laterParam,earlierParam,countParam];
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         if(dict!=nil)
         {
         NSMutableArray* array = [[NSMutableArray alloc]init];
         for (NSDictionary* mediaD in dict) {
             [array addObject:[IGMedia mediaWithDictionary:mediaD]];
         }
         callback(array,pagination);
         }
         else
         {
             callback(nil,nil);
         }
     }];
}

+(void)getMediaPopularCount:(int)count withCallback:(MediaArrayResultBlock)callback{
    NSString* currentParam = [self isLoggedIn]?@"access_token":@"client_id";
    NSString* currentParamValue  = [self isLoggedIn]?access_token:client_id;
    NSString* url = [NSString stringWithFormat:@"%@/%@/%@?%@=%@&count=%d",kInstagramApiBaseUrl,@"media",@"popular",currentParam,currentParamValue,count];
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         NSMutableArray* array = [[NSMutableArray alloc]init];
         for (NSDictionary* mediaD in dict) {
             [array addObject:[IGMedia mediaWithDictionary:mediaD]];
         }
         for(IGMedia* m in array)
         {
             m.section = [NSNumber numberWithInt:2];
         }
         callback(array,pagination);
     }];   
}

#pragma mark - Location -

+(void)getLocationWithId:(NSString*)Id withCallback: (LocationResultBlock)callback {
    NSString* currentParam = [self isLoggedIn]?@"access_token":@"client_id";
    NSString* currentParamValue  = [self isLoggedIn]?access_token:client_id;

    NSString* url = [NSString stringWithFormat:@"%@/%@/%@?%@=%@",kInstagramApiBaseUrl,@"locations",Id,currentParam, currentParamValue];
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         callback([IGLocation locationWithDictionary:dict]);
     }];
}

+(void)getLocationsSearchAtLatitude:(double)lat longitude:(double)lng radius:(int)radius withCallback: (LocationArrayResultBlock)callback {
    NSString* currentParam = [self isLoggedIn]?@"access_token":@"client_id";
    NSString* currentParamValue  = [self isLoggedIn]?access_token:client_id;

    NSString* url = [NSString stringWithFormat:@"%@/%@/%@?lat=%f&lng=%f&radius=%d&count=40&%@=%@",kInstagramApiBaseUrl,@"locations",@"search",lat,lng,radius,currentParam, currentParamValue];
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         
         NSMutableArray* array = [[NSMutableArray alloc]init];
         for (NSDictionary* locationD in dict) {
             [array addObject:[IGLocation locationWithDictionary:locationD]];
         }
         callback(array);
     }];
}

#pragma mark - Tags -

+(void)getTagWithName:(NSString*)name withCallback: (TagResultBlock)callback {
    NSString* currentParam = [self isLoggedIn]?@"access_token":@"client_id";
    NSString* currentParamValue  = [self isLoggedIn]?access_token:client_id;
    
    NSString* url = [NSString stringWithFormat:@"%@/%@/%@?%@=%@",kInstagramApiBaseUrl,@"tags",name,currentParam, currentParamValue];
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         if(dict!=nil) {
             callback([IGTag tagWithDictionary:dict]);
         }
         else {
             callback(nil);
         }
     }];
}

+(void)getTagSearchWithName:(NSString*)name withCallback: (TagArrayResultBlock)callback {
    NSString* currentParam = [self isLoggedIn]?@"access_token":@"client_id";
    NSString* currentParamValue  = [self isLoggedIn]?access_token:client_id;
    NSString* url = [NSString stringWithFormat:@"%@/%@/%@?q=%@&%@=%@",kInstagramApiBaseUrl,@"tags",@"search",name,currentParam, currentParamValue];
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         NSMutableArray* array = [[NSMutableArray alloc]init];
         for (NSDictionary* tagD in dict) {
             [array addObject:[IGTag tagWithDictionary:tagD]];
         }
         callback(array);
     }];   
}

#pragma mark - Comments -
+(void)getCommentsInMediaWithId:(NSString*)mediaId count:(int)count withCallback:(CommentArrayResultBlock)callback {
    NSString* currentParam = [self isLoggedIn]?@"access_token":@"client_id";
    NSString* currentParamValue  = [self isLoggedIn]?access_token:client_id;
        NSString* countParam = count>0?[NSString stringWithFormat:@"&count=%d",count]:@"";
    
    NSString* url = [NSString stringWithFormat:@"%@/%@/%@/%@?%@=%@%@",kInstagramApiBaseUrl,@"media",mediaId,@"comments",currentParam,currentParamValue,countParam];
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         NSMutableArray* array = [[NSMutableArray alloc]init];
         for (NSDictionary* commentD in dict) {
             [array addObject:[IGComment commentWithDictionary:commentD]];
         }
         callback(array,pagination);
     }];
}

+(void)postComment:(NSString*)message inMediaWithId:(NSString*)mediaId withCallback:(OperationSuccessBlock)callback {
    NSString* url = [NSString stringWithFormat:@"/v1/%@/%@/%@",@"media",mediaId,@"comments"];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   access_token,@"access_token",
                                   message,@"text",
                                   nil];
    
    [self requestUrl:url verb:@"POST" params:params withCompleteCallback:^(NSDictionary* pagination,NSDictionary* data,NSDictionary* meta)
     {
         NSString* code= [meta objectForKey:@"code"];
         if([code intValue]==200) callback(YES);
         else callback(NO);
     }];
}

+(void)removeCommentWithId:(NSString*)commentId inMediaWithId:(NSString*)mediaId withCallback:(OperationSuccessBlock)callback {
    NSString* url = [NSString stringWithFormat:@"/v1/%@/%@/%@/%@?access_token=%@",@"media",mediaId,@"comments",commentId, access_token];
    
    [self requestUrl:url verb:@"DELETE" params:nil withCompleteCallback:^(NSDictionary* pagination,NSDictionary* data,NSDictionary* meta)
     {
         NSString* code= [meta objectForKey:@"code"];
         if([code intValue]==200) callback(YES);
         else callback(NO);
     }];
}

#pragma mark - Likes -

+(void)getLikesInMediaWithId:(NSString*)mediaId count:(int)count withCallback:(CommentArrayResultBlock)callback{
    NSString* currentParam = [self isLoggedIn]?@"access_token":@"client_id";
    NSString* currentParamValue  = [self isLoggedIn]?access_token:client_id;
    NSString* countParam = count>0?[NSString stringWithFormat:@"&count=%d",count]:@"";
    
     NSString* url = [NSString stringWithFormat:@"%@/%@/%@/%@?%@=%@%@",kInstagramApiBaseUrl,@"media",mediaId,@"likes",currentParam,currentParamValue,countParam];
    
    [NRGramKit getUrl:url withCallback:^(IGPagination* pagination,NSDictionary* dict)
     {
         NSMutableArray* array = [[NSMutableArray alloc]init];
         for (NSDictionary* userD in dict) {
             [array addObject:[IGUser userWithDictionary:userD]];
         }
         callback(array,pagination);
     }];
}

+(void)postLikeInMediaWithId:(NSString*)mediaId withCallback:(OperationSuccessBlock)callback{
    
    NSString* url = [NSString stringWithFormat:@"/v1/%@/%@/%@?access_token=%@",@"media",mediaId,@"likes", access_token];
    [self requestUrl:url verb:@"POST" params:nil withCompleteCallback:^(NSDictionary* pagination,NSDictionary* data,NSDictionary* meta)
     {
         NSString* code= [meta objectForKey:@"code"];
         if([code intValue]==200) callback(YES);
         else callback(NO);
     }];
}

+(void)removeLikeInMediaWithId:(NSString*)mediaId withCallback:(OperationSuccessBlock)callback{
    NSString* url = [NSString stringWithFormat:@"/v1/%@/%@/%@?access_token=%@",@"media",mediaId,@"likes", access_token];
    [self requestUrl:url verb:@"DELETE" params:nil withCompleteCallback:^(NSDictionary* pagination,NSDictionary* data,NSDictionary* meta)
     {
         NSString* code= [meta objectForKey:@"code"];
         if([code intValue]==200) callback(YES);
         else callback(NO);
     }];
}

#pragma mark - Subscripions -
+(void)removeSubscriptionWithType:(IGSubscriptionType)subscriptionType withCallback:(OperationSuccessBlock)callback{
    NSString* subscriptionTypeString = nil;
    switch (subscriptionType) {
        case IGSubscriptionTypeGeography:
            subscriptionTypeString = @"geography";
            break;
        case IGSubscriptionTypeLocation:
            subscriptionTypeString = @"location";
            break;
        case IGSubscriptionTypeTag:
            subscriptionTypeString = @"tag";
            break;
        case IGSubscriptionTypeUsers:
            subscriptionTypeString = @"user";
            break;
        case IGSubscriptionTypeAll:
            subscriptionTypeString = @"all";
            break;
    }
    NSString* url = [NSString stringWithFormat:@"/v1/subscriptions?client_id=%@&client_secret=%@&object=%@",client_id,client_secret,subscriptionTypeString];
    [self requestUrl:url verb:@"DELETE" params:nil withCompleteCallback:^(NSDictionary* pagination,NSDictionary* data,NSDictionary* meta)
     {
         NSString* code= [meta objectForKey:@"code"];
         if([code intValue]==200) callback(YES);
         else callback(NO);
     }];
}

+(void)removeSubscriptionWithId:(NSString*)subscriptionId withCallback:(OperationSuccessBlock)callback{
   
    NSString* url = [NSString stringWithFormat:@"/v1/subscriptions?client_id=%@&client_secret=%@&id=%@",client_id,client_secret,subscriptionId];
    [self requestUrl:url verb:@"DELETE" params:nil withCompleteCallback:^(NSDictionary* pagination,NSDictionary* data,NSDictionary* meta)
     {
         NSString* code= [meta objectForKey:@"code"];
         if([code intValue]==200) callback(YES);
         else callback(NO);
     }];
}


+(void)getSubscriptionsWithCallback:(SubscriptionsResultBlock)callback
{
    NSString* url = [NSString stringWithFormat:@"/v1/subscriptions?client_id=%@&client_secret=%@",client_id,client_secret];
    [self requestUrl:url verb:@"GET" params:nil withCompleteCallback:^(NSDictionary* pagination,NSDictionary* data,NSDictionary* meta)
     {
         NSMutableArray* subscriptions = [[NSMutableArray alloc]init];
         for(NSDictionary* dict in data)
         {
             [subscriptions addObject:[IGSubscription subscriptionWithDictionary:dict]];
         }
         NSString* code= [meta objectForKey:@"code"];
         if([code intValue]==200) callback(subscriptions);
         else callback(nil);
     }];
}

+(void)addSubscriptionWithParams:(NSDictionary*)params andCallback:(SubscriptionResultBlock)callback
{
    NSString* url = [NSString stringWithFormat:@"/v1/subscriptions"];
    [self requestUrl:url verb:@"POST" params:[params mutableCopy] withCompleteCallback:^(NSDictionary* pagination,NSDictionary* data,NSDictionary* meta)
     {
         IGSubscription* subscription = [IGSubscription subscriptionWithDictionary:data];
         NSString* code= [meta objectForKey:@"code"];
         if([code intValue]==200) callback(subscription);
         else callback(NO);
     }];
    
}


+(void)addSubscriptionForUsersWithCallback:(SubscriptionResultBlock)callback{
    
    
    NSDictionary* params_dict = @{@"client_id":client_id,
                                  @"client_secret":client_secret,
                                  @"object":@"user",
                                  @"aspect":@"media",
                                  @"verify_token":@"nrgramkit",
                                  @"callback_url":@"http://andrisan-office.no-ip.org:3002/callbacks/geo/user_subscription"
                             };
    [self addSubscriptionWithParams:params_dict andCallback:callback];
    
   
}

+(void)addSubscriptionForLocation:(NSString*)locationId withCallback:(SubscriptionResultBlock)callback{
    
    
    NSDictionary* params_dict = @{@"client_id":client_id,
                                  @"client_secret":client_secret,
                                  @"object":@"location",
                                  @"object_id":locationId,
                                  @"aspect":@"media",
                                  @"verify_token":@"nrgramkit",
                                  @"callback_url":@"http://andrisan-office.no-ip.org:3002/callbacks/geo/location_subscription"
                                  };
    [self addSubscriptionWithParams:params_dict andCallback:callback];
}

+(void)addSubscriptionForTag:(NSString*)tag withCallback:(SubscriptionResultBlock)callback{
    
    
    NSDictionary* params_dict = @{@"client_id":client_id,
                                  @"client_secret":client_secret,
                                  @"object":@"tag",
                                  @"object_id":tag,
                                  @"aspect":@"media",
                                  @"verify_token":@"nrgramkit",
                                  @"callback_url":@"http://andrisan-office.no-ip.org:3002/callbacks/geo/tag_subscription"
                                  };
    [self addSubscriptionWithParams:params_dict andCallback:callback];
}

+(void)addSubscriptionForLat:(double)lat lng:(double)lng radius:(int)radius withCallback:(SubscriptionResultBlock)callback{
    
    
    NSDictionary* params_dict = @{@"client_id":client_id,
                                  @"client_secret":client_secret,
                                  @"object":@"geography",
                                  @"lat":@(lat),
                                  @"lng":@(lng),
                                  @"radius":@(radius),
                                  @"aspect":@"media",
                                  @"verify_token":@"nrgramkit",
                                  @"callback_url":@"http://andrisan-office.no-ip.org:3002/callbacks/geo/tag_subscription"
                                  };
    [self addSubscriptionWithParams:params_dict andCallback:callback];
}

@end

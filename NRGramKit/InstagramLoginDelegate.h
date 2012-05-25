//
//  InstagramLoginDelegate.h
//  NRGramKit
//
//  Created by Raul Andrisan on 5/23/12.
//  Copyright (c) 2012 NextRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AccessTokenResultBlock)(NSString*);
typedef void (^ErrorResultBlock)(NSString*);
typedef void (^LoadingBlock)(BOOL);

@interface InstagramLoginDelegate : NSObject<UIWebViewDelegate>

@property (copy) AccessTokenResultBlock onSuccess;
@property (copy) ErrorResultBlock onError;
@property (copy) LoadingBlock onLoadingChanged;

@end

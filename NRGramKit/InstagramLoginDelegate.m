//
//  InstagramLoginDelegate.m
//  NRGramKit
//
//  Created by Raul Andrisan on 5/23/12.
//  Copyright (c) 2012 NextRoot. All rights reserved.
//

#import "InstagramLoginDelegate.h"

@implementation InstagramLoginDelegate

@synthesize onSuccess;
@synthesize onError;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

@end

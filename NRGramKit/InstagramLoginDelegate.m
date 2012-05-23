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
@synthesize onLoadingChanged;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* host = [[request URL] host];
    if([host rangeOfString:@"api.instamapapp.com"].location!=NSNotFound)
    {
        NSString* frag = [[request URL] fragment];
        NSMutableDictionary*dict = [self parseQueryString:frag];
        NSString* accessToken = [dict objectForKey:@"access_token"];
        onSuccess(accessToken);
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    onLoadingChanged(YES);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    onLoadingChanged(NO);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    onError([error localizedDescription]);
}

-(NSMutableDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&amp;"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}


@end

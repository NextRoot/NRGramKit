NRGramKit
=========

An Objective-C block-based, ARC, API wrapper for the complete Instagram API for iOS

<b>Usage</b>
---
Clone the project, and don't forget to clone the submodules and init them
<pre>
git clone git://github.com/NextRoot/NRGramKit.git NRGramKit
cd NRGramKit
git submodule init
git submodule update
</pre>

Create an application at http://intagr.am/developer and replace your application key and application secret in <i>NRGramKit-Prefix.pch</i>

Use the provided class methods to make instagram calls and receive the data using the provided blocks, asynchronously.

<b>Authentication:</b>

Just provide NRGramKit with a webview that you display where you want and when you want so it can handle the login process. NRGramKit remembers everything it needs after the process is finished.
<pre>
[NRGramKit loginInWebView:self.webView 
     loginLoadingCallback:^(BOOL loading){
        //you can show a spinner while the webview is loading
         }
         finishedCallback:^(IGUser* user,NSString* error)     {
         // yay - you are now authenticated, NRGramKit remembers the credentials
         }];
</pre>
You can check if you're authenticated using 
<pre>
 [NGGramKit isLoggedIn];
</pre>

Or get info about the current user using
<pre>
 [NGGramKit loggedInUser];
</pre>

<b>Unauthenticated calls:</b>

All the calls to the service are done asynchronously and are block-based
<pre>
 [NRGramKit getMediaPopularWithCallback:^(NSArray* popularMedia,IGPagination* pagination)
             {
                 self.media = popularMedia;
             }];
</pre>

<b> Authenticated calls</b>

Authenticated calls will simply fail if you don't login first

<pre>
[NRGramKit getMediaInUserLikedCount:25 withCallback:^(NSArray* likedFeed, IGPagination* pagination)
             {
                 self.media = likedFeed;
                 callback(YES);
             }];
</pre>
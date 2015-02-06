NRGramKit
=========

An Objective-C block-based, ARC, API wrapper for the complete Instagram API for iOS

### Usage
This project installs as a cocoapods pod in your project by pasting this line in your Podfile:

	pod 'NRGramKit'
	
Optionally to make sure you are using the latest version you can specify the podfile linked directly from the official NRGramKit repository:

	pod 'NRGramKit', :podspec => 'https://raw.github.com/NextRoot/NRGramKit/master/NRGramKit.podspec'


Create an application at [http://instagr.am/developer](http://instagr.am/developer) and create a new plist file in your project called *NRGramKitConfigs.plist* with the following keys:

	InstagramClientId
	InstagramClientSecret
	InstagramClientCallbackURL

Use the provided class methods to make instagram calls and receive the data using the provided blocks, asynchronously.

###Authentication

Just provide NRGramKit with a webview that you display where you want and when you want so it can handle the login process. NRGramKit remembers everything it needs after the process is finished.

	[NRGramKit loginInWebView:self.webView 			loginLoadingCallback:^(BOOL loading){
        //you can show a spinner while the webview is loading
         }
         finishedCallback:^(IGUser* user,NSString* error)     {
         // yay - you are now authenticated, NRGramKit remembers the credentials
         }];

You can check if you're authenticated using 

	[NGGramKit isLoggedIn];


Or get info about the current user using

	[NGGramKit loggedInUser];


###Unauthenticated calls

All the calls to the service are done asynchronously and are block-based

	[NRGramKit getMediaPopularWithCallback:^(NSArray* popularMedia,IGPagination* pagination)
             {
                 self.media = popularMedia;
             }];


### Authenticated calls

Authenticated calls will simply fail if you don't login first


	[NRGramKit getMediaInUserLikedCount:25 withCallback:^(NSArray* likedFeed, IGPagination* pagination)
             {
                 self.media = likedFeed;
                 callback(YES);
             }];

### License

NRGramKit is available under the MIT license. See the LICENSE file for more info.

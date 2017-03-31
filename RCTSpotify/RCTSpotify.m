//
//  RCTSpotify.m
//  RCTSpotify
//
//  Created by Adil A. Karim on 30/03/2017.
//  Copyright © 2017 A A Karim. All rights reserved.
//

#import "RCTSpotify.h"
#import <React/RCTLog.h>

@implementation RCTSpotify


RCT_EXPORT_MODULE();
RCT_EXPORT_METHOD(begin:(RCTResponseSenderBlock)callback)
{
    if (self.player == nil) {
        self.player = [SPTAudioStreamingController sharedInstance];
    }
    self.auth = [SPTAuth defaultInstance];
    self.auth.clientID = @"3368a2a6d90c42038bbb0b5cd12a0561"; // TODO: move to a file
    self.player.delegate = self;
    // Start up the streaming controller.
    NSError *audioStreamingInitError;
    NSAssert([self.player startWithClientId:self.auth.clientID error:&audioStreamingInitError],
             @"There was a problem starting the Spotify SDK: %@", audioStreamingInitError.
             description);
    callback(@[]);
}
RCT_EXPORT_METHOD(loginWithAccessToken:(NSString *)accessToken withCallback:(RCTResponseSenderBlock)callback)
{
    RCTLogInfo(@"Logging in with access token %@ ", accessToken);
    [self.player loginWithAccessToken:accessToken];
    callback(@[]);
};

RCT_EXPORT_METHOD(playSong)
{
    RCTLogInfo(@"Playing song");
    [self.player playSpotifyURI:@"spotify:track:58s6EuEYJdlb0kO7awm3Vp" startingWithIndex:0 startingWithPosition:0 callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"*** failed to play: %@", error);
            return;
        }
    }];
}

@end

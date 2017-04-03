//
//  RCTSpotify.h
//  RCTSpotify
//
//  Created by Adil A. Karim on 30/03/2017.
//  Copyright © 2017 A A Karim. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <SpotifyAudioPlayback/SpotifyAudioPlayback.h>
#import <SpotifyAuthentication/SpotifyAuthentication.h>

@interface RCTSpotify : RCTEventEmitter <RCTBridgeModule, SPTAudioStreamingDelegate, SPTCoreAudioControllerDelegate, SPTAudioStreamingPlaybackDelegate>
@property (nonatomic, strong) SPTAudioStreamingController *player;
@property (nonatomic, strong) SPTAuth *auth;
@end

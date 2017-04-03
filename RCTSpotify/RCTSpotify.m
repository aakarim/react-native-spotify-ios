//
//  RCTSpotify.m
//  RCTSpotify
//
//  Created by Adil A. Karim on 30/03/2017.
//  Copyright © 2017 A A Karim. All rights reserved.
//

#import "RCTSpotify.h"
#import <React/RCTLog.h>
#import <React/RCTConvert.h>
@implementation RCTSpotify


RCT_EXPORT_MODULE();
- (NSArray<NSString *> *)supportedEvents
{
    return @[
             /*
              SPTAudioControllerDelegate
              */
             @"audioStreamingDidReceiveError",
             @"audioStreamingDidLogin",
             @"audioStreamingDidLogout",
             @"audioStreamingDidEncounterTemporaryConnectionError",
             @"audioStreamingdidReceiveMessage",
             @"audioStreamingDidDisconnect",
             @"audioStreamingDidReconnect",
             
             /*
              SPTAudioStreamingPlaybackDelegate
              */
             @"audioStreamingDidReceivePlaybackEvent",
             @"audioStreamingDidChangePosition",
             @"audioStreamingDidChangePlaybackStatus",
             @"audioStreamingDidSeekToPosition",
             @"audioStreamingDidChangeVolume",
             @"audioStreamingDidChangeShuffleStatus",
             @"audioStreamingDidChangeRepeatStatus",
             @"audioStreamingDidChangeMetadata",
             @"audioStreamingDidStartPlayingTrack",
             @"audioStreamingDidStopPlayingTrack",
             @"audioStreamingDidSkipToNextTrack",
             @"audioStreamingDidSkipToPreviousTrack",
             @"audioStreamingDidBecomeActivePlaybackDevice",
             @"audioStreamingDidBecomeInactivePlaybackDevice",
             @"audioStreamingDidLosePermissionForPlayback",
             @"audioStreamingDidPopQueue",
             ];
}

/*
 SPTAudioController Methods
 */

RCT_EXPORT_METHOD(initializeWithClientId:(NSString *)clientId withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)
{
    if (self.player == nil) {
        self.player = [SPTAudioStreamingController sharedInstance];
    }
    self.auth = [SPTAuth defaultInstance];
    self.auth.clientID = clientId;
    self.player.delegate = self;
    self.player.playbackDelegate = self;
    resolve(@[]);
}

RCT_EXPORT_METHOD(seekTo:(NSNumber * _Nonnull)position withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)
{
    NSTimeInterval timeInterval = [RCTConvert NSTimeInterval:position];
    RCTLog(@"Seeking to %@", timeInterval);
    [self.player seekTo:timeInterval callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"*** failed to seek: %@", error);
            reject(@"spotify", @"Seek error", error);
            return;
        }
        resolve(@[]);
    }];
}

RCT_EXPORT_METHOD(setVolume:(NSNumber * _Nonnull)volume withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)
{
    RCTLog(@"Setting volume");
    double newVol = [RCTConvert double:volume];
    [self.player setVolume:newVol callback:^(NSError * error) {
        if (error != nil) {
            NSLog(@"*** failed to change volume: %@", error);
            reject(@"spotify", @"Change volume error", error);
            return;
        }
        resolve(@[]);
    }];
}

RCT_EXPORT_METHOD(startAudioController:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)
{
    if(self.player.initialized) {
        RCTLog(@"Player already started, stopping...");
        [self.player stopWithError:nil];
    }
    // Start up the streaming controller.
    NSError *audioStreamingInitError;
    
    NSAssert([self.player startWithClientId:self.auth.clientID error:&audioStreamingInitError],
             @"There was a problem starting the Spotify SDK: %@", audioStreamingInitError.
             description);
    if(audioStreamingInitError) {
        reject(@"spotify_error", @"Spotify Init Error", audioStreamingInitError);
        return;
    }
    resolve(@[]);
}

RCT_EXPORT_METHOD(loginWithAccessToken:(NSString *)accessToken)
{
    RCTLogInfo(@"Logging in with access token %@ ", accessToken);
    [self.player loginWithAccessToken:accessToken];
//    resolve(@[]);
};

RCT_EXPORT_METHOD(playSpotifyURI:(NSString *)spotifyUri startingWithIndex:(NSNumber * _Nonnull)index startingWithPosition:(NSNumber * _Nonnull)position withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)
{
    RCTLogInfo(@"Playing song", spotifyUri);
    // Type conversion from react
    NSUInteger i = [RCTConvert NSUInteger:index];
    NSTimeInterval timeInterval = [RCTConvert NSTimeInterval:position];
    
    [self.player playSpotifyURI:spotifyUri startingWithIndex:i startingWithPosition: timeInterval callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"*** failed to play: %@", error);
            reject(@"spotify", @"Play error: ", error);
            return;
        }
        resolve(@[]);
    }];
}

RCT_EXPORT_METHOD(stopWithError)
{
    NSError *__autoreleasing * err = nil;
    [self.player stopWithError:err];
}

RCT_EXPORT_METHOD(logout)
{
    [self.player logout];
}

RCT_EXPORT_METHOD(setIsPlaying:(BOOL)isPlaying withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)
{
    [self.player setIsPlaying:isPlaying callback:^(NSError *error){
        if(error != nil) {
            NSLog(@"*** failed to change playing stsatus: %@", error);
            reject(@"spotify", @"Is playing set error: ", error);
            return;
        }
        resolve(@"");
    }];
}

/*
  SPTAudioControllerDelegate
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveError:(NSError *)error
{
    [self sendEventWithName:@"audioStreamingDidReceiveError" body:@{@"error": @(error.code)}];
}
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveMessage:(NSString *)message
{
    [self sendEventWithName:@"audioStreamingdidReceiveMessage" body:@{@"message": message}];
}
- (void)audioStreamingDidDisconnect:(SPTAudioStreamingController *)audioStreaming
{
    [self sendEventWithName:@"audioStreamingDidDisconnect" body:@{}];
}
- (void)audioStreamingDidEncounterTemporaryConnectionError:(SPTAudioStreamingController *)audioStreaming
{
    [self sendEventWithName:@"audioStreamingDidEncounterTemporaryConnectionError" body:@{}];
}
- (void)audioStreamingDidLogin:(SPTAudioStreamingController *)audioStreaming
{
    RCTLogInfo(@"Logged in");
    [self sendEventWithName:@"audioStreamingDidLogin" body:@{}];
}
- (void)audioStreamingDidLogout:(SPTAudioStreamingController *)audioStreaming
{
    RCTLogInfo(@"Logged out");
    [self sendEventWithName:@"audioStreamingDidLogout" body:@{}];
}
- (void)audioStreamingDidReconnect:(SPTAudioStreamingController *)audioStreaming
{
    [self sendEventWithName:@"audioStreamingDidReconnect" body:@{}];
}

/*
    SPTAudioStreamingPlaybackDelegate
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeMetadata:(SPTPlaybackMetadata *)metadata
{
    [self sendEventWithName:@"audioStreamingDidChangeMetadata" body:[RCTSpotify playbackMetadataToDictionary: metadata]];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangePlaybackStatus:(BOOL)isPlaying
{
    [self sendEventWithName:@"audioStreamingDidChangePlaybackStatus" body:@{@"isPlaying": @(isPlaying)}];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangePosition:(NSTimeInterval)position
{
    [self sendEventWithName:@"audioStreamingDidChangePosition" body:@{@"position": @(position)}];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeRepeatStatus:(SPTRepeatMode)repeatMode
{
    [self sendEventWithName:@"audioStreamingDidChangeRepeatStatus" body:@{@"repeatMode": @(repeatMode)}];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeShuffleStatus:(BOOL)enabled
{
    [self sendEventWithName:@"audioStreamingDidChangeShuffleStatus" body:@{@"shuffleStatus": @(enabled)}];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeVolume:(SPTVolume)volume
{
    [self sendEventWithName:@"audioStreamingDidChangeVolume" body:@{@"volume": @(volume)}];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceivePlaybackEvent:(SpPlaybackEvent)event
{
    [self sendEventWithName:@"audioStreamingDidReceivePlaybackEvent" body:@{@"event": @(event)}];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didSeekToPosition:(NSTimeInterval)position
{
    [self sendEventWithName:@"audioStreamingDidSeekToPosition" body:@{@"position": @(position)}];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didStartPlayingTrack:(NSString *)trackUri
{
    [self sendEventWithName:@"audioStreamingDidStartPlayingTrack" body:@{@"trackURI": trackUri}];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didStopPlayingTrack:(NSString *)trackUri
{
    [self sendEventWithName:@"audioStreamingDidStopPlayingTrack" body:@{@"trackURI":trackUri}];
}

- (void)audioStreamingDidBecomeActivePlaybackDevice:(SPTAudioStreamingController *)audioStreaming
{
    [self sendEventWithName:@"audioStreamingDidBecomeActivePlaybackDevice" body:@{}];
}

- (void)audioStreamingDidBecomeInactivePlaybackDevice:(SPTAudioStreamingController *)audioStreaming
{
    [self sendEventWithName:@"audioStreamingDidBecomeInactivePlaybackDevice" body:@{}];
}

- (void)audioStreamingDidLosePermissionForPlayback:(SPTAudioStreamingController *)audioStreaming
{
    [self sendEventWithName:@"audioStreamingDidLosePermissionForPlayback" body:@{}];
}

- (void)audioStreamingDidPopQueue:(SPTAudioStreamingController *)audioStreaming
{
    [self sendEventWithName:@"audioStreamingDidPopQueue" body:@{}];
}

- (void)audioStreamingDidSkipToNextTrack:(SPTAudioStreamingController *)audioStreaming
{
    [self sendEventWithName:@"audioStreamingDidSkipToNextTrack" body:@{}];
}

- (void)audioStreamingDidSkipToPreviousTrack:(SPTAudioStreamingController *)audioStreaming
{
    [self sendEventWithName:@"audioStreamingDidSkipToPreviousTrack" body:@{}];
}

/*
    Helpers
 */
+ (NSDictionary *) playbackMetadataToDictionary: (SPTPlaybackMetadata *) metadata
{
    
    return @{
             @"prevTrack": metadata.prevTrack ? [RCTSpotify playbackTrackToDictionary:metadata.prevTrack] : @NO,
             @"currentTrack": metadata.currentTrack ? [RCTSpotify playbackTrackToDictionary:metadata.currentTrack] : @NO,
             @"nextTrack": metadata.nextTrack ? [RCTSpotify playbackTrackToDictionary:metadata.nextTrack] : @NO,
             };
}

+ (NSDictionary *) playbackTrackToDictionary: (SPTPlaybackTrack *) track
{

    return @{
             @"name": track.name ? track.name : @NO,
             @"uri": track.uri ? track.uri : @NO,
             @"playbackSourceUri": track.playbackSourceUri ? track.playbackSourceUri : @NO,
             @"playbackSourceName": track.playbackSourceName ? track.playbackSourceName : @NO,
             @"artistName": track.artistName ? track.artistName : @NO,
             @"artistUri": track.artistUri ? track.artistUri : @NO,
             @"albumName": track.albumName ? track.albumName : @NO,
             @"albumCoverArtURL": track.albumCoverArtURL ? track.albumCoverArtURL : @NO,
             @"duration": track.duration ? @(track.duration) : @NO,
             @"indexInContext": track.indexInContext ? @(track.indexInContext) : @NO,
             };
}
@end

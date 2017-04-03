const Spotify = require('./Spotify');
import { NativeEventEmitter } from 'react-native';
import { AudioStreaming } from './constants';

export default registerEventHandlers = (dispatch) => {
  const spotifyEmitter = new NativeEventEmitter(Spotify);
  /*
     SPTAudioControllerDelegate
   */
  const logoutSubscription = spotifyEmitter.addListener('audioStreamingDidLogout', (body) => {
    dispatch({
      type: AudioStreaming.SPOTIFY_audioStreamingDidLogout,
    });
    Spotify.stopWithError();
  });
  const receiveErrorSubscription = spotifyEmitter.addListener('audioStreamingDidReceiveError', (body) => {
    console.log('Spotify: Error:', body);
  });
  const loginSubscription = spotifyEmitter.addListener('audioStreamingDidLogin', (body) => {
    dispatch({
      type: AudioStreaming.SPOTIFY_audioStreamingDidLogin,
    });
  });
  const tempConnectionErrorSubscription = spotifyEmitter.addListener('audioStreamingDidEncounterTemporaryConnectionError', (body) => {
    console.log('Spotify: temp connection error:', body);
  });
  const messageSubscription = spotifyEmitter.addListener('audioStreamingdidReceiveMessage', (body) => {
    console.log('Spotify: message:', body);
  });
  const disconnectSubscription = spotifyEmitter.addListener('audioStreamingDidDisconnect', (body) => {
    console.log('Spotify: disconnect', body);
  });
  const reconnectSubscription = spotifyEmitter.addListener('audioStreamingDidReconnect', (body) => {
    console.log('Spotify: reconnect', body);
  });

  /*
  SPTAudioStreamingPlaybackDelegate
    */
  const audioStreamingDidReceivePlaybackEventSubscription = spotifyEmitter.addListener('audioStreamingDidReceivePlaybackEvent', (body) => {
    console.log('Spotify: audioStreamingDidReceivePlaybackEvent', body);
  });
  const audioStreamingDidChangePositionSubscription = spotifyEmitter.addListener('audioStreamingDidChangePosition', (body) => {
    dispatch({
      type: AudioStreaming.SPOTIFY_audioStreamingDidChangePosition,
      position: body.position,
    });
  });
  const audioStreamingDidChangePlaybackStatusSubscription = spotifyEmitter.addListener('audioStreamingDidChangePlaybackStatus', (body) => {
    dispatch({
      type: AudioStreaming.SPOTIFY_audioStreamingDidChangePlaybackStatus,
      isPlaying: body.isPlaying,
    })
  });
  const audioStreamingDidSeekToPositionSubscription = spotifyEmitter.addListener('audioStreamingDidSeekToPosition', (body) => {
    console.log('Spotify: audioStreamingDidSeekToPosition', body);
    dispatch({
      type: AudioStreaming.SPOTIFY_audioStreamingDidSeekToPosition,
      position: body.position,
    });
  });
  const audioStreamingDidChangeVolumeSubscription = spotifyEmitter.addListener('audioStreamingDidChangeVolume', (body) => {
    console.log('Spotify: audioStreamingDidChangeVolume', body);
  });
  const audioStreamingDidChangeShuffleStatusSubscription = spotifyEmitter.addListener('audioStreamingDidChangeShuffleStatus', (body) => {
    console.log('Spotify: audioStreamingDidChangeShuffleStatus', body);
  });
  const audioStreamingDidChangeRepeatStatusSubscription = spotifyEmitter.addListener('audioStreamingDidChangeRepeatStatus', (body) => {
    console.log('Spotify: audioStreamingDidChangeRepeatStatus', body);
  });
  const audioStreamingDidChangeMetadataSubscription = spotifyEmitter.addListener('audioStreamingDidChangeMetadata', (body) => {
    dispatch({
      type: AudioStreaming.SPOTIFY_audioStreamingDidChangeMetadata,
      prevTrack: body.prevTrack,
      currentTrack: body.currentTrack,
      nextTrack: body.nextTrack,
    });
  });
  const audioStreamingDidStartPlayingTrackSubscription = spotifyEmitter.addListener('audioStreamingDidStartPlayingTrack', (body) => {
    console.log('Spotify: audioStreamingDidStartPlayingTrack', body);
  });
  const audioStreamingDidStopPlayingTrackSubscription = spotifyEmitter.addListener('audioStreamingDidStopPlayingTrack', (body) => {
    console.log('Spotify: audioStreamingDidStopPlayingTrack', body);
  });
  const audioStreamingDidSkipToNextTrackSubscription = spotifyEmitter.addListener('audioStreamingDidSkipToNextTrack', (body) => {
    console.log('Spotify: audioStreamingDidSkipToNextTrack', body);
  });
  const audioStreamingDidSkipToPreviousTrackSubscription = spotifyEmitter.addListener('audioStreamingDidSkipToPreviousTrack', (body) => {
    console.log('Spotify: audioStreamingDidSkipToPreviousTrack', body);
  });
  const audioStreamingDidBecomeActivePlaybackDeviceSubscription = spotifyEmitter.addListener('audioStreamingDidBecomeActivePlaybackDevice', (body) => {
    console.log('Spotify: audioStreamingDidBecomeActivePlaybackDevice', body);
  });
  const audioStreamingDidBecomeInactivePlaybackDeviceSubscription = spotifyEmitter.addListener('audioStreamingDidBecomeInactivePlaybackDevice', (body) => {
    console.log('Spotify: audioStreamingDidBecomeInactivePlaybackDevice', body);
  });
  const audioStreamingDidLosePermissionForPlaybackSubscription = spotifyEmitter.addListener('audioStreamingDidLosePermissionForPlayback', (body) => {
    console.log('Spotify: audioStreamingDidLosePermissionForPlayback', body);
  });
  const audioStreamingDidPopQueueSubscription = spotifyEmitter.addListener('audioStreamingDidPopQueue', (body) => {
    console.log('Spotify: audioStreamingDidPopQueue', body);
  });
}

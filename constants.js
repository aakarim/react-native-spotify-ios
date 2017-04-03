import keyMirror from 'keymirror';

export const Events = keyMirror({
  SPOTIFY_AUTH_COMPLETE: null,
});

export const AudioStreaming = keyMirror({
  SPOTIFY_audioStreamingDidLogout: null,
  SPOTIFY_audioStreamingDidReceiveError: null,
  SPOTIFY_audioStreamingDidLogin: null,
  SPOTIFY_audioStreamingDidEncounterTemporaryConnectionError: null,
  SPOTIFY_audioStreamingdidReceiveMessage: null,
  SPOTIFY_audioStreamingDidDisconnect: null,
  SPOTIFY_audioStreamingDidReconnect: null,
  SPOTIFY_audioStreamingDidReceivePlaybackEvent: null,
  SPOTIFY_audioStreamingDidChangePosition: null,
  SPOTIFY_audioStreamingDidChangePlaybackStatus: null,
  SPOTIFY_audioStreamingDidSeekToPosition: null,
  SPOTIFY_audioStreamingDidChangeVolume: null,
  SPOTIFY_audioStreamingDidChangeShuffleStatus: null,
  SPOTIFY_audioStreamingDidChangeRepeatStatus: null,
  SPOTIFY_audioStreamingDidChangeMetadata: null,
  SPOTIFY_audioStreamingDidStartPlayingTrack: null,
  SPOTIFY_audioStreamingDidStopPlayingTrack: null,
  SPOTIFY_audioStreamingDidSkipToNextTrack: null,
  SPOTIFY_audioStreamingDidSkipToPreviousTrack: null,
  SPOTIFY_audioStreamingDidBecomeActivePlaybackDevice: null,
  SPOTIFY_audioStreamingDidBecomeInactivePlaybackDevice: null,
  SPOTIFY_audioStreamingDidLosePermissionForPlayback: null,
  SPOTIFY_audioStreamingDidPopQueue: null,
});

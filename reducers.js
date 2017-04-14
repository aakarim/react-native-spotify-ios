import { Events } from "./constants";
const Spotify = require("./Spotify");
import { Map, Record } from "immutable";
import { combineReducers } from "redux";
import { AudioStreaming } from "./constants";

const PlaybackTrack = new Record({
  name: "",
  uri: "",
  playbackSourceUri: "",
  playbackSourceName: "",
  artistName: "",
  artistUri: "",
  albumName: "",
  albumUri: "",
  albumCoverArtURL: "",
  duration: 0,
  indexInContext: 0
});
const PlaybackMetadata = new Record({
  prevTrack: false,
  currentTrack: false,
  nextTrack: false,
});

const PlaybackState = new Record({
  isPlaying: false,
  isRepeating: false,
  isShuffling: false,
  isActiveDevice: false,
  position: 0
});
const initialState = {
  instance: Spotify,
  auth: Map({
    accessToken: "",
    refreshToken: "",
    loggedIn: false
  }),
  audioStreamingController: Map({
    initialized: false,
    loggedIn: false,
    metadata: new PlaybackMetadata({}),
    volume: 0,
    playbackState: new PlaybackState({}),
    targetBitrate: 0
  })
};

export default (reducers = combineReducers({
  instance: (state = initialState.instance, action) => {
    switch (action.type) {
      case Events.SPOTIFY_AUTH_COMPLETE:
        Spotify.initialize(action.accessToken, action.clientId);
        return Spotify;
      default:
        return state;
    }
  },
  auth: (state = initialState.auth, action) => {
    switch (action.type) {
      case Events.SPOTIFY_AUTH_COMPLETE:
        return state
          .set("accessToken", action.accessToken)
          .set("refreshToken", action.refreshToken);
      case AudioStreaming.SPOTIFY_audioStreamingDidLogin:
        return state.set("loggedIn", true);
      case AudioStreaming.SPOTIFY_audioStreamingDidLogout:
        return state.set("loggedIn", false);
      default:
        return state;
    }
  },
  audioStreamingController: (
    state = initialState.audioStreamingController,
    action
  ) => {
    switch (action.type) {
      case AudioStreaming.SPOTIFY_audioStreamingDidLogin:
        return state.set("loggedIn", true);
      case AudioStreaming.SPOTIFY_audioStreamingDidLogout:
        return state.set("loggedIn", false);
      case AudioStreaming.SPOTIFY_audioStreamingDidSeekToPosition:
      case AudioStreaming.SPOTIFY_audioStreamingDidChangePosition:
        return state.set(
          "playbackState",
          state.get("playbackState").set("position", action.position)
        );
      case AudioStreaming.SPOTIFY_audioStreamingDidChangePlaybackStatus:
        return state.set(
          "playbackState",
          state.get("playbackState").set("isPlaying", action.isPlaying)
        );
      case AudioStreaming.SPOTIFY_audioStreamingDidChangeMetadata:
        return state.set('metadata', new PlaybackMetadata({
          prevTrack: action.prevTrack,
          currentTrack: action.currentTrack,
          nextTrack: action.nextTrack,
        }));
      default:
        return state;
    }
  }
}));

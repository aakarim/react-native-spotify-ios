const Spotify = require('react-native').NativeModules.Spotify;

Spotify.initialize = async function(spotifyToken, clientId) {
  try {
    Spotify.initializeWithClientId(clientId);
    await Spotify.startAudioController();
    Spotify.loginWithAccessToken(spotifyToken);
  } catch(e) {
    console.error(e);
  }
}

module.exports = Spotify; // Module.exports as we are modifying the underlying instance

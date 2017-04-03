import { Events } from './constants';

export const authComplete = (accessToken, refreshToken, clientId) => ({
  type: Events.SPOTIFY_AUTH_COMPLETE,
  accessToken,
  refreshToken,
  clientId,
});

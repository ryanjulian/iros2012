function [ features ] = features_from_episode( episode, window )
%FEATURES_FROM_EPISODE Generates a matrix of features from an episode
%   Author: Ryan C. Julian

% Estimated velocity from Hall effect sensors
velocity = (episode.Rlegs(end)-episode.Rlegs(1))/(episode.Time(end) - episode.Time(1));

% features(:,1) = moving_rms(    episode.GyroX, window );
% features(:,2) = moving_rms(    episode.GyroY, window );
% features(:,3) = moving_rms(    episode.GyroZ, window );
% features(:,4) = moving_stddev( episode.GyroX, window );
% features(:,5) = moving_stddev( episode.GyroY, window );
% features(:,6) = moving_stddev( episode.GyroZ, window );
% features(:,7) = abs(velocity)*ones(length(episode.Time),1 );

% features(1) = abs( velocity );
% features(2) = rms( episode.GyroX );
% features(3) = rms( episode.GyroY );
% features(4) = rms( episode.GyroZ );
% features(5) = std( episode.GyroX );
% features(6) = std( episode.GyroY );
% features(7) = std( episode.GyroZ );

% features(1) = abs( velocity );
% features(2) = std( episode.AccelX );
% features(3) = std( episode.AccelY );
% features(4) = std( episode.AccelZ );
% features(5) = std( episode.GyroX );
% features(6) = std( episode.GyroY );
% features(7) = std( episode.GyroZ );
% features(2) = rms( episode.AccelX );
% features(3) = rms( episode.AccelY );
% features(4) = rms( episode.AccelZ );
% features(5) = rms( episode.GyroX );
% features(6) = rms( episode.GyroY );
% features(7) = rms( episode.GyroZ );

features(1)  = abs( velocity );
features(2)  = moment( episode.AccelX, 2 );
features(3)  = moment( episode.AccelY, 2 );
features(4)  = moment( episode.AccelZ, 2 );
features(5)  = moment( episode.GyroX , 2 );
features(6)  = moment( episode.GyroY , 2 );
features(7)  = moment( episode.GyroZ , 2 );
features(8)  = moment( episode.LBEMF , 2 );
features(9)  = moment( episode.RBEMF , 2 );
features(10) = moment( episode.AccelX, 3 );
features(11) = moment( episode.AccelY, 3 );
features(12) = moment( episode.AccelZ, 3 );
features(13) = moment( episode.GyroX , 3 );
features(14) = moment( episode.GyroY , 3 );
features(15) = moment( episode.GyroZ , 3 );
features(16) = moment( episode.LBEMF , 3 );
features(17) = moment( episode.RBEMF , 3 );
features(18) = moment( episode.AccelX, 4 );
features(19) = moment( episode.AccelY, 4 );
features(20) = moment( episode.AccelZ, 4 );
features(21) = moment( episode.GyroX , 4 );
features(22) = moment( episode.GyroY , 4 );
features(23) = moment( episode.GyroZ , 4 );
features(24) = moment( episode.LBEMF , 4 );
features(25) = moment( episode.RBEMF , 4 );
% features(24) = moment( episode.LBEMF , 5 );
% features(25) = moment( episode.RBEMF , 5 );




%  features(:,1) = moving_stddev( episode.GyroZ,  window );
%  features(:,2) = moving_stddev( episode.AccelZ, window );
%  features(:,3) = abs(velocity)*ones(length(episode.Time), 1);
 
%  features(1) = abs(velocity);
%  features(2) = std( episode.GyroZ );
%  features(3) = std( episode.AccelZ );



end


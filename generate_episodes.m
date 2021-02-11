function [ episodes labels groups ] = generate_episodes( terrain_data, t_episode )
%GENERATE_EPISODES Generate uniform episodes from terrain data
% Author: Ryan C. Julian  

% Number of samples in each episode
samples_per_episode = round(t_episode*terrain_data.sampling_rate);

% Fields in a data set
fn = fieldnames(terrain_data.data{1});

n = 1;
% Terrains
for i = 1:length(terrain_data.data)
    % Trials
    for j = 1:length(terrain_data.data{i})
        % Episodes
        n_samples = length(terrain_data.data{i}(j).(fn{1}));
        offset = rem(n_samples, samples_per_episode); % Trim beginning
        for k = 1:floor(n_samples/samples_per_episode)
            % Fields
            for m = 1:length(fn)
                episodes{n}.(fn{m}) = terrain_data.data{i}(j).(fn{m})(offset+1+(k-1)*samples_per_episode:offset+k*samples_per_episode);
            end
            labels{n} = terrain_data.labels{i};
            n = n+1;
        end
    end
end

% Simple groups, for now
groups = labels;

end


function [ terrain_data ] = import_terrain_data( data_dir, trim, sampling_rate )
%IMPORT_TERRAIN_DATA Import telemetry data for surface classification
% Author: Ryan C. Julian
terrain_data = struct();

% Find directories
d = dir(data_dir);
j = 1;
for i = 1:length(d)
    if d(i).isdir == 1 && ~strcmp(d(i).name, '.') && ~strcmp(d(i).name, '..') && ~strcmp(d(i).name(1),'_')
        labels{j} = d(i).name;
        j = j + 1;
    end
end

% Load Data
for i = 1:length(labels)
    fprintf('\nLoading %s data...\n', labels{i});
    terrain_data.data{i} = read_terrain_data([data_dir '/' labels{i}], trim, sampling_rate);
    %eval(sprintf('terrain_data.terrains.%s = read_terrain_data(''%s/%s'', trim, sampling_rate);',terrains{i}, data_dir, terrains{i}));
end

% Stuff terrain_data struct
terrain_data.sampling_rate = sampling_rate;
terrain_data.labels = labels;

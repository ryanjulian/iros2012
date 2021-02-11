function data = read_terrain_data(data_dir, trim, sampling_rate)
%READ_TERRAIN_DATA Read a directory of OctoRoACH telemetry files
% Ryan C. Julian and Austin Buchan

data_files = dir(sprintf('%s/*.txt',data_dir));

n_files = length(data_files);

fprintf('Found %d files.\n',n_files)

for i = 1:n_files
    data_filename = data_files(i).name;
    data_index = data_filename(end-6:end-4);
    data(i) = read_telemetry_file(sprintf('%s/%s',data_dir,data_filename), trim, sampling_rate);
    fprintf('File %s/%s complete.\n',data_dir,data_filename)
end
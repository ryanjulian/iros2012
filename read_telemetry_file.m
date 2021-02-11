function imudata = read_telemetry_file(filename, trim, sampling_rate)
%
% Read a CSV robot imu datafile , and perform basic conversions to real
% world units.
%
% INPUT
% -filename: path/name of the imu datafile.
%
% OUTPUT
% -imudata: Matlab struct with fields for each of the columns in the
%   datafile. For example, the X axis accelerometer would be imudata.AccelX
%

%Known conversion ratios
conv = ...
   {'Time'      1/1e6; %s
    'Rlegs'     1/42.6; 
    'Llegs'     1/42.6;
    'DCL'       1/2000; %scaled max range
    'DCR'       1/2000;
    'GyroX'     0.00121414209; %Rad/s (from Fernando's Code)
    'GyroY'     0.00121414209;
    'GyroZ'     0.00121414209;
    'GyroZAvg'  0.00121414209;
    'AccelX'    0.0375; %M/s^2
    'AccelY'    0.0379;
    'AccelZ'    0.0392;
    'LBEMF'     3.3/(2.7/(2.7+1))/1024; %V
    'RBEMF'     3.3/(2.7/(2.7+1))/1024};

%known additive offsets. Note that these are applied after the scaling
%ratios
off = ...
   {'AccelX' -0.4474;
    'AccelY' -0.0351;
    'AccelZ'  2.2319;
    'GyroX'  -0.3138;
    'GyroY'   0.0653;
    'GyroZ'  -0.1638;
    'GyroZAvg'  -0.1638};

A = importdata(filename);
imudata = struct();
for i = 1:length(A.colheaders)
    % Trim at the beginning
    tr = round(trim*sampling_rate);
    imudata.(strtrim(A.colheaders{i})) = squeeze(A.data(tr:end,i));
    %imudata.(strtrim(A.colheaders{i})) = squeeze(A.data(:,i));
end

% Multiply by conversion factors
for i = 1:length(conv)
    f = conv{i,1};
    if(isfield(imudata,f))
        imudata.(f) = imudata.(f)*conv{i,2};
    end
end

% Add offsets
for i = 1:length(off)
    f = off{i,1};
    if(isfield(imudata,f))
        imudata.(f) = imudata.(f) + off{i,2};
    end
end
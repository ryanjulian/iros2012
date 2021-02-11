% OctoRoACH Terrain Classifier
% Author: Ryan C. Julian
% clc; close all; clear all;
% addpath([pwd '\libsvm-3.11\windows']);
% addpath([pwd '\filters']);
% addpath([pwd '\export_fig']);
%% Classifier parameters
DATA_DIR        = 'terrain_data_duncaroach'; % Name of directory with terrain data
TRIM            = 0.25;             % Seconds to trim from input data
SAMPLING_RATE   = 300;              % Data sampling rate
EPISODE_LENGTH  = 0.350;            % Length of a training episode in seconds
MIN_SPEED       = 2.3;              % Minimum (rps) speed to attempt classification 
MAX_SPEED       = 20;               % Max (rps) speed to accept (filters out speed calculation errors)
TEST_PERCENT    = 0.25;             % Proportion the data reserved for testing
TRAIN_OPTIONS   = '-s 0 -t 2';      % LIBSVM training options
%.350
GAMMA           = 0.3132;
SOFT_MARGIN     = 530.0556;
%GAMMA           = 0.7228;           % RBF kernel standard deviation
%SOFT_MARGIN     = 181.019;          % SVM soft margin
PREDICT_OPTIONS = '';                % LIBSVM predict options

%% Import data
fprintf('Importing data...\n');
terrain_data = import_terrain_data(DATA_DIR, TRIM, SAMPLING_RATE);
save([DATA_DIR '_data.mat'],'terrain_data');

%% Generate uniform-length episodes
fprintf('Generating episodes...\n');
[episodes labels groups] = generate_episodes(terrain_data, EPISODE_LENGTH);
save([DATA_DIR '_episodes.mat'],'episodes','groups','labels');

%% Partitiion the episodes into training and test sets
fprintf('Separating training and test episodes...\n');
[train test] = crossvalind('HoldOut', groups, TEST_PERCENT);

%% Generate features
fprintf('Extracting feature vectors...\n');
% Make a dictionary for label numbers
unique_labels = unique(labels);
label_mapping = containers.Map( unique_labels, 1:length(unique_labels) );

% Generate feature vectors
[train_features train_labels] = generate_features(episodes(train), labels(train), label_mapping, 0);
[test_features test_labels] = generate_features(episodes(test), labels(test), label_mapping, 0);
save([DATA_DIR '_features.mat'],'train_features','train_labels','test_features','test_labels');

% Remove low and (too) high
keep = train_features(:,1) > MIN_SPEED & train_features(:,1) < MAX_SPEED;
train_features = train_features(keep,:);
train_labels = train_labels(keep,:);

keep = test_features(:,1) > MIN_SPEED & test_features(:,1) < MAX_SPEED;
test_features = test_features(keep,:);
test_labels = test_labels(keep,:);

% Normalize the features to [0,1]
[train_features, offsets, weights] = normalize_features(train_features);
test_features = normalize_features(test_features, offsets, weights);

save([DATA_DIR '_train_features.mat'],'train_features','train_labels');

%% Train the SVM using the training set
fprintf('Training...\n');
% Automatic grid search tuning
% Source: Xu Cui, http://www.alivelearn.net/?p=912, via LibSVM
% RBF
% log2c = 8.05:0.005:9.5;
% log2g = -2:0.005:-1;
% bestcv = 0;
% results = 91.6898*ones(length(log2c),length(log2g));
% figure;
% for i = 1:length(log2c)
%   for j = 1:length(log2g)
%       if ((log2c(i) >= -2*log2g(j)+5.5) && (log2c(i) <= -2*log2g(j)+6) && ((log2c(i) >= 8.9 && log2c(i) <= 9.35) || (log2c(i)>= 8.2 && log2c(i) <= 8.5) ))
%         cmd = ['-q -v 10 -c ', num2str(2^log2c(i)), ' -g ', num2str(2^log2g(j))];
%         cv = svmtrain(train_labels, train_features, cmd);
%         results(i,j) = cv;
%         if (cv >= bestcv),
%           bestcv = cv; bestc = 2^log2c(i); bestg = 2^log2g(j);
%         end
%         fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c(i), log2g(j), cv, bestc, bestg, bestcv);
%       end
%   end
%   clf; contour(log2g,log2c,results,50); drawnow;
% end
% % Linear
% bestcv = 0;
% for log2c = -0.1:0.1:5,
%     cmd = ['-t 0 -q -v 10 -c ', num2str(2^log2c)];
%     cv = svmtrain(train_labels, train_features, cmd);
%     if (cv >= bestcv),
%       bestcv = cv; bestc = 2^log2c;
%     end
%     fprintf('%g %g (best c=%g, rate=%g)\n', log2c, cv, bestc, bestcv);
% end
% Polynomial
% bestcv = 0;
% for deg = 1:5
%     for log2c = 1:0.5:5,
%       for log2g = -2:0.5:2
%           for log2coef = -6:0.5:6
%             cmd = ['-t 1 -q -v 10 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
%             cv = svmtrain(train_labels, train_features, cmd);
%             if (cv >= bestcv),
%               bestcv = cv; bestc = 2^log2c; bestg = 2^log2g; bestcoef = 2^log2coef; bestdeg = deg;
%             end
%             fprintf('%g %g %g %g %g (best c=%g, g=%g, doef0=%g, deg=%g, rate=%g)\n', log2c, log2g, log2coef, deg, cv, bestc, bestg, bestcoef, bestdeg, bestcv);
%           end
%       end
%     end
% end
tic;
model = svmtrain(train_labels, train_features, [TRAIN_OPTIONS ' -g ' num2str(GAMMA) ' -c ' num2str(SOFT_MARGIN)]);
toc;
%save([DATA_DIR '_model.mat'],'model');

%% Evaluate performance using the test set
fprintf('Testing...\n');
[predicted_labels, accuracy, decision] = svmpredict(test_labels, test_features, model, PREDICT_OPTIONS);
for t = 1:length(unique_labels)     % True
    for p = 1:length(unique_labels) % Predicted
        true_set = (test_labels == t);
        pred_set = (test_labels == t) & (predicted_labels == p);
        display(sprintf('True: %s, Predicted: %s, %f %%', unique_labels{t}, unique_labels{p}, 100*sum(pred_set)/sum(true_set)));
    end
end
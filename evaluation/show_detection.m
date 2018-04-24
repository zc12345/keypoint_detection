%% Show detection result of test images
function show_detection()
close all;clear;clc;

addpath('../');
addpath('model-train');

USE_GPU = 0; % 1 for GPU

model_dir = '../data/models/';
model_file = 'keypoint-netv4-16points.mat';
model_fn = [model_dir, model_file];
matconvnet_dir = '../../matconvnet/';
img_dir = '../getData/data/validation/image/';
prediction_dir = '../getData/data/validation/prediction/';

if exist(prediction_dir) == 0
    mkdir(prediction_dir);
end

% setup matconvnet and init detector
matconvnet_setup_fn = fullfile(matconvnet_dir, 'matlab', 'vl_setupnn.m');
run(matconvnet_setup_fn);
keypoint_detector = KeyPointDetector(model_fn, matconvnet_dir, USE_GPU);

% get all test images
img_dirs = dir([img_dir, '*.jpg']);
img_dircell = struct2cell(img_dirs)';
img_names = img_dircell(:, 1);

% show detection result
for i = 1:numel(img_names)
    img_fn = [img_dir, char(img_names(i))];
    fn = char(img_names(i));
    k = find('.' == fn);
    prediction_fn = [prediction_dir, fn(1:k-1),'.txt'];
    disp(prediction_fn);%show file name
    gen_prediction(keypoint_detector, img_fn, prediction_fn);
    %show(keypoint_detector, img_fn);
end

end

%% generate prediction annotations
function gen_prediction(keypoint_detector, img_fn, prediction_fn)
[kpx, kpy, kpname] = get_all_keypoints(keypoint_detector, img_fn);
fid = fopen(prediction_fn, "wt");
for i=1:numel(kpx)
    fprintf(fid,"%d %d\n",kpx(i),kpy(i));
end
fclose(fid);
end

%% display details 
function show(keypoint_detector, img_fn)
fprintf('Detecting keypoints in image : %s', img_fn);
voffset = 20;
[kpx, kpy, kpname] = get_all_keypoints(keypoint_detector, img_fn);
img = imread(img_fn);
figure('Name',img_fn);
imshow(img);
hold on;
plot(kpx, kpy, '-ro');
text(kpx + voffset, kpy + voffset, kpname); 
for i = 1:numel(kpx)
    fprintf('\n%s\tat\t(%d,%d)', kpname{i}, kpx(i), kpy(i));
end
hold off;
pause(1);
end

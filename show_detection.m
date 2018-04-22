%% Show detection result of test images

close all;clear;clc;

addpath('model-train');

USE_GPU = 0; % 1 for GPU

model_dir = './data/';
model_file = 'keypoint-netv2-noflip.mat';
model_fn = [model_dir, model_file];
matconvnet_dir = '../matconvnet/';
img_dir = './data/validation/image/';

%% setup matconvnet and init detector
matconvnet_setup_fn = fullfile(matconvnet_dir, 'matlab', 'vl_setupnn.m');
run(matconvnet_setup_fn);

keypoint_detector = KeyPointDetector(model_fn, matconvnet_dir, USE_GPU);

%% show detection
% get all test images
img_dirs = dir([img_dir, '*.jpg']);
img_dircell = struct2cell(img_dirs)';
img_names = img_dircell(:, 1);

% show detection result
for i = 1:numel(img_names)
    img_fn = [img_dir, char(img_names(i))];
    show(keypoint_detector, img_fn);
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

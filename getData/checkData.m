clearvars;close all;clc;
% PATH CONFIG
data_path = './data/';
img_path = './data/image/';

% ============================MAIN

data = load_data(data_path);
patch_bugs(img_path, data);

imgSize = [256,256];
detector = 0;
oracleTr = 0;
baseH = 300;
baseW = 300;
sets_train = zeros(length(data.img_train),1);%!data.img_train
cnt = 0;
cnt_test = 0;
point_num = 8;

%h = waitbar(0,'processing dataset......');
for i = 1:length(data.img_train)%!data.img_train
    img_name = data.annolist(i).image.name;
    img = load_img(img_name, img_path);
    
    if data.img_train(i) == 0 
        cnt_test = cnt_test + 1;
        %resize to standard size
        s_s = [size(img, 1) size(img,2)];
        s_t = [imgSize(1) imgSize(2)];
        s = s_s.\s_t; 
        %image resized
        img_final{cnt_test} = imresize(img, 'scale', s, 'method', 'bilinear');
    end
    
    if isfield(data.annolist(i).annoroad,'annopoints')%GT exists
        cnt = cnt + 1;
        sets_train(i) = 1;
        sets_train_idx(cnt) = i;
        % store keypoints
        ptsAll{cnt} = zeros(point_num,3);
        poseGT = data.annolist(i).annoroad.annopoints.point;
        for p = 1:numel(poseGT)
            ptsAll{cnt}(poseGT(p).id,1) = poseGT(p).x;
            ptsAll{cnt}(poseGT(p).id,2) = poseGT(p).y;
            ptsAll{cnt}(poseGT(p).id,3) = 1;
        end
        %resize to standard size
        s_s = [size(img,1) size(img,2)];
        s_t = [imgSize(1) imgSize(2)];
        s = s_s.\s_t;
        tf = [ s(2) 0 0; 0 s(1) 0; 0  0 1];
        T = affine2d(tf);
        %这里keypoint 在resize后取整的时候有一点问题，待修复       
        %points scaled
        [ptsAll{cnt}(:,1),ptsAll{cnt}(:,2)] = transformPointsForward(T, ptsAll{cnt}(:,1),ptsAll{cnt}(:,2));
    end    
    %waitbar(i/length(data.img_train));%!data.img_train
    disp(['Processing data No.',num2str(i) ,' img name:',img_name])
end
%close(h);
storefile=sprintf('./data/extractedData_%d_%d',imgSize(1),imgSize(2));
save(storefile,'img_final','ptsAll','sets_train','sets_train_idx');
% =============================MAIN

% load img data
function img = load_img(img_name,img_path)
img_file_path = [img_path,img_name];
if exist(img_file_path,'file')
    img = imread(img_file_path);
else
    img = [];
    disp(['~check img data:',img_name]);
end
end

% load raw annotation data
function data = load_data(data_path)

filename = 'rawdata';
load([data_path, filename, '.mat']);
testMap = zeros(numel(data.annolist),2);
N = length(data.annolist);

end

% check data type & patch bugs
function patch_bugs(img_path,data)

for i = 1:numel(data.annolist)
    img_name = data.annolist(i).image.name;
    if isfield(data.annolist(i).annoroad,'annopoints') && exist([img_path,img_name],'file')%check GT exist
        for j = 1: numel(data.annolist(i).annoroad.annopoints.point)
            num = data.annolist(i).annoroad.annopoints.point(j);
            if ~(isnumeric(num.id) && isnumeric(num.x) && isnumeric(num.y))
                disp(['~check error data: No.',num2str(i),' point ',num2str(j)]);
            end
        end
    else
        disp(['~check error data No.',num2str(i)]);
    end
end
disp('complete data-check~');

end



%%Extract foreground objects by optical flow
%%Yaochen Li
%%2013-7-3
function extractByOpticalFlow
clc;
clear all;
addpath('mex');

% set optical flow parameters (see Coarse2FineTwoFrames.m for the definition of the parameters)
alpha = 0.012;
ratio = 0.75;
minWidth = 40;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;

para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];

img_dir = '../../../data/val-sequence/image/';
anno_dir = '../../../data/val-sequence/annotation/';
pred_dir = '../../../data/val-sequence/optical-flow-annotation/';
sequence_len = 5; % every 5 imgs choose a base-image

img_args = struct2cell(dir([img_dir,'*.jpg']));
img_fns = img_args(1,:);
for i = 1:numel(img_fns)
    if mod(i,sequence_len) == 1
    fn = char(img_fns(i));
    k = find('.' == fn);
    baseImg= char(fullfile(img_dir,img_fns(i)));
    baseAnno = [anno_dir, fn(1:k-1),'.xml'];
    im1=imread(baseImg);
    [pxs,pys]=getXml(baseAnno);
    imshow(im1);hold on;plot(pxs,pys,'y.','MarkerSize', 20);
    batchProcess(img_dir, im1, pxs, pys, para, i, sequence_len);
    end
end

end

function batchProcess(img_path, im1, pxs, pys, para, start, len)
img_args = struct2cell(dir([img_path,'*.jpg']));
img_fns = img_args(1,:);

for i=start : (start + len)
    img_fn = char(fullfile(img_path,img_fns(i)));
    singleProcess(img_fn, im1, pxs, pys, para);
end
end

function singleProcess(file, im1, pxs, pys, para)
out1 = int64(pxs');
out2 = int64(pys');
fileName2=file;
im2 = imread(file);

% this is the core part of calling the mexed dll file for computing optical flow
% it also returns the time that is needed for two-frame estimation
tic;
[vx,vy,warpI2] = Coarse2FineTwoFrames(im1,im2,para);
toc

%figure;imshow(im1);figure;imshow(warpI2);

% visualize flow field
clear flow;
flow(:,:,1) = vx;
flow(:,:,2) = vy;
imflow = flowToColor(flow);
%figure;imshow(imflow);

pOut1=[];
pOut2=[];
boundFlow=[];
for i=1:size(out1,1)
    tX=out1(i);
    tY=out2(i);
    xSpeed=int64(flow(tY,tX,1));
    ySpeed=int64(flow(tY,tX,2));
    tX=double(tX+xSpeed);
    tY=double(tY+ySpeed);
    pOut1=[pOut1 tX];
    pOut2=[pOut2 tY];
    boundFlow=[boundFlow;xSpeed ySpeed];
end

pOut1=pOut1';
pOut2=pOut2';
%figure;
%imshow(im2);hold on;
%plot(pOut1,pOut2,'b.-');
%disp('--------------->ok');

%[h1,w1,r1,N1]=size(im2);
%for i=1:w1
%    for j=1:h1
%    in = inpolygon(i,j,pOut2,pOut1);
%    if(in==0)
%        im2(i,j,:)=[190 190 0];
%    end
%    end
%end
% 
% figure(4);
% imshow(im2);
% 
% out1=pOut1;
% out2=pOut2;
% 
% minX=min(out1);
% maxX=max(out1);
% minY=min(out2);
% maxY=max(out2);
% 
% figure(4);
% im3=imcrop(im2,[minX minY 119 119]);
% imshow(im3);
% save([fileName2 '_bound.mat'],'out1','out2');

%fid=fopen(['./test/' tmp '.txt'],'w');
%for i=1:size(out1,1)
%    fprintf(fid,'%5d',out1(i));
%    fprintf(fid,'%5d',out2(i));
%    fprintf(fid,'\n');
%end
%fclose(fid);

%imwrite(im3,['./test/' tmp '.bmp'],'bmp');
%imwrite(im2,['./test/' tmp '_f.bmp'],'bmp');
disp('--------------->ok');
%close all;

end

function gen_prediction(kpx, kpy, prediction_fn)
fid = fopen(prediction_fn, 'wt');
for i=1:numel(kpx)
    fprintf(fid,'%d %d\n',kpx(i),kpy(i));
end
fclose(fid);
end
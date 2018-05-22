%%%Optical flow now
%%%Charles Lee
%%%2015-12-9


clc;
clear all;

alpha = 0.012;
ratio = 0.75;
minWidth = 40;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;

im1=imread('./test/02613a Panorama.jpg_mid.bmp_level2.bmp');
im2=imread('./test/02614a Panorama.jpg_mid.bmp_level2.bmp');

para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];

% this is the core part of calling the mexed dll file for computing optical flow
% it also returns the time that is needed for two-frame estimation
tic;
[vx,vy,warpI2] = Coarse2FineTwoFrames(im1,im2,para);
toc

figure;imshow(im1);figure;imshow(warpI2);


% visualize flow field
clear flow;
flow(:,:,1) = vx;
flow(:,:,2) = vy;
imflow = flowToColor(flow);
figure;imshow(imflow);

disp('----------------->ok');
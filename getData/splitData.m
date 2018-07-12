clearvars;
% split data into train dataset & validation dataset
imgSize=[256, 256];
%[img_final, ptsAll, sets_train, sets_train_idx]
load(sprintf('./data/extractedData_%d_%d',imgSize(1),imgSize(2)));

ptsAll_train=[];
imgPath_train=[];
ptsAll_test=[];
imgPath_test=[];
point_num = 8;
idx=1:point_num;

for i=1:numel(sets_train_idx)
    poseGT = ptsAll{i}(idx,:);
    ptsAll_train{1,size(ptsAll_train,2)+1}=poseGT;
    imgPath_train{numel(imgPath_train)+1}=img_final{i}; 
    % ptsAll_test{1,size(ptsAll_test,2)+1}=poseGT;
    clear poseGT;
end

clear ptsAll;

ptsAll=ptsAll_train;
imgPath=imgPath_train;
save('../data/MPI_imdbsT1aug0.mat','imgPath','ptsAll'); 

clear ptsAll imgPath;

ptsAll=ptsAll_test;
imgPath=imgPath_test;
save('../data/MPI_imdbsV1aug0.mat','imgPath','ptsAll'); 

disp('split data over');

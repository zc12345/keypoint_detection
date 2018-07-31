%% main
train_img_path = './data/image/';
train_anno_path = './data/annotation/';
%val_img_path = './car/val/image/';
%val_anno_path = './car/val/annotation/';
train_save_path = './data/data.mat';
%val_save_path = './car/val/data.mat';
data_path = './data/';
train_path = './data/extractedData_train';
%val_path = './car/extractedData_val';
train_save = '../data/MPI_imdbsT1aug0.mat';
%val_save = '../data/MPI_imdbsV1aug0.mat';

point_select = [1:16];
point_num = numel(point_select);
imgSize = [256,256];

getData(point_select, train_img_path, train_anno_path, train_save_path);
checkData(point_num, imgSize, train_save_path, train_img_path, train_path);
%getData(point_select, val_img_path, val_anno_path, val_save_path);
%checkData(point_num, imgSize, train_save_path, val_img_path, val_path);
splitData(point_num, train_path, train_save);
%splitData(point_num, val_path, val_save);
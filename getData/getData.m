function data = getData()

addpath('../evaluation');
clear;clc;

% check filename num in dir
img_path = './car-train/image/';
anno_path = './car-train/annotation/';

dirs = dir([img_path,'*.jpg']);
dircell = struct2cell(dirs)';
imgnames = dircell(:,1);
n = size(imgnames);
filename = cell(n);
annoroad = cell(n);
anno_images = cell(n);

% get image names & xml file names
for i = 1:size(imgnames)
    file_name = char(imgnames(i));
    k = find('.'== file_name);
    filename{i} = file_name(1:k-1);%remove suffix
end

% read rgb images & xml annotations

disp('loading...');

for i = 1:size(imgnames)
    
    xml_path = [anno_path,filename{i},'.xml'];
    [annoKpx, annoKpy, scale, type] = getXml(xml_path);
    m = numel(annoKpx);

    id = cell(1,m);xaxis = cell(1,m);yaxis = cell(1,m);
    for j = 1:m
        id{j} = j;
        xaxis{j} = annoKpx(i);
        yaxis{j} = annoKpy(j);
        
    end
    point = struct('id',id,'x',xaxis,'y',yaxis);
    annopoints.point = point;
    anno_images{i}.name = [filename{i}, '.jpg'];
    annoroad{i} = struct('type',type,'scale',scale,'annopoints',annopoints);
    
    % set train/val 
    img_train(i) = 0;
end

annolist = struct('image',anno_images,'annoroad',annoroad);
data = struct('annolist',annolist,'img_train',img_train);

% put all data into struct data

save('./car-train/rawdata.mat','data');
disp('over');

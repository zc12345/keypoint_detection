%function img_anno()
%-------------------------------------------
clear;clc;

%% PATH
img_path = '../data/image/';
anno_path = '../data/annotation/';
point_num = 8;

img_annotation(img_path, anno_path, point_num);

close all;

%% show image and add annotation
function img_annotation(img_path, anno_path, point_num)

dirs = dir([img_path,'*.jpg']);
dircell = struct2cell(dirs)';
imgnames = dircell(:,1);

for i = 1:size(imgnames)
    file_name = char(imgnames(i));
    k = find('.'== file_name);
    name = file_name(1:k-1);%remove suffix
    disp(['add annotation to ',file_name]);
    [x,y]=get_coord([img_path, file_name], point_num);
    target_path = [anno_path,name,'.xml'];
    update(x,y,target_path);
end

end

%% get mouse input
function [x,y]=get_coord(file_path, point_num)
img = imread(file_path);
figure;
x = [];
y = [];
offset = -10;
imshow(img);hold on;
for i = 1:point_num
    [x(i),y(i)] = ginput(1);
    plot(x(i),y(i),'r+');
    text(x(i),y(i)+offset, sprintf('point %i',i));
end
fprintf('x=%f,y=%f\n',x,y);
hold off;
close;
end

%% update xml annotation files
function update(x, y, target_path)

annotationNode = com.mathworks.xml.XMLUtils.createDocument('annotation');
annotation = annotationNode.getDocumentElement;
scaleNode = annotationNode.createElement('scale');
scaleNode.appendChild(annotationNode.createTextNode(sprintf('1.0')));
annotation.appendChild(scaleNode);
typeNode = annotationNode.createElement('type');
typeNode.appendChild(annotationNode.createTextNode(sprintf('stright')));
annotation.appendChild(typeNode);
pointsNode = annotationNode.createElement('points');

for i=1:length(x)
    pointNode = annotationNode.createElement('point');
    idNode = annotationNode.createElement('id');
    xaxisNode = annotationNode.createElement('xaxis');
    yaxisNode = annotationNode.createElement('yaxis');
    idNode.appendChild(annotationNode.createTextNode(sprintf('%i',i)));
    xaxisNode.appendChild(annotationNode.createTextNode(sprintf('%f',x(i))));
    yaxisNode.appendChild(annotationNode.createTextNode(sprintf('%f',y(i))));
    pointNode.appendChild(idNode);
    pointNode.appendChild(xaxisNode);
    pointNode.appendChild(yaxisNode);
    pointsNode.appendChild(pointNode);
end
annotation.appendChild(pointsNode);

xmlwrite(target_path, annotationNode);
end

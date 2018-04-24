function [annoKpx, annoKpy] = getXml(GTpath)
try
    xDoc = xmlread(GTpath);
catch
    error('Failed to read XML file %s.',GTpath);
end

annotationNode = xDoc.getElementsByTagName('annotation').item(0);
pointsNode = annotationNode.getElementsByTagName('points').item(0);
point_list = pointsNode.getElementsByTagName('point');
n = point_list.getLength;
annoKpx = zeros(1,n);
annoKpy = zeros(1,n);

for j = 0:n-1
    pointNode = point_list.item(j);
    idText = pointNode.getElementsByTagName('id').item(0).getTextContent();
    id{j+1} = str2num(char(idText));
    xaxis = str2num(char(pointNode.getElementsByTagName('xaxis').item(0).getTextContent()));
    yaxis = str2num(char(pointNode.getElementsByTagName('yaxis').item(0).getTextContent()));        
    annoKpx(j+1)=xaxis;
    annoKpy(j+1)=yaxis;
end
%disp(['load ',GTpath, ' success']);
end

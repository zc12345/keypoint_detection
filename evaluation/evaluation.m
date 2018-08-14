function evaluation()

GTdir = '../getData/data/val-sequence/annotation/';
predDir = '../getData/data/val-sequence/prediction/';
imgDir = '../getData/data/val-sequence/image/';
batch_eval(GTdir, predDir, imgDir);

end

function batch_eval(GTdir, predDir, imgDir)

GT_args = struct2cell(dir([GTdir,'*.xml']));
pred_args = struct2cell(dir([predDir,'*.txt']));
img_args = struct2cell(dir([imgDir,'*.jpg']));
GT_fns = GT_args(1,:);
pred_fns = pred_args(1,:);
img_fns = img_args(1,:);
loss = 0;
for i = 1:numel(GT_fns)
    GTpath = char(fullfile(GTdir, GT_fns(i)));
    predPath = char(fullfile(predDir, pred_fns(i)));
    imgPath = char(fullfile(imgDir, img_fns(i)));
    single_loss = single_eval(GTpath, predPath, imgPath); 
    loss = loss + single_loss;
end
disp(sprintf('========\ntotal loss=%f',loss));
disp(sprintf('========\naverage loss=%f',loss/numel(GT_fns)));
end

function loss = single_eval(GTpath, predPath, imgPath)

[annoKpx, annoKpy, ~] = getXml(GTpath);
[GTkpx, GTkpy] = gen_line(annoKpx, annoKpy);
[predKpx, predKpy] = textread(predPath, '%d%d');
[predKpx, predKpy] = gen_line(predKpx, predKpy);
loss = caculate_loss(GTkpx, GTkpy, predKpx, predKpy);
disp(sprintf('loss=%f',loss));
%show(imgPath, GTkpx, GTkpy, predKpx, predKpy);
end

function loss = caculate_loss(GTkpx, GTkpy, predKpx, predKpy)
% caculate loss
predPoints(1,:) = predKpx;
predPoints(2,:) = predKpy;
loss = 0;
for point = predPoints
    distance = sqrt((GTkpx - point(1)).^2 + (GTkpy - point(2)).^2);
    loss = loss + min(distance);
end
loss = loss/numel(predPoints);
end

function show(imgPath, GTkpx, GTkpy, predKpx, predKpy)
% show GT & prediction in picture
img = imread(imgPath);
figure('Name',imgPath);
imshow(img);hold on;
plot(GTkpx,GTkpy,'g.');hold on;
plot(predKpx,predKpy,'r.', 'MarkerSize', 20);hold on;
hold off;
pause(1);
end

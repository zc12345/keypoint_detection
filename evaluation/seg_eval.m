%% evaluate segmentation results
function eval_seg()

img_dir = '../getData/data/val-sequence/image/';
anno_dir = '../getData/data/val-sequence/annotation/';
pred_dir = '../getData/data/val-sequence/prediction/';
gt_mask_dir = '../getData/data/val-sequence/gt_mask/';
pred_mask_dir = '../getData/data/val-sequence/pred_mask/';

% get all img names
dirs = dir([img_dir,'*.jpg']);
dircell = struct2cell(dirs)';
imgnames = dircell(:,1);
n = numel(imgnames);
filename = cell(n);
for i = 1:size(imgnames)
    file_name = char(imgnames(i));
    k = find('.'== file_name);
    filename{i} = file_name(1:k-1);%remove suffix
end

% eval segmentation results
score = zeros(1, n);
for i = 1:n
   img_path = [img_dir, filename{i}, '.jpg'];
   gt_anno = [anno_dir, filename{i}, '.xml'];
   pred_anno = [pred_dir,filename{i}, '-16point.txt'];
   gt_mask_path = add_mask(img_path, gt_anno, filename{i}, gt_mask_dir);
   pred_mask_path = add_mask(img_path, pred_anno, filename{i}, pred_mask_dir);
   iou = get_performance_iou_binary(pred_mask_path, gt_mask_path);
   score(1,i)=iou;
end
figure;
x = [1:n];
plot(x,score);hold on;
xlabel('frame');
ylabel('IoU');
grid on;
print(gcf, '-dpng', 'result.png');

end

%% add mask according to annotation points
function mask_path = add_mask(img_path, annotation, img_fn, mask_dir)
img = imread(img_path);
if annotation(end-3:end)=='.xml'
    [pOut1 pOut2 ~] = getXml(annotation);
elseif annotation(end-3:end) == '.txt'
    [pOut1 pOut2] = textread(annotation);
    pOut1 = pOut1'; 
    pOut2 = pOut2';
else
    fprintf('anotation %s file type is wrong',annotation);
    return;
end
[h w d] = size(img);
pOut1 = [0 pOut1 w];
pOut2 = [h pOut2 h];
tmp = ones([h w]);
mask = roipoly(tmp, pOut1, pOut2);
%imshow(mask);
mask_path = [mask_dir,img_fn, '.png'];
imwrite(mask, mask_path,'png');

end

%% get IoU score
function performance =  get_performance_iou_binary(result_path, gt_path)
% background & foreground color
bg_color = 1;
fg_color = 0;

% check img size
ImgResult = imread(result_path);
ImgGT = imread(gt_path);
[rh, rw, rd] = size(ImgResult);
[gh, gw, gd] = size(ImgGT);
if rh~=gh || rw~=gw || rd~=gd
    fprintf('ImgResult & ImgGT size dismatch!');
    return;
end

intersection = 0;
unionsection = 0;
for i = 1:rh
    for j = 1:rw
        if ImgResult(i,j)==fg_color && ImgGT(i,j)==fg_color
            intersection = intersection + 1;
        end
        if ImgResult(i,j)==fg_color || ImgGT(i,j)==fg_color
            unionsection = unionsection + 1;
        end
    end
end
if unionsection == 0
    performance = 100.0;
else
    performance = 100.0*intersection/unionsection;
end
end
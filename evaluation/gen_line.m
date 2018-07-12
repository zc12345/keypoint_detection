%% using interpret function, generate boundary lines according to keypoints
function [interpOut1, interpOut2] = gen_line(annoKpx, annoKpy)

out1 = single(annoKpx');
out2 = single(annoKpy');

interpOut1=[];
interpOut2=[];

% interpret points
 for i=1:size(out1,1)-1
    xIndex1=out1(i);
    yIndex1=out2(i);
    xIndex2=out1(i+1);
    yIndex2=out2(i+1);
    
    interpOut1=[interpOut1 xIndex1];
    interpOut2=[interpOut2 yIndex1];
    
    if(xIndex2~=xIndex1||yIndex2~=yIndex1)
    
    if(xIndex2>xIndex1)
        tmpX=[xIndex1 xIndex2];
        tmpY=[yIndex1 yIndex2];
        xIndex3=xIndex1:1:xIndex2;
        yIndex3=interp1(tmpX,tmpY,xIndex3);
    end
        
    if(xIndex2<xIndex1)
        tmpX=[xIndex1 xIndex2];
        tmpY=[yIndex1 yIndex2];
        xIndex3=xIndex1:-1:xIndex2;
        yIndex3=interp1(tmpX,tmpY,xIndex3);
    end
    
    if(xIndex2==xIndex1&&yIndex2>=yIndex1)
        tmpX=[xIndex1 xIndex2];
        tmpY=[yIndex1 yIndex2];
        
        yIndex3=yIndex1:1:yIndex2;
        xIndex3=interp1(tmpY,tmpX,yIndex3);
    end
    
    if(xIndex2==xIndex1&&yIndex2<yIndex1)
        tmpX=[xIndex1 xIndex2];
        tmpY=[yIndex1 yIndex2];
        
        yIndex3=yIndex1:-1:yIndex2;
        xIndex3=interp1(tmpY,tmpX,yIndex3);
    end
    xIndex3=round(xIndex3);
    yIndex3=round(yIndex3);
    t1=size(xIndex3,2);
    t2=size(yIndex3,2);
    
    if(t1>2)
    xIndex4=xIndex3(2:t1-1);
    yIndex4=yIndex3(2:t2-1);  
    interpOut1=[interpOut1 xIndex4];
    interpOut2=[interpOut2 yIndex4];
    end
    end
 end

end
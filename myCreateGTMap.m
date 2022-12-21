function GT_Map = myCreateGTMap(GT_MaskImg, BlockSize, Step)

GT_Mask = imread(GT_MaskImg);
GT_Mask(GT_Mask==255) = 1;
% Step=32;
% BlockSize=64;
% Resize GT image to ClassMap type
GT_Map = [];
for X=1:Step:size(GT_Mask,1)
    if X+BlockSize-1<=size(GT_Mask,1)
        StartX=X;
    else
        StartX=size(GT_Mask,1)-BlockSize+1;
        X=size(GT_Mask,1);
    end
    for Y=1:Step:size(GT_Mask,2)
        if Y+BlockSize-1<=size(GT_Mask,2)
            StartY=Y;
        else
            StartY=size(GT_Mask,2)-BlockSize+1;
            Y=size(GT_Mask,2);
        end
        block = GT_Mask(StartX:StartX+BlockSize-1,StartY:StartY+BlockSize-1);
        num_ones = length(find(block==1));
        num_zeros = length(find(block==0));
        if num_ones >= num_zeros
            Class = 1;
        else
            Class = 0;
        end
      GT_Map(ceil((StartX-1)/Step+1),ceil((StartY-1)/Step+1))=Class;
    end
end
% GT_Map=[repmat(GT_Map(1,:),ceil(BlockSize/2/Step),1);GT_Map];
% GT_Map=[repmat(GT_Map(:,1),1,ceil(BlockSize/2/Step)) GT_Map];
end
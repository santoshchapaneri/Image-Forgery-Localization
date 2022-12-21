clc;clear;close all;

DBPath='C:\Users\Sony\Desktop\project\chroma_LBP\20_11_17\UCID\Uncomp\';
DCPPath='C:\Users\Sony\Desktop\project\project_3\Images8\UnForgedTrainingImages\';

Images=dir([DBPath '*.png']);
Images={Images.name};
W = 8;

% Choose 1-500 for background, 501-600 for patch images
% PatchImages = cell(1,100);
% Patch = cell(1,100);
% for i=501:1000
%     im=imread([DBPath Images{i}]);
%     PatchImages{i-500} = Images{i};
%     
%     % Choose a W x W patch randomly
%     loc_i = randi(size(im,1)-2*W);
%     loc_j = randi(size(im,2)-2*W);
%     Patch{i-500} = im(loc_i:loc_i+W-1,loc_j:loc_j+W-1,:);
% end

% % DCP scenario
% QF1=50:5:95;
% QF2=50:5:95;

k = 1;
while k<=500
    %im=imread(Patch{1,k});
%     for i = QF1
%         QualityInd_i=round((i-50)/5+1);
%         if QualityInd_i>10
%             QualityInd_i=10;
%         elseif QualityInd_i<1
%             QualityInd_i=1;
%         end
%         QualityInd_i = QualityInd_i + k;
        % Compress and rec onstruct patch at QF1
        %Patch_img=imread('PatchImages{1,k}.tif');
%         imwrite(Patch{k},'tmpim_QF1.tif','TIF');
%         Patch_D=imread('tmpim_QF1.tif'); 
        %for j = QF2
            bk_im=imread([DBPath Images{k}]);
            [~,namepart,~]=fileparts(Images{k});
%             % Place the patch at aligned 8x8 grid chosen randomly
            loc_i = randi(size(bk_im,1)-W); %2*W
            while mod(loc_i,8)~=0
                loc_i = randi(size(bk_im,1)-W); %2*W
            end
            loc_j = randi(size(bk_im,2)-W);%2*W
            while mod(loc_j,8)~=0
                loc_j = randi(size(bk_im,2)-W);%2*W
            end
            bk_im = bk_im(loc_i:loc_i+W-1,loc_j:loc_j+W-1,:) ;
%             MaskIm = zeros(size(bk_im,1),size(bk_im,2));
%             MaskIm(loc_i:loc_i+W-1,loc_j:loc_j+W-1) = 255;
            namepart2 = sprintf('%s_%d_%d.tif',namepart,i,j);
            imwrite(bk_im,[DCPPath namepart2],'TIF');
%             mask_namepart2 = sprintf('%s_%d_%d_mask.tif',namepart,i,j);
%             imwrite(MaskIm,[DCPPath mask_namepart2],'TIF');
%             DoubleCompIm_D=imread(namepart2);
        %end
        
   % end
    k = k+1;
end


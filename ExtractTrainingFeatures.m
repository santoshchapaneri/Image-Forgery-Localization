clear all; close all;
%This script was used to generate the training set contained in
%TrainingFeature.mat
%
%BaseFolder is the path where all the training data are kept. It must
%include two subfolders, "Single" and "Double". "Single" must contain one
%subfolder per Quality (i.e. "50","55",..."95"), while Double must contain
%one subfolder per Quality combination (i.e. ("50_55","50_60",...,"95_90")
%Inside each subfolder will be a number of 64x64 patches having undergone
%the corresponding JPEG compression history.
%
%The images were generated with CutTrainingImages and
%CompressTrainingImages as specified by the paper.

tic;

BaseFolder='C:\Users\Sony\Desktop\project\project_2\Images16\';

ft='dct';
fz=4;
sigs = 2;
sz = 3;
flt = ones(sz,1);
flt = flt*flt'/sz^2;

BlockSize=16;
StepSize=8;

    UnForgedListTmp=dir([BaseFolder 'UnForgedTrainingImages\' '\*.tif']);
    UnForgedListTmp={UnForgedListTmp.name};
    UnForgedList=strcat([BaseFolder 'UnForgedTrainingImages' '\'], UnForgedListTmp);
%     I=imread(UnForgedList{1});
%     [m n o]=size(I);
    
    ForgedList={};
%     ForgedListDir=dir([BaseFolder 'Double\*_' num2str(Quality) '\']);
    ForgedListDir=dir([BaseFolder 'ForgedTrainingImages\*.tif']);
    ForgedListDir={ForgedListDir.name};
    for DoubleDir=1:length(ForgedListDir)
        ForgedListTmp=dir([BaseFolder 'ForgedTrainingImages\'  '\*.tif']);
        ForgedListTmp={ForgedListTmp.name};
        ForgedList=strcat([BaseFolder 'ForgedTrainingImages'  '\'], ForgedListTmp);
        %ForgedList=[ForgedListTmp ForgedListTmp];
    end
    UnForgedFeatures=zeros(length(UnForgedList),25);
    for SingleItem=1:length(UnForgedList)
        if SingleItem==353
        tmp=4;
        end
        im=double(imread(UnForgedList{SingleItem}));
        I=rgb2ycbcr(im);
%         Cb=I(:,:,1);
        Cb=(I(:,:,3)+I(:,:,2))./2;
        noi = conv2(Cb,flt,'same');
        Stat=ExtractFeatures5(noi,BlockSize,StepSize);
        estV=localNoiVarEstimate(noi,ft,fz,sigs);
         UnForgedFeatures(SingleItem,:)=[Stat estV] ;   
%         UnForgedFeatures(SingleItem,:)=Stat ;
    end
    ForgedFeatures=zeros(length(ForgedList),25);
    for DoubleItem=1:length(ForgedList)
        im=double(imread(ForgedList{DoubleItem}));
        I=rgb2ycbcr(im);
        %Cb=I(:,:,1);
        Cb=(I(:,:,3)+I(:,:,2))./2;
        noi = conv2(Cb,flt,'same');
        Stat=ExtractFeatures5(noi,BlockSize,StepSize);
        estV=localNoiVarEstimate(noi,ft,fz,sigs);
         ForgedFeatures(DoubleItem,:)=[Stat estV] ;
%        ForgedFeatures(DoubleItem,:)=Stat ;
    end
%     disp(Quality);
% end

toc;
save('TrainingFeature_C_16.mat','UnForgedFeatures','ForgedFeatures','UnForgedList','ForgedList');
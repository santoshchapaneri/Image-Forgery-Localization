function [OutputMap, ClassMap ] = Feature(I,BlockSize,StepSize)
%

file=strcat('RVMs_Cb_',num2str(BlockSize),'.mat');
load(file);

%BlockSize=64;
Step=StepSize;
OutputMap=[];
ClassMap = [];

I_YCbCr=rgb2ycbcr(I);
% 
% %Isolate Cb component 
 %Cb=(I_YCbCr(:,:,3)+I_YCbCr(:,:,2))./2;
Cb=I_YCbCr(:,:,2);

sz = 3;
flt = ones(sz,1);
flt = flt*flt'/sz^2;
noiIm = conv2(Cb,flt,'same');

%noiIm=Cb;
sigs = 2; %[2 4 8]; % size of sliding window
% I=floor(size(im)/(2*sigs+1));
% estVDCT = zeros(I);
% estVDCT = zeros([size(im),length(sigs)]);
% estVHaar = zeros([size(im),length(sigs)]);
% estVRand = zeros([size(im),length(sigs)]);
for X=1:StepSize:size(noiIm,1)
%      i=1;
        if X+BlockSize-1<=size(noiIm,1)
            StartX=X;
        else
            StartX=size(noiIm,1)-BlockSize+1;
            X=size(noiIm,1);
        end
        for Y=1:StepSize:size(noiIm,2)
            if Y+BlockSize-1<=size(noiIm,2)
                StartY=Y;
            else
                StartY=size(noiIm,2)-BlockSize+1;
                Y=size(noiIm,2);
            end
            if StartX == 161 && StartY == 81
                StartX = 161;
            end
%             if StartX == 97 && StartY == 49
%                 tmp = 4;
%             end
%             fprintf('%d\t%d\n',StartX,StartY);
            block=noiIm(StartX:StartX+BlockSize-1,StartY:StartY+BlockSize-1,:);
            Stat= ExtractFeatures5(block,BlockSize,StepSize);
            estVDCT= localNoiVarEstimate(block,'dct',4,sigs);
%             FeatureVector=Stat;
                        FeatureVector=[Stat estVDCT];
            
            FeatureVector=(FeatureVector-mean_TrainData)./std_TrainData;

            [PredictLabel, PredictProb] = rvmBinPred(RVMStruct, FeatureVector');
            OutputMap(ceil((StartX-1)/StepSize+1),ceil((StartY-1)/StepSize+1))=PredictProb;
            ClassMap(ceil((StartX-1)/StepSize+1),ceil((StartY-1)/StepSize+1))=PredictLabel;
%             [Class, Dist] = svmclassify_dist(SVMStruct,FeatureVector);
%             OutputMap(ceil((StartX-1)/StepSize+1),ceil((StartY-1)/StepSize+1))=Dist;
%             ClassMap(ceil((StartX-1)/StepSize+1),ceil((StartY-1)/StepSize+1))=Class;
        end
end
%     
% OutputMap=[repmat(OutputMap(1,:),ceil(BlockSize/2/StepSize),1);OutputMap];
%     OutputMap=[repmat(OutputMap(:,1),1,ceil(BlockSize/2/StepSize)) OutputMap];
% ClassMap=[repmat(ClassMap(1,:),ceil(BlockSize/2/StepSize),1);ClassMap];
%     ClassMap=[repmat(ClassMap(:,1),1,ceil(BlockSize/2/StepSize)) ClassMap];

end
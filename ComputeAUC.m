clear;clc;

DBPath='C:\Users\Sony\Desktop\project\project_2\NoisyForgedImages\';

ForgedImages=dir([DBPath '*.tif']);
ForgedImages={ForgedImages.name};

MaskImages=dir([DBPath '*.bmp']);
MaskImages={MaskImages.name};

BlockSize=16;
StepSize=8;

numImages = length(ForgedImages);
% numImages = 2;
fTPM = 0;
AUCValues = NaN(numImages,1);
for k = 1:numImages
    ForgedName = ForgedImages{k};
    MaskName = MaskImages{k};
    fprintf('\nk=%d,Image=%s\n',k,ForgedName);
    % Compute AUC here
    GT_Map = myCreateGTMap([DBPath MaskName], BlockSize,StepSize);
    I=[DBPath ForgedName];
    [OutputMap, ClassMap] = analyzeCb(I,BlockSize,StepSize);
%     ClassMap = ~ClassMap;
%     GT_Map = myCreateGTMap([DBPath MaskName]); 
    [AUCValues(k),  FPR(k,:), TPR(k,:), accuracy(k), sensitivity(k), specificity(k), precision(k), recall(k), f_measure(k), gmean(k)]= aucscore(GT_Map(:), ClassMap(:), 0);
   
end
save('Perf_C_SVM_16_8.mat','AUCValues','FPR','TPR', 'accuracy', 'sensitivity', 'specificity', 'precision', 'recall', 'f_measure', 'gmean');

% % Find avg AUC for each QF2
% % Ignore those locations where computation did not happen above
% QF1=50:5:95;
% QF2=50:5:95;
% for j = QF2
%     QualityInd_j=round((j-50)/5+1);
%     if QualityInd_j>10
%         QualityInd_j=10;
%     elseif QualityInd_j<1
%         QualityInd_j=1;
%     end
%     AUC_QF2(QualityInd_j) = nanmean(nanmean(AUCValues(:,QualityInd_j,:)));
% end
% save('AUC_QF2_2.mat','AUC_QF2');

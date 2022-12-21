clc;
clear all;
close all;
component=['Y' 'Cb' 'Cr' 'C'];
Blksize=[64 64 64];
Stepsize=[64 48 32 16];

col_header={'Blocksize', 'Stepsize','Accuracy','AUC','F-score','Precision','Recall','Sensitivity','Specificity','G_mean'};     %Row cell array (for column labels)
% row_header(1:4,1)={'Y','Cb','Cr','C'};     %Column cell array (for row labels)
row_header(1:6,1)={'Cb'};     %Column cell array (for row labels)
m=1;
for i=1
 k=i;   
 for j=1:4
        
file=strcat('Perf_Cb_RVM_',num2str(Blksize(i)),'_',num2str(Stepsize(k)),'.mat');

% A= load('Perf_Cb_RVM_64_64.mat');
A=load(file);
acc=nanmean(A.accuracy);
AUC=nanmean(A.AUCValues);
f1=nanmean(A.f_measure);
Precision=nanmean(A.precision);
Recall=nanmean(A.recall);
Sensitivity= nanmean(A.sensitivity);
Specificity= nanmean(A.specificity);
FPR=nanmean(A.FPR);
TPR=nanmean(A.TPR);
G_mean=nanmean(A.gmean)
data(m,:)=[Blksize(i) Stepsize(k) acc AUC f1 Precision Recall Sensitivity Specificity G_mean];
% data1(m,:)=[FPR]
% data2(m,:)=[TPR]
 k=k+1;
 m=m+1;
 end
end
xlswrite('Performance_SVM.xls',data,'Sheet1','B2');     %Write data
xlswrite('Performance_SVM.xls',col_header,'Sheet1','B1');     %Write column header
xlswrite('Performance_SVM.xls',row_header,'Sheet1','A2');      %Write row header
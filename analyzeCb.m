function [ OutputMap, ClassMap] = analyzeCb( imPath, BlockSize,StepSize)
%
%[ stat_DCTCoeff_Y, stat_DCTCoeff_Cb, stat_DCTCoeff_Cr, stat_DCTCoeff_C] = analyze6( im )
%moments of dctcoeff of residual rlbp image
 
% im=imread(imPath);
I = double(imread(imPath));
[x,y,z]=size(I);
if z>3
     I= I(:,:,1:3);
end
% im=jpeg_read(imPath);
[OutputMap, ClassMap]=Feature(I,BlockSize,StepSize);
end



clc;
close all;
clear all;
im=imread('C:\Users\Sony\Desktop\project\chroma_LBP\15_12_17\NoisyForgedImages\ucid00001_1000_0.tif');
imshow(im);
I=rgb2ycbcr(double(im));
Cb=I(:,:,2);
figure; imagesc(Cb)

kernel = fspecial('gaussian', [3,3], 0.2);
res = imfilter(Cb,kernel);
Cb_res1=Cb-res;
figure;
subplot(2,2,1)
imagesc(Cb_res1)
title('0.2')

kernel = fspecial('gaussian', [3,3], 0.5);
res = imfilter(Cb,kernel);
Cb_res1=Cb-res;
% figure;
subplot(2,2,2)
imagesc(Cb_res1)
title('0.5')

kernel = fspecial('gaussian', [3,3], 1.8);
res = imfilter(Cb,kernel);
Cb_res1=Cb-res;
% figure;
subplot(2,2,3)
imagesc(Cb_res1)
title('1.8')

kernel = fspecial('gaussian', [3,3], 1.5);
res = imfilter(Cb,kernel);
Cb_res1=Cb-res;
% figure;
subplot(2,2,4)
imagesc(Cb_res1)
title('1.5')

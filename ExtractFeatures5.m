function [Feature_vec] = ExtractFeatures5(Cb,BlockSize,StepSize)
 

kernel = fspecial('gaussian', [3,3], 1);
fil_img = imfilter(Cb,kernel);
%fil_img = conv2(Cb,kernel);
Cb_res=Cb-fil_img;

    %Obtain residual image
%     for i=1:size(Cb,1)
%         for j=2:size(Cb,2)-2         
%             Cb_res(i,j)=Cb(i,j-1)-(3*Cb(i,j))+(3*Cb(i,j+1))-Cb(i,j+2);
%         end
%     end
%     Cb_res(:,1) = [];

    %Padding residual image
    if mod (size(Cb_res,1),8)==0
        x=0;
    else
        x=8-mod(size(Cb_res,1),8);
    end
    if mod (size(Cb_res,2),8)==0
        y=0;
    else
        y=8-mod(size(Cb_res,2),8);
    end

    Cb_res=padarray(Cb_res,[x y],'replicate','post');

    %convert Cb image to LBP image
    SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
    I2_lbp_Cb=rlbp(Cb_res,SP,0,'i');

    %resize LBP image to multiples of 8
    if mod (size(I2_lbp_Cb,1),8)==0
        x=0;
    else
        x=8-mod(size(I2_lbp_Cb,1),8);
    end
    if mod (size(I2_lbp_Cb,2),8)==0
        y=0;
    else
        y=8-mod(size(I2_lbp_Cb,2),8);
    end
    I2_lbp_Cb=padarray(I2_lbp_Cb,[x y],'replicate','post');

    %Extract DCT coefficients of LBP image
    DCTCoeff_lbp_Cb = ExtractDCTCoeff(I2_lbp_Cb);

%     StepSize=8;
    c1=1;
    c2=25;

    coeff = [1 9 2 3 10 17 25 18 11 4 5 12 19 26 33 41 34 27 20 13 6 7 14 21 28 35 42 49 57 50 43 36 29 22 15 8 16 23 30 37 44 51 58 59 52 45 38 31 24 32 39 46 53 60 61 54 47 40 48 55 62 63 56 64];
    sizeCA = size(DCTCoeff_lbp_Cb);

    for index = c1:c2  
        coe = coeff(index);
        % load DCT coefficients at position index
        k = 1;
        start = mod(coe,8);
        if start == 0
            start = 8;
        end
        for j = start:8:sizeCA(2)
            for i = ceil(coe/8):8:sizeCA(1)
                Coeff(index,k) = DCTCoeff_lbp_Cb(i,j);
                k = k+1;
            end
        end    

    end
    
    %subbanding
    Conc_Coeff_DC=Coeff(1,:); %DC 
    Conc_Coeff_t(1,:)=[Coeff(2,:),Coeff(6,:),Coeff(7,:),Coeff(8,:),Coeff(14,:)];%vertical texture
    Conc_Coeff_t(2,:)=[Coeff(3,:),Coeff(4,:), Coeff(9,:),Coeff(10,:),Coeff(12,:)];%horizontal texture
    Conc_Coeff_t(3,:)=[Coeff(5,:),Coeff(13,:), Coeff(18,:),Coeff(19,:),Coeff(25,:)];%diagonal texture

    %Statics 
    mean_DCTCoeff = [mean(Conc_Coeff_DC') mean(Conc_Coeff_t')];
    std_DCTCoeff = [std(Conc_Coeff_DC') std(Conc_Coeff_t')];
    skew_DCTCoeff = [skewness(Conc_Coeff_DC') skewness(Conc_Coeff_t')];
    kurt_DCTCoeff = [kurtosis(Conc_Coeff_DC') kurtosis(Conc_Coeff_t')];
    
    %Feature vector
    Feature_vec=[mean_DCTCoeff std_DCTCoeff skew_DCTCoeff kurt_DCTCoeff];
end
% end


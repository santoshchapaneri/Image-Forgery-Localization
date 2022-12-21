function [ DCTCoeff ] = ExtractDCTCoeff( img )

dctmatrix = dctmtx(8);
dct = @(blockstruct) dctmatrix*blockstruct.data*dctmatrix';

I = double(img);

DCTCoeff = blockproc(I,[8 8], dct);

end


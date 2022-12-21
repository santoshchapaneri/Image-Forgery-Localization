
function [training, validation] = k_fold_split(data, k_fold, f)

%-------------------------------------------------------------------
% Description:
%
%   [training, validation] = k_fold_split(data, k_fold, f)
%
%   split the data into K-fold for Cross Validation
%
% INPUT
%   data:       the matrix (n-by-d) of dataset
%               with the last column (n-by-1) as the class labels
%               dim(data) = n-by-(d+1)
%   k_fold:     number of folds
%   f:          the fold number (index)
%
% OUTPUT
%   training:   the training data for the f-th fold
%                   about (k_fold -1)/k_fold of `data'
%   validation: the validation data for the f-th fold
%                   about 1/k_fold of `data'
%
%-------------------------------------------------------------------

    n_samples = size(data,1);
    fold_length = k_fold;

    fold_index_max = ceil(n_samples/k_fold);

    for fold_index = 1:fold_index_max
        fold_start(fold_index) = (fold_index-1) * fold_length +1;
    end

    index = fold_start +f -1;
    index = index(find(index <= n_samples));    % check if the index bound exceeds

    training = [];
    validation = [];

    for i = 1:n_samples
        if any(index == i)
            validation = [validation; data(i,:)];
        else
            training = [training; data(i,:)];
        end
    end

end
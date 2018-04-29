function [ prior , harshPrior ] = wsbm_make_prior(iMu,wieghtMore)
% takes in a WSBM model or mu mat and ouputs a prior mat based of the mu_0
% of the WSBM model provided, and a harsh prior with just the 
% 'winners' of the mu_0 mat
%
% input mu mat should be dimension: (num communities) x (num nodes)

if nargin < 2
    wieghtMore = 0 ; 
end

% if inputMu is a struct, extract relevant variables
if isstruct(iMu)
    k = size(iMu.Para.mu,1);
    mu = iMu.Para.mu ;
else
    k = size(iMu,1) ;
    mu = iMu ; 
end

if size(iMu,1) > size(iMu,2)
   error('looks like incorrect mu') 
end

%twice as likely (1 would be 100%, double more likely)
weight_label = (1 + wieghtMore ) / (k + wieghtMore) ;
weight_other = 1 / ( k + wieghtMore ) ; 

%sanity check 
if (weight_label < weight_other) 
    error('prior weight is too low dude')
end

[~,ind] = max(mu,[],1) ;
harshPrior = dummyvar(ind)' ;

% copy the harshPrior
prior = harshPrior .* 1 ;
prior(prior==1) = weight_label ;
prior(prior==0) = weight_other ;

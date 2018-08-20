function [ prior , harshPrior ] = wsbm_make_prior(iMu,wieghtMore)
% takes in a wsbm model or mu mat and ouputs a prior mat based of the mu_0
% of the wsbm model provided, and a harsh prior with just the 
% 'winners' of the iMu mat
%
% INPUTS:
%           iMu:    matrix of dim (num communities) x (num nodes),
%                   recording the community prob. for each node 
%           weightMore: if you'd like to make a prior where the winnder is
%                       weighted X times more than other weights. X is this
%                       variable
%
% OUTPUTS:
%           prior:  prior for wsbm, dim (num communities) x (num nodes)
%           harshPrior: prior with only 1's and 0's
% 

if nargin < 2
    wieghtMore = 0 ; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

function [ Model ] = wsbm_fit_w_pttrn( adjMat, rStruct , modelInputs , initMu, numTrialPttrn, priorWeightPttrn)
% will fit wsbm specificed number iterations pattern and prior weight
% pattern
%
% INPUTS:
%           adjMat:     input matrix
%           rStruct:    num communites or wsbm rstruct
%           modelInputs:    cell array of model inputs
%           initMu:     initial prior
%           numTrialPttrn:  now many trials to run at each iteration,
%                           length of this vec determins how many
%                           iterations of fitting will be run
%           priorWeightPttrn:   can be used to specifc how the priors are
%                               increasingly weighted, or can be left empty
%                               to specify only increase 2x,3x,...Nx
%
%
% OUTPUTS:
%           Model:      fit wsbm model
% 
% if you want the wsbm fit with no prior, just set initMu to a uniform
% prior and it will have no effects 

if nargin < 5
    error('need more args')
end

if ~exist('priorWeightPttrn','var') || isempty(priorWeightPttrn)
    priorWeightPttrn = [] ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mu_prior = initMu ;

for idx=1:length(numTrialPttrn)

    % the parameters set after 'modelInputs' will take precendent
    % over anything specified in that cell array
    [~,tmpModel] = wsbm(adjMat, ...
        rStruct,...
        modelInputs{:},...
        'numTrials', numTrialPttrn(idx), ...
        'mu_0', mu_prior ) ;

    if isempty(priorWeightPttrn)
        mu_prior = wsbm_make_prior(tmpModel,idx) ;
    else
        mu_prior = wsbm_make_prior(tmpModel,priorWeightPttrn(idx));
    end

end

Model = tmpModel ;

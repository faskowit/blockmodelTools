function [] = config_fitWSBM(K,outputPath,w_dist,e_dist)
% function to save mats that will be use for WSBM params

if nargin < 3
    w_dist = 'exp' ; 
end

if nargin < 4
    e_dist = 'poisson' ; 
end

%% SETUP GLOBAL VARS

RSTRUCT_OR_K = K
W_DIST = w_dist
E_DIST = e_dist

WSBM_NUM_TRIAL = 10 ;
WSBM_ALPHA = 0.5 ;
WSBM_MAIN_ITER = 500 ;
WSBM_MU_ITER = 250 ;
WSBM_MAINTOL = 0.01 ;
WSBM_MUTOL = 0.01 ;

% set the opts
% wsbmModelInputs = { RSTRUCT_OR_K, ... 
%     'W_Distr', W_DIST, ...
%     'E_Distr', E_DIST, ...
%     'numTrials',WSBM_NUM_TRIAL,...
%     'alpha', WSBM_ALPHA, ...
%     'mainMaxIter', WSBM_MAIN_ITER , ...
%     'muMaxIter' , WSBM_MU_ITER,...
%     'mainTol',WSBM_MAINTOL, ...
%     'muTol', WSBM_MUTOL ,...
%     'verbosity', 0};

outStr = [ outputPath '/wsbmVars_k' sprintf('%02d',K) '_' ...
    w_dist '_' e_dist ] ;
save([ outStr '.mat'],'*') ;



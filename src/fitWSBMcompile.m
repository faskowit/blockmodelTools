function [] = fitWSBMcompile(inputMatPath,inputOpts,outputPathStr)

if nargin < 3
   error('need at least three args') 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load the data
loadStruct = load(inputMatPath) ;
ff = fieldnames(loadStruct) ;
iMat = loadStruct.(ff{1}) ;

needVars = { 'RSTRUCT_OR_K', 'W_DIST', 'E_DIST', 'WSBM_NUM_TRIAL', ...
    'WSBM_ALPHA', 'WSBM_MAIN_ITER', 'WSBM_MU_ITER', 'WSBM_MAINTOL', ...
    'WSBM_MUTOL'} ;

% load the opts
load(inputOpts,needVars{:})

for idx=1:numel(needVars)
    if ~exist(needVars{idx},'var')
       error([ 'need the variable: ' needVars{idx}])
    end
end

status = mkdir(outputPathStr);
if ~status
   error('could not make output directory') 
end

% set the opts
wsbmModelInputs = { RSTRUCT_OR_K, ... 
    'W_Distr', W_DIST, ...
    'E_Distr', E_DIST, ...
    'numTrials',WSBM_NUM_TRIAL,...
    'alpha', WSBM_ALPHA, ...
    'mainMaxIter', WSBM_MAIN_ITER , ...
    'muMaxIter' , WSBM_MU_ITER,...
    'mainTol',WSBM_MAINTOL, ...
    'muTol', WSBM_MUTOL ,...
    'verbosity', 1};
disp(wsbmModelInputs)

[~,Model] = wsbm(iMat, ...
    wsbmModelInputs{:}) ;

% save the model
outStr = [ outputPathStr '/wsbmModelOut.mat' ] ;
save(outStr, 'Model','-v7.3')




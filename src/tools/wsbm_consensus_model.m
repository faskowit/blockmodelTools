function [ consensusModel , consensusInfoStruct ] = wsbm_consensus_model(inputModels)
% takes in an array of models, and finds consensus model
% uses the parfor function

%% setup vars
numIters = length(inputModels) ;

% setup consensus result as struct
consensusInfoStruct = struct();

% it will converge in 10
consensusIter = 10 ;

% how many models to fit at each consensus iteration
fitNConsensusModels = 100 ;

%% get central model to start with

consensusInfoStruct.kCentralModel = wsbm_central_model(inputModels) ; 

model_k = consensusInfoStruct.kCentralModel.R_Struct.k ;
model_n = consensusInfoStruct.kCentralModel.Data.n ;

%% sort the kLoopModels...
% by aligning all to the 'most central' with Hungarian algo

% the ref to align to will be the kCentralModel
ref = wsbm_community_assign(consensusInfoStruct.kCentralModel) ;

% preallocate the mat of the bestModels community assignments
ca_aligned = zeros([ model_n numIters ]) ;

% first stack all plausible parcellations
for idx=1:numIters

    tmp = wsbm_community_assign(inputModels(idx).Model.Para.mu) ;
    ca_aligned(:,idx) = hungarianMatch(ref,tmp) ;
end

%% lets iterate over the 100 k best models to create consensus model

kiter_prior = zeros([ model_k model_n ]) ;

% iterate over each node
for idx=1:model_n

    kiter_prior(:,idx) = ...
        sum(bsxfun(@eq,ca_aligned(idx,:), ...
        (1:model_k)'),2) ./ numIters;

end    

%% loop for consensus

consensusInfoStruct.C = zeros([consensusIter 1]) ;
consensusInfoStruct.kiter_priors = kiter_prior ;
consensusInfoStruct.agree_mats = zeros(model_n) ;

for idx=1:consensusIter

    % just read in the parameters from the model we started with
    modelGetParamFrom = consensusInfoStruct.kCentralModel ;
    rr = modelGetParamFrom.R_Struct.R ;
    modIn = { ... 
        'W_Distr', modelGetParamFrom.W_Distr, ...
        'E_Distr', modelGetParamFrom.E_Distr, ...
        'alpha', modelGetParamFrom.Options.alpha, ...
        'mainMaxIter', modelGetParamFrom.Options.mainMaxIter , ...
        'muMaxIter' , modelGetParamFrom.Options.muMaxIter,...
        'mainTol',modelGetParamFrom.Options.mainTol, ...
        'muTol', modelGetParamFrom.Options.muTol ,...
        'verbosity', 0, ...
        'numTrials', modelGetParamFrom.Options.numTrials ,...
        'mu_0', consensusInfoStruct.kiter_priors(:,:,idx) };

    % function [ allModels ] = wsbmFitNTimes( adjMat, rStruct , modelInputs , numFits , numCores)
    cnsnsusModels = wsbm_fit_n_times(modelGetParamFrom.Data.Raw_Data,...
        rr,...
        modIn,...
        fitNConsensusModels, 16) ;

    tmpCnsnsusCa = zeros([ modelGetParamFrom.Data.n fitNConsensusModels ]) ;

    for jdx=1:fitNConsensusModels
        tmpCnsnsusCa(:,jdx) = wsbm_community_assign(cnsnsusModels(jdx).Model) ;
    end

    consensusInfoStruct.agree_mats(:,:,idx) = agreement(tmpCnsnsusCa) ./ fitNConsensusModels ;
    
    % get the consensus consitency
    consensusInfoStruct.C(idx) = get_consensus_consistency(consensusInfoStruct.agree_mats(:,:,idx)) ;
    
    % have we converged? or are we at the end of loop?
    if consensusInfoStruct.C(idx) >= 0.95 || idx == consensusIter
        consensus_kCentralModel = central_model(cnsnsusModels) ;
        % also add the data back into consensus_kCentral...
        consensus_kCentralModel.Data = kCentralModel.Data ;
        break 
    end
    
    % make new kiter_prior for new loop
    for kdx=1:(modelGetParamFrom.Data.n)

        consensusInfoStruct.kiter_priors(:,kdx,idx+1) = ...
            sum(bsxfun(@eq,tmpCnsnsusCa(kdx,:), ...
            (1:(modelGetParamFrom.R_Struct.k))'),2) ./ fitNConsensusModels ;

    end    

end

consensusModel = consensus_kCentralModel ;

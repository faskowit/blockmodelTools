function [ randWSBMModel ] = wsbm_randomize_model_params(origModel,randParam)
% randomize the parameters of wsbm, useful for creating a null gen model
%
% INPUTS:
%       origModel:  original wsbm model
%       randParam:  distributions to randomize; 1=edge, 2=weight, 3=both
%
% OUTPUTS:
%       randWSBMModel:  randomized model
%

if nargin < 2
    error('two args needed')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get indicies to randomize
e_perm_idx = randperm(size(origModel.Para.theta_e,1)) ;
w_perm_idx = randperm(size(origModel.Para.theta_w,1)) ;

% switch the opts
switch randParam
    case 1     
        new_theta_e = origModel.Para.theta_e(e_perm_idx,:) ;
        new_theta_w = origModel.Para.theta_w ;
    case 2
        new_theta_e = origModel.Para.theta_e ;
        new_theta_w = origModel.Para.theta_w(w_perm_idx,:) ;
    case 3        
        new_theta_e = origModel.Para.theta_e(e_perm_idx,:) ;
        new_theta_w = origModel.Para.theta_w(w_perm_idx,:) ;    
end

% write new model
randWSBMModel = struct(origModel) ; 
randWSBMModel.Para.theta_e = new_theta_e;
randWSBMModel.Para.theta_w = new_theta_w;








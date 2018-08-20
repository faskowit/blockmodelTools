function [genMat,noNaGenMat] = wsbm_synth_adj_gen(wsbmModel,sym)
% generate a synthetic mat given the parameters of a already realized wsbm
% model fit
%
% INPUTS:
%       wsbmModel:  the blockmodel struct
%       sym:        symmetricl; yes(default)=1, no=0
%
% OUTPUTS:
%       genMat:     generated data
%       noNaGenMat: generated data no NaNs
%
% uses the WSBM function generateEdges
% function [Edge_List,True_Model] = ...
%               generateEdges(W_truth,E_truth,R,theta_w,theta_e,...
%                               group_Size,degree_Para)

if nargin < 2
    sym = 1 ;
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dist params
weightDist_model = wsbmModel.W_Distr ;
edgeDist_model = wsbmModel.E_Distr ;

% num communities
r_struct_model = wsbmModel.R_Struct.R ;

% thetas
theta_w_model = wsbmModel.Para.theta_w ;
theta_e_model = wsbmModel.Para.theta_e ;

% getting the community sizes
[~,tmp] = wsbm_make_prior(wsbmModel) ;
groupS_model = sum(tmp,2) ;

% func from wsbm orig package
edgeList = generateEdges(...
    weightDist_model, edgeDist_model, r_struct_model, ...
    theta_w_model, theta_e_model, groupS_model) ;

genMat = Edg2Adj(edgeList) ;

% symmetrize the genMat
if sym == 1
    genMat = triu(genMat) + triu(genMat,1)';
end

if nargout > 1
    noNaGenMat =  genMat ;
    noNaGenMat(~~isnan(genMat)) = 0 ;
end









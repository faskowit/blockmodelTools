function labs = wsbm_community_assign(mu)
%% make community assign from muLabels

% if wsbm struct provided, get mu labels out of it
if isstruct(mu) 
   mu = mu.Para.mu;
end

[~,labs] = max(mu,[],1) ;
labs = labs' ;
function labs = wsbm_community_assign(muLabels)
%% make community assign from muLabels

% if wsbm struct provided, get mu labels out of it
if isstruct(muLabels) 
   muLabels = muLabels.Para.mu;
end

[labs,~] = find(muLabels') ;

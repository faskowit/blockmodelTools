function [V] = get_nodal_versatility(comMat)
% comMat should be nodes x paritions

% get the rate of nodes classified in same community
CM = agreement(comMat) ./ size(comMat,2);

% rescale CM to make interpretable, make into nodal vers. measure
Cs = sin(pi*CM);
V = sum(Cs, 1)./sum(CM, 1);
% numerical adjustment
V(V<1e-10) = 0;
    
    
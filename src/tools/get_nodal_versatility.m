function [V] = get_nodal_versatility(comMat)
% comMat should be nodes x paritions
% https://www.nature.com/articles/s41598-017-03394-5
% https://github.com/mwshinn/versatility

% get the rate of nodes classified in same community
CM = agreement(comMat) ./ size(comMat,2);

% rescale CM to make interpretable, make into nodal vers. measure
Cs = sin(pi*CM);
V = sum(Cs, 1)./sum(CM, 1);
% numerical adjustment
V(V<1e-10) = 0;
    
    
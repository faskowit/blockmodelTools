function [ motifMat ] = wsbm_offDiag_motif(blockMat)
% function to get community motifs, assortative, core-periphery, and
% dissassotative, as in https://www.nature.com/articles/s41467-017-02681-z
%
% INPUTS:
%       blockMat:   matrix of average within- and between- community
%                   connectivity
%
% OUPPUTS:
%       motifMat:   matrix of motif for each off-diagonal community
%                   interaction, 1=assort, 2=disassort, 3=core-periph

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k = size(blockMat,1) ;
motifMat = zeros([k k]) ;
        
for idx = 1:k    
    for jdx = 1:k
        
        % off diagonal analysis 
        
        if jdx == idx
            continue
        end
                
        minAssort = min(blockMat(idx,idx),blockMat(jdx,jdx)) ;
        maxAssort = max(blockMat(idx,idx),blockMat(jdx,jdx)) ;
        
        subMat = [ blockMat(idx,idx) blockMat(idx,jdx) ;    % when unrolling
                   blockMat(jdx,idx) blockMat(jdx,jdx) ] ;  % 1 3 
                                                    % 2 4
        
        % position 2
        if minAssort > subMat(2)
            motifMat(jdx,idx) = 1 ;
        elseif subMat(2) > maxAssort
            motifMat(jdx,idx) = 3 ;
        else
            motifMat(jdx,idx) = 2 ;
        end
        
        % position 3
        if minAssort > subMat(3)
            motifMat(idx,jdx) = 1 ;
        elseif subMat(3) > maxAssort
            motifMat(idx,jdx) = 3 ;
        else
            motifMat(idx,jdx) = 2 ;
        end
                             
    end  
end
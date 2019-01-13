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
%                   interaction, 1=assort, 2=core, 3=per, 4=dissort

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k = size(blockMat,1) ;
motifMat = zeros([k k]) ;
        
for idx = 1:k    
    for jdx = 1:k
        
        % off diagonal analysis 
        
        if jdx == idx
            continue
        end
                
        minWithinCom = min(blockMat(idx,idx),blockMat(jdx,jdx)) ;
        maxWithinCom = max(blockMat(idx,idx),blockMat(jdx,jdx)) ;
        
        subMat = [ blockMat(idx,idx) blockMat(idx,jdx) ;    % when unrolling
                   blockMat(jdx,idx) blockMat(jdx,jdx) ] ;  % 1 3 
                                                    % 2 4
        
        % position 2
        if minWithinCom > subMat(2)
            motifMat(jdx,idx) = 1 ;
        elseif subMat(2) > maxWithinCom
            motifMat(jdx,idx) = 4 ;
        else
            tmpDiff = diff([minWithinCom subMat(2) maxWithinCom]) ;
            if tmpDiff(1) < tmpDiff(2)
                % periphery because closer to smaller value
                motifMat(idx,jdx) = 3 ;
            else
                % core because closder to larger value
                motifMat(idx,jdx) = 2 ;
            end
        end
        
        % position 3
        if minWithinCom > subMat(3)
            motifMat(idx,jdx) = 1 ;
        elseif subMat(3) > maxWithinCom
            motifMat(idx,jdx) = 4 ;
        else
            tmpDiff = diff([minWithinCom subMat(3) maxWithinCom]) ;
            if tmpDiff(1) < tmpDiff(2)
                % periphery because closer to smaller value
                motifMat(idx,jdx) = 3 ;
            else
                % core because closder to larger value
                motifMat(idx,jdx) = 2 ;
            end
        end
                             
    end  
end
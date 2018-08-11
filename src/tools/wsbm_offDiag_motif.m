function [ motifMat ] = wsbm_offDiag_motif(iMat)
% function to get community motifs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k = size(iMat,1) ;
motifMat = zeros([k k]) ;
        
for idx = 1:k    
    for jdx = 1:k
        
        % off diagonal analysis 
        
        if jdx == idx
            continue
        end
                
        minAssort = min(iMat(idx,idx),iMat(jdx,jdx)) ;
        maxAssort = max(iMat(idx,idx),iMat(jdx,jdx)) ;
        
        subMat = [ iMat(idx,idx) iMat(idx,jdx) ;    % when unrolling
                   iMat(jdx,idx) iMat(jdx,jdx) ] ;  % 1 3 
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
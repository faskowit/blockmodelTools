function blockMode = get_block_mode(inData,ca,ignoreVal)
% return the mode value for each comm-comm interaction, return this matrix
% of block mode values

if nargin < 2
   ignoreVal = '' ; 
end

comms = unique(ca) ;
numComms = length(comms) ;
blockMode = zeros(numComms) ;

for idx = 1:numComms
    for jdx = 1:numComms 
        
        select1 = ca == comms(idx) ;
        select2 = ca == comms(jdx) ;
        
        tmp = inData(select1,select2) ;
        
        if ~isempty(ignoreVal)
           tmp = tmp(tmp ~= ignoreVal) ; 
        end
        
        blockMode(idx,jdx) = mode(tmp(:)) ;   
    end
end














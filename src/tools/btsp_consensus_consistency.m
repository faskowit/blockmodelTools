function [ Cinterval , Cdist ] = btsp_consensus_consistency(allPartitions,nBoot)

if ~exist('nBoot','var') || isempty(nBoot)
   nBoot = 1000 ; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nReps = size(allPartitions,2);
Cdist = zeros(nBoot,1) ;

for idx = 1:nBoot

        disp(idx)
        new_allPartitions = allPartitions(:,datasample(1:nReps,nReps,'Replace',true)) ;
        new_agree = agreement(new_allPartitions) ./ nReps ;
        Cdist(idx) = get_consensus_consistency(new_agree) ;
end

Cinterval = prctile(Cdist,[2.5 97.5]) ;
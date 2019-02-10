function [ new_mu_order, breaks ] = wsbm_plot_mat(Raw_Data,Labels,reorder,style)
% plot blockmodel, but permute labels based on block density

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% check if wsbm struct is provided, if so, roll with it
if isstruct(Raw_Data)
    if nargin == 2 && ischar(Labels)
        style = Labels;
    end
    Model = Raw_Data;
    Raw_Data = Model.Data.Raw_Data;
    Labels = Model.Para.mu;
end

% check if adj mat or edge list prvided
[n,m] = size(Raw_Data);
if n == m
    fprintf('Treating Raw_Data as an Adj Matrix\n');
elseif m == 3
    fprintf('Treating Raw_Data as an Edge List\n');
    n = max([Raw_Data(:,1);Raw_Data(:,2)]);
else
    error('Invalid Raw_Data Format');
end

% check if labels provided
if ~exist('Labels','var') || isempty(Labels)
    imu = ones(1,n);
elseif ~isnumeric(Labels)
    if ischar(Labels)
        style = Labels;
        imu = ones(1,n);
    else
        error('Labels is not a numeric array.');
    end
elseif size(Labels,1) == 1
    imu = zeros(max(Labels),size(Labels,2));
    for kk = 1:max(Labels)
        imu(kk,Labels == kk) = 1;
    end
else
    imu = Labels;
end

if ~exist('reorder','var') || isempty(reorder) 
    reorderFunc = @(x,y)(unique(y)) ; 
elseif strcmpi(reorder,'mod')
    reorderFunc = @wsbm_reorder_block_mod ;
end

if ~exist('style','var') || isempty(style)
    style = 'default';
end
% switch on style, incase want to disp 
switch lower(style)
    case {'edge','edges'}
        if m == 3
            [~,Raw_Data] = Edg2Adj(Raw_Data);
        else
            Raw_Data = ones(size(Raw_Data));
        end
    case {'log10'}
        if m == 3
            [Raw_Data,~] = Edg2Adj(Raw_Data);
        end
        Raw_Data(Raw_Data <= 0) = NaN; 
        Raw_Data = log10(Raw_Data);
    case {'log','loge'}
        if m == 3
            [Raw_Data,~] = Edg2Adj(Raw_Data);
        end
        Raw_Data(Raw_Data <= 0) = NaN;
        Raw_Data = log(Raw_Data);
    otherwise
        if m == 3
            [Raw_Data,~] = Edg2Adj(Raw_Data);
        end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mu = imu'; % change k x N -> N x k
[n,k] = size(mu);
adj_sorted = zeros(n);
list = zeros(1,n);
breaks = zeros(1,k);

% pick label assigment if any fuzzy labels
if sum(sum(mu > 0)) > n
    fprintf('\nRounding mu, randomly picking uniform\n');
    mu = mu./(sum(mu,2)*ones(1,size(mu,2)));
    e = [zeros(size(mu,1),1) cumsum(mu,2)];
    e(:,end) = 1;
    e(e>1) = 1;
    mu = diff(e,1,2);
    mu = mnrnd(1,mu);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get mu vector
[~,mu_vec] = max(mu,[],2) ;

new_mu_order =  reorderFunc(Raw_Data,mu_vec) ;

new_mu = zeros(size(mu));
for idx = unique(mu_vec)
    
    new_mu(:,idx) = mu(:,new_mu_order(idx)) ;    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cur = 1;
for ii = 1:k
    indicies = find(new_mu(:,ii));
    list(cur:cur+length(indicies)-1) = indicies;
    cur = cur + length(indicies);
    breaks(ii) = cur-1;
end

for ii = 1:n
    adj_sorted(ii,:) = Raw_Data(list(ii),list);
end

%Plot the Matrix
h = imagesc(adj_sorted,[min(adj_sorted(:))-.00001,max(adj_sorted(:))]);
set(h,'alphadata',~isnan(adj_sorted));
colorbar;
axis square
hold all; 

for ii = 1:k-1
    plot([breaks(ii)+.5,breaks(ii)+.5],[-.5,breaks(k)+.5],'Color',[ 0 0 0 0.25 ],'LineWidth',1.5);
    plot([-.5,breaks(k)+.5],[breaks(ii)+.5,breaks(ii)+.5],'Color',[ 0 0 0 0.25 ],'LineWidth',1.5);
end        
hold off;
    
% adapted from Christopher Aicher code, copyright:
%
%   Copyright 2013-2014 Christopher Aicher
%
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%   You should have received a copy of the GNU General Public License
%   along with this program.  If not, see <http://www.gnu.org/licenses/>
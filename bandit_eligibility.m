% 
% Created on January 2, 2013
% @author: Johannes Feldmaier <johannes.feldmaier@tum.de>
%     Copyright (C) 2013  Johannes Feldmaier
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
function [relevancy, familiarity ] = bandit_eligibility(savAction, savReward)
%BANDIT_ELIGIBILITY: uses eligibility traces together with the arm
% selections and the rewards to calculate the relevancy and familiarity for
% each arm.
%
% Note: only for Bernoulli Bandits!
%

relevancy = zeros(size(savAction,1),size(savAction,2)+1,max(max(savAction)));
familiarity = zeros(size(savAction,1),size(savAction,2)+1,max(max(savAction)));

lambda = 0.95; % for upto 1500 samples: 0.95
gamma = 1;

for k = 1:size(savAction,1)
    
    tmp_sel = savAction(k,:);
    tmp_rew = savReward(k,:);
    
    for i = 1:size(savAction,2)
        
        tmp_rel = relevancy(k,i,:);
        tmp_fam = familiarity(k,i,:);
        
        tmp_rel(tmp_sel(i)) = (lambda * gamma) .* tmp_rel(tmp_sel(i)) + tmp_rew(i);
        tmp_rel([1:tmp_sel(i)-1 tmp_sel(i)+1:end]) = ...
            tmp_rel([1:tmp_sel(i)-1 tmp_sel(i)+1:end]) .* (lambda * gamma);
        
        tmp_fam(tmp_sel(i)) = tmp_fam(tmp_sel(i)) + 1;
        tmp_fam = tmp_fam .* (lambda * gamma);
        
        relevancy(k,i+1,:) = tmp_rel;
        familiarity(k,i+1,:) = tmp_fam;
        
    end
    
    % normalization by scaling between 0 and 1
    relevancy(k,:,:) = (relevancy(k,:,:) - min(min(relevancy(k,:,:)))) ./...
        (max(max(relevancy(k,:,:))) - min(min(relevancy(k,:,:))));
    familiarity(k,:,:) = (familiarity(k,:,:) - min(min(familiarity(k,:,:)))) ./...
        (max(max(familiarity(k,:,:))) - min(min(familiarity(k,:,:))));
    
end




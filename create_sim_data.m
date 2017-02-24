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
%% Creates simulated data schemes for bandit processes

% 1. Phase: random
% 2. Phase: learning progress: alters between the two best arms
% 3. Phase: learned / stable: only best arm is selected -> ideal case
% 4. Phase: disturbance: some errors occur
% 5. Phase: recover: ideal case again

if not(exist('nb_trials','var'))
    nb_trials = 1500;
end
if not(exist('nb_plays','var'))
nb_plays = 10;
end
if not(exist('nb_arms','var'))
nb_arms = 4;
end

mu = [0.2 0.1 0.3 0.8];

error_rate = 0.9; % 0.2 equals to 20 percent of errors

[~, best_arm] = max(mu);
[~, ind] = sort(mu,'descend');
tb_arms = ind(1:2);


% create data arrays

savAction = zeros(nb_plays,nb_trials);
savReward = zeros(nb_plays,nb_trials);


%% Phase 1:

savAction(:,1:round((1/5)*nb_trials)) = randi([1,nb_arms],nb_plays,round((1/5)*nb_trials));

%% Phase 2:

[~, s] = size(round((1/5)*nb_trials)+1:round((2/5)*nb_trials));

savAction(:,round((1/5)*nb_trials)+1:round((2/5)*nb_trials)) = randi([min(tb_arms),max(tb_arms)],nb_plays,s);

%% Phase 3:

[~, s] = size(round((2/5)*nb_trials)+1:round((3/5)*nb_trials));

savAction(:,round((2/5)*nb_trials)+1:round((3/5)*nb_trials)) = best_arm * ones(nb_plays,s);

%% Phase 4:

[~, s] = size(round((3/5)*nb_trials)+1:round((4/5)*nb_trials));

tmp = zeros(nb_plays,s);

for i = 1:nb_plays
    for j = 1:s
        if rand >= error_rate
            tmp(i,j) = best_arm;
        else
            tmp(i,j) = randi([1,nb_arms],1,1);
        end
    end
end

savAction(:,round((3/5)*nb_trials)+1:round((4/5)*nb_trials)) = tmp;

clear tmp i j

%% Pase 5:

[~, s] = size(round((4/5)*nb_trials)+1:nb_trials);

% random case
% savAction(:,round((4/5)*nb_trials)+1:nb_trials) = randi([1,nb_arms],nb_plays,s);

% ideal case
savAction(:,round((4/5)*nb_trials)+1:nb_trials) = best_arm * ones(nb_plays,s);

clear s

%% Generate Reward Structures depending on the selected Actions

tmp = rand(nb_plays,nb_trials);

for i = 1:nb_arms
    savReward(savAction == i & tmp <= mu(i)) = 1;
end

clear tmp i best_arm error_rate ind mu tb_arms















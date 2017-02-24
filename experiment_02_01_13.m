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
%% In this experiment _simulated_ bandit processes are generated and their
%  relevance and familiarity values are calculated using eligibility
%  traces. With these values the Zurcher Model is used calculating security
%  and arousal values of the bandit process.


%% 1) Bandit Simulation
%nb_plays = 100;
nb_plays = 1;
nb_trials = 15;
create_sim_data

%% 2) Eligibility traces: Relevancy and Familiarity

[relevancy, familiarity ] = bandit_eligibility(savAction, savReward);

relevancy(:,1,:) = [];
familiarity(:,1,:) = [];

%% 3) Zurcher Model

obj = zurcher_init(nb_arms,nb_trials);

ego_positions = zeros(nb_plays,size(familiarity,2)+1,2);
obj_ego_security = zeros(nb_plays,size(familiarity,2)+1,1);
obj_ego_arousal = zeros(nb_plays,size(familiarity,2)+1,1);

for k = 1:nb_plays
    for i = 1:nb_trials
        
        obj.ego.trial_i = i;
        
        obj.relevances = squeeze(relevancy(k,i,:));
        obj.familiarity = squeeze(familiarity(k,i,:));
        
        obj = zurcher_offline(obj);
        
        % extract states
        ego_positions(k,i+1,:) = obj.ego.pos;
        obj_ego_security(k,i+1,:) = obj.ego.s;
        obj_ego_arousal(k,i+1,:) = obj.ego.a;
    end
    
end

clear k i

%% 4) Plot Emotion

plot_emotion_v4(mean(obj_ego_arousal,1)', mean(obj_ego_security,1)',mean(savReward,1)');
hold on
line([round((1/5)*nb_trials) round((1/5)*nb_trials)],[0 1],'LineStyle','--','Color','black')
line([round((2/5)*nb_trials) round((2/5)*nb_trials)],[0 1],'LineStyle', '--','Color','black')
line([round((3/5)*nb_trials) round((3/5)*nb_trials)],[0 1],'LineStyle', '--','Color','black')
line([round((4/5)*nb_trials) round((4/5)*nb_trials)],[0 1],'LineStyle', '--','Color','black')
line([nb_trials nb_trials],[0 1],'LineStyle', '--','Color','black')
hold off
axis([0 nb_trials 0 0.8])

%% 5) Plotting

% figure
% hold on
% plot(mean(obj_ego_arousal,1),'b')
% plot(mean(obj_ego_security,1),'r')
% line([round((1/5)*nb_trials) round((1/5)*nb_trials)],[0 1],'LineStyle','--','Color','black')
% line([round((2/5)*nb_trials) round((2/5)*nb_trials)],[0 1],'LineStyle', '--','Color','black')
% line([round((3/5)*nb_trials) round((3/5)*nb_trials)],[0 1],'LineStyle', '--','Color','black')
% line([round((4/5)*nb_trials) round((4/5)*nb_trials)],[0 1],'LineStyle', '--','Color','black')
% line([nb_trials nb_trials],[0 1],'LineStyle', '--','Color','black')
% legend('arousal','security')
% hold off
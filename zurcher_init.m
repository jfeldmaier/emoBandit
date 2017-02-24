
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
function obj = zurcher_init(nb_arms,nb_trials)

% Zurcher Model Initialisation
obj.ego.pos = [0,0];
obj.ego.a = 0; %security
obj.ego.s = 0; % arousal
obj.ego.nb_trial = nb_trials;
obj.ego.trial_i = 0;
obj.ego.nb_arms = nb_arms;
obj.actor = [];
obj.relevances = zeros(obj.ego.nb_arms,1);
obj.familiarity = zeros(obj.ego.nb_arms,1);
obj.XMAX = 6;
obj.R = 1.5;      % original: 2.5
obj.ego.E = 0.8;
obj.ego.D = 0.4;

% Calculate Object (Arm) Positions
obj.pos = create_circle_points(obj.ego.nb_arms,2);
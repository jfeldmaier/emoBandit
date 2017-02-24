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
function [ obj ] = zurcher_offline( obj )
%ZURCHER Summary of this function goes here
%   Detailed explanation goes here

%% Parameters
d = 0.3;    % Momentum damping (default 0.3)
en_pool = false;   % enables pools
en_hyst = false;   % enables hysteresis
if not(isfield(obj.ego,'D'))
    D = 0.75;    % Dependency [0 ... 1] infant: .75 child: 0.6
else D = obj.ego.D; end

if not(isfield(obj.ego,'E'))
    E = 0.8;    % Enterprise [0 ... 1] child: 0.4
else E = obj.ego.E; end


R = obj.R;      % original: 2.5
XMAX = obj.XMAX;

if isempty(obj.actor)
    obj.actor.A_s_pool = 0;
    obj.actor.A_a_pool = 0;
    obj.actor.time = 0;
    obj.actor.fillrate = 0.4; % default 0.4
    obj.actor.A_a = 0;
    obj.actor.A_s = 0;
    obj.actor.B = 0;
    obj.actor.sec_rising = false;
    obj.actor.As1 = 0.25;
    obj.actor.As2 = 0.5;
    obj.actor.sweetHome = false;
    obj.actor.party = false;
    obj.actor.lambda_s_app = 0;
    obj.actor.lambda_a_app = 0;
    obj.actor.lambda_a_av = 0;
    
end

% extract variables
objR = obj.relevances;
objF = obj.familiarity;

obj.actor.time = obj.actor.time + 1;

[x_i, x_i_uni]  = calcX(obj.ego.pos,obj.pos);


H_x_i =  calcH(R,XMAX,x_i);
objP = objR .* H_x_i;
P = 1 - (prod(1 - objP,1));             % Joint Potency
if all(objP == 0)
    F = 0;
else
    F = (sum(objP .* objF)) / sum(objP);      % Joint Familiarity Atmosphere
end

H2_x_i =  calcH(R,XMAX,x_i);
objP2 = objR .* H2_x_i;

% Incentive Vectors
I_si = bsxfun(@times,(objP2 .* objF), x_i_uni);
I_ai = bsxfun(@times,(objP2 .* (1 - objF)),x_i_uni);

%    I_si = bsxfun(@times,(objP2 - objF), x_i_uni);
%    I_ai = bsxfun(@times,(objP2 - (1 - objF)),x_i_uni);
% Joint Incentive Vectors
I_s = sum(I_si,1);
I_a = sum(I_ai,1);

% Security and Arousal
a = P * (1 - F);
s = P * F;

obj.ego.a = a;
obj.ego.s = s;


if en_pool == true
    % Activation components (pools enabled)
    obj.actor.A_a = E - a;
    obj.actor.A_s = D - s;
    
    obj.actor = fillPools(obj.actor, []);
    
    A_s = obj.actor.A_s_pool;
    A_a = obj.actor.A_a_pool;
    
else
    % Activation components
    A_a = E - a;
    A_s = D - s;
    
    %Plotting
    %    figure(h_pool)
    %    scatter(obj.actor.time,A_a,5,'bo','filled');
    %    scatter(obj.actor.time,A_s,5, 'go','filled');
    
end

% Momentum Vectors
M_s = I_s .* A_s;
M_a = I_a .* A_a;

% Hysterese
if en_hyst == false                         % Hysterese disabled
    % Resulting Momentum incl. damping
    M = d .* (M_a + M_s);
else                                        % Hysterese enabled
    if (obj.actor.A_s_pool >= obj.actor.As2)
        obj.actor.lambda_s_app = 1;
        obj.actor.sweetHome = true;
    end
    if (obj.actor.sweetHome && obj.actor.A_s_pool > 0)
        obj.actor.lambda_s_app = 1;
    end
    if (obj.actor.sweetHome && (obj.actor.A_s_pool < 0) && (obj.actor.A_s_pool > -obj.actor.As1))
        obj.actor.lambda_s_app = (1 + (obj.actor.A_s_pool / obj.actor.As1));
    end
    if (obj.actor.sweetHome && (obj.actor.A_s_pool < -obj.actor.As1) && (obj.actor.A_s_pool > -obj.actor.As2))
        obj.actor.lambda_s_app = 0;
    end
    if (obj.actor.A_s_pool <= -obj.actor.As2)
        obj.actor.lambda_s_app = 0;
        obj.actor.sweetHome = false;
    end
    if obj.actor.sweetHome
        obj.actor.lambda_a_app = 0;
    end
    if (obj.actor.A_s_pool <= -obj.actor.As2)
        obj.actor.lambda_a_app = 1;
        obj.actor.lambda_a_av = 1;
        obj.actor.party = true;
    end
    if (obj.actor.party && (obj.actor.A_s_pool < 0))
        obj.actor.lambda_a_app = 1;
    end
    if (obj.actor.party && (obj.actor.A_s_pool > 0) && (obj.actor.A_s_pool < obj.actor.As1))
        obj.actor.lambda_a_app = (1 - (obj.actor.A_s_pool / obj.actor.As1));
    end
    if (obj.actor.party && (obj.actor.A_s_pool > obj.actor.As1) && (obj.actor.A_s_pool < obj.actor.As2))
        obj.actor.lambda_a_app = 0;
    end
    if (obj.actor.A_s_pool >= obj.actor.As2)
        obj.actor.lambda_a_app = 0;
        obj.actor.lambda_a_av = 0;
        obj.actor.party = false;
    end
    % Resulting Momentum using Hysterese
    M = (obj.actor.lambda_s_app .* I_s) + (obj.actor.lambda_s_app .* M_a) + (obj.actor.lambda_a_av .* M_a);
    
end

% Calculate new actor position
obj.ego.pos = obj.ego.pos + M;


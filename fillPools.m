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
function [ actor ] = fillPools( actor , h )

A_s_pool = actor.A_s_pool;
A_a_pool = actor.A_a_pool;
fillrate =  actor.fillrate;
B = actor.B;
sec_rising = actor.sec_rising;
beta = 1;

A_s_pool = (A_s_pool + (actor.A_s * fillrate));
A_a_pool = (A_a_pool + (actor.A_a * fillrate));
tmp = A_s_pool;

if (A_s_pool >= 1)
    A_s_pool = 1;
end

if (A_s_pool <= -1)
    A_s_pool = -1;
end

if (A_a_pool >= 1)
    A_a_pool = 1;
end

if (A_a_pool <= -1)
    A_a_pool = -1;
end

if (A_a_pool == 1)
    B = (actor.A_a * beta);
%    disp('A_a_pool == 1')
end

if (tmp < A_s_pool)
    sec_rising = true;
    %disp('sec_rising triggered')
else
    sec_rising = false;
end

if not(isempty(h))
    figure(h)
    scatter(actor.time,actor.A_a,5,'bo','filled');
    scatter(actor.time, actor.A_a_pool,5, 'ro','filled');
    scatter(actor.time,actor.A_s,5, 'go','filled');
    scatter(actor.time, actor.A_s_pool,5, 'mo','filled');
end

actor.A_s_pool = A_s_pool;
actor.A_a_pool = A_a_pool;
actor.B = B;
actor.sec_rising = sec_rising;

end


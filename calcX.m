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
function [ x_i, x_i_uni ] = calcX( pos, objPos )
%CALCX Summary of this function goes here
%   Detailed explanation goes here

x_i = bsxfun(@minus,objPos,pos);

tmp_dist = sqrt(sum(abs(x_i).^2,2));

x_i_uni = zeros(size(x_i));

for i = 1:size(x_i,1)
    if tmp_dist(i) == 0
        x_i_uni(i,:) = [0,0];
    else
        x_i_uni(i,:) = x_i(i,:) ./ tmp_dist(i);
    end
end

end


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
function [ H_x_i ] = calcH(r, x_max, x_i )
%CALCH Summary of this function goes here
%   Detailed explanation goes here

dists = sqrt(sum(abs(x_i).^2,2));

H_x_i = (r .* (x_max - dists)) ./ (r .* (x_max - dists) + (dists .* x_max));

% H_x_i = (r .* (bsxfun(@minus,x_max,x_i))) ./ ...
%     (r .* (bsxfun(@minus,x_max,x_i)) + x_i .* x_max);

H_x_i(find(dists >= x_max)) = 0;

end


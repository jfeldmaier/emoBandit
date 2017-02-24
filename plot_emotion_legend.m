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
function plot_emotion_legend

load plutchik_cmap
cmap(1,:) = [0.0    1.0    1.0];
emo_str = {
    'uncertainty',
    'aversion',
    'anger',
    'fear',
    'anticipation'
    'joy'
    'trust'
    };
% annotation('rectangle', [0 0.95 0.1 0.02],'FaceColor',cmap(1,:))
annotation('rectangle', [0.15 0.95 0.12 0.04],'FaceColor',cmap(1,:))
annotation('rectangle', [0.27 0.95 0.11 0.04],'FaceColor',cmap(44,:))
annotation('rectangle', [0.38 0.95 0.11 0.04],'FaceColor',cmap(54,:))
annotation('rectangle', [0.46 0.95 0.08 0.04],'FaceColor',cmap(60,:))
annotation('rectangle', [0.54 0.95 0.13 0.04],'FaceColor',cmap(35,:))
annotation('rectangle', [0.67 0.95 0.1 0.04],'FaceColor',cmap(26,:))
annotation('rectangle', [0.75 0.95 0.1 0.04],'FaceColor',cmap(19,:))
annotation('textbox', [0.15 0.955 0.1 0.04], 'String', emo_str{1},'Color','black', 'EdgeColor','none','FontSize',12);
annotation('textbox', [0.27 0.955 0.1 0.04], 'String', emo_str{2},'EdgeColor','none','FontSize',12);
annotation('textbox', [0.38 0.955 0.1 0.04], 'String', emo_str{3},'EdgeColor','none','FontSize',12);
annotation('textbox', [0.46 0.955 0.1 0.04], 'String', emo_str{4},'EdgeColor','none','FontSize',12);
annotation('textbox', [0.54 0.955 0.1 0.04], 'String', emo_str{5},'EdgeColor','none','FontSize',12);
annotation('textbox', [0.67 0.955 0.1 0.04], 'String', emo_str{6},'EdgeColor','none','FontSize',12);
annotation('textbox', [0.75 0.955 0.1 0.04], 'String', emo_str{7},'EdgeColor','none','FontSize',12);

end


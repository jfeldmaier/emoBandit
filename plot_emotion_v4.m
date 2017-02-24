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
function [ h ] = plot_emotion_v4( arousal, security, reward )
%PLOT_MOOD Summary of this function goes here
% coloarmapping equals to more intuitive colors
% green -> joy
% red -> anger
% blue -> uncertainty 
% pink -> vigilance
% orange -> amazement


if size(arousal) ~= size(security)
    disp('Error, input sizes do not match!')
    return
end

% h = figure;
%% initialization
nb_emotions = 7; % number of different emotions
tmp = zeros(nb_emotions,size(arousal,1));
tmp_col = zeros(nb_emotions,3);
wS = 5; % window size
wS2 = 2;
load plutchik_cmap
cmap(1,:) = [0.0    1.0    1.0];

%% emotion assignement

% uncertainty / sadness
tmp(1,arousal < 0.15 & security < 0.15) = 0.1; % 0.1 and 0.1
tmp_col(1,:) = cmap(1,:);

% disgust / aversion
tmp(2,gradient(filter(ones(1,wS)/wS,1,security)) < 0 & ...
    gradient(filter(ones(1,wS)/wS,1,arousal)) > 0) = 0.2;
tmp_col(2,:) = cmap(42,:);

% anger
tmp(3,(arousal > 0.85 & security < 0.15) | ...
    (gradient(abs(filter(ones(1,wS2)/wS2,1,arousal))) > 0.0075 & security < 0.3)) = 0.3; % 0.9 and 0.1
tmp_col(3,:) = cmap(54,:);

% fear / negative surprise
tmp(4,gradient(abs(filter(ones(1,wS)/wS,1,arousal))) > 0 & ...
    gradient(abs(filter(ones(1,wS)/wS,1,security))) < 0 & ...
    arousal > security) = 0.4; %14
% tmp(5,abs(gradient(abs(filter(ones(1,wS)/wS,1,arousal)))) > 0.002 & ...
%     abs(gradient(abs(filter(ones(1,wS)/wS,1,security)))) > 0.002 & ...
%     arousal > security) = 0.5; %14
tmp_col(4,:) = cmap(60,:);

% confidence / anticipation / positive surprise
tmp(5,gradient(filter(ones(1,wS)/wS,1,security)) > 0 & ...
    gradient(filter(ones(1,wS)/wS,1,arousal)) < 0 & ...
    arousal < security)= 0.5;  % 23;  %50;
tmp_col(5,:) = cmap(35,:);

% joy
tmp(6,arousal < security & gradient(filter(ones(1,wS)/wS,1,arousal)) <= 0) = 0.6;
tmp_col(6,:) = cmap(26,:);

% trust
tmp(7,(arousal < security) & abs(gradient(filter(ones(1,wS)/wS,1,arousal))) < 0.0005 ... 
    & abs(gradient(filter(ones(1,wS)/wS,1,security))) < 0.0005) = 0.7;  %32;
tmp_col(7,:) = cmap(19,:);


% surprise
% tmp(abs(gradient(abs(filter(ones(1,wS)/wS,1,arousal)))) > 0.002 & ...
%    abs(gradient(abs(filter(ones(1,wS)/wS,1,security)))) > 0.002) = 9; %14

%% Plotting

%tmp = tmp ./ 64; % convert tmp into [0 ... 1]

tmp_rew = cumsum(reward,1);
tmp_rew = (tmp_rew - min(tmp_rew)) ./ (max(tmp_rew) - min(tmp_rew)); 

%h = cline_mod(2:size(arousal,1),tmp_rew,tmp);

tmp(tmp == 0) = NaN;

figure
hold on

% for i = 1:nb_emotions
%     scatter(1:size(tmp,2),tmp(i,:),20,tmp_col(i,:),'filled')
% end
% legend('mood','arousal','security','Location','Best')

for i = 1:nb_emotions
    for j = 1:size(tmp,2)
        line([j j],[tmp(i,j)-0.045 tmp(i,j)+0.045],'LineWidth',2,'Color',tmp_col(i,:))
    end
end

%secCol = [62 62 62]./255;
h1 = plot(arousal,'b','LineWidth',1.5);
h2 = plot(security,'r','LineWidth',1.5);

%cpoints(2:size(arousal,1),tmp_rew',tmp);

h_legend = legend([h1 h2],'arousal','security');
set(h_legend,'FontSize',12);
xlabel('Trials','FontSize',12)
ylabel('emotion/strength','FontSize',12)
plot_emotion_legend

hold off


end


function h=cline_mod(x,y,c)

if nargin<3
    fprintf('Insufficient input arguments\n');
    return;
end

load plutchik_cmap                  % load colormap

%cmap=colormap(cmap);                     % Set colormap

figure
set(gcf,'Colormap',cmap);

%yy=linspace(max(c),min(c),size(cmap,1));  % Generate range of color indices that map to cmap
yy=linspace(64,0,size(cmap,1));
cm = spline(yy,cmap',c);                  % Find interpolated colorvalue
cm(cm>1)=1;                               % Sometimes iterpolation gives values that are out of [0,1] range...
cm(cm<0)=0;

%figure
h = zeros(1,length(x));

% plot line segment with appropriate color for each data pair...
for i=1:length(x)-1
    h(i)=line([x(i) x(i+1)],[y(i) y(i+1)],'color',[cm(:,i)],'LineWidth',1.5);
end

end

function h=cpoints(x,y,c)

if nargin<3
    fprintf('Insufficient input arguments\n');
    return;
end

load plutchik_cmap                  % load colormap

%cmap=colormap(cmap);                     % Set colormap

figure
set(gcf,'Colormap',cmap);

h = scatter(x,y,3.6,c(1:end-1,:),'o');

end

function makeAMRFplot( const, RF )
% -------------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Updated...........15 | 09 | 2018
% Project................FeaturePL
% Version........................1
% -------------------------------------------------------------------------

%Create simple plot:
t = 1:length(RF.x);
fig1 = figure('name','Running Fit Adaptive Procedure');
plot(t,RF.x,'k');
hold on;
plot(t(RF.response == 1),RF.x(RF.response == 1),'ko', 'MarkerFaceColor','k');
plot(t(RF.response == 0),RF.x(RF.response == 0),'ko', 'MarkerFaceColor','w');
set(gca,'FontSize',16);
axis([0 max(t)+1 min(RF.x)-(max(RF.x)-min(RF.x))/10 ...
    max(RF.x)+(max(RF.x)-min(RF.x))/10]);
line([1 length(RF.x)], [0 0],'linewidth', 2, 'linestyle', '--', 'color','k');
xlabel('Trial');
ylabel('Angle change [deg]');

% Add the threshold to the plot
titleTxt = sprintf('%s, cond = %1.0f, TH = %3.2f',const.sjct,const.cond, RF.mean);
title(titleTxt)

% Save Figure
fig1.PaperUnits = 'centimeters';
fig1.PaperOrientation = 'landscape';
print('-bestfit','-dpdf','-r300',sprintf('Data/%s/ExpData%s/B%i/quest_B%i',const.sjct,const.typeTaskName,const.fromBlock, const.fromBlock));
close(fig1)
end


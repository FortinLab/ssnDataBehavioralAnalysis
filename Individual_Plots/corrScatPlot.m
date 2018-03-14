function [rVal,pVal] = corrScatPlot(xDta, yDta, xLbl, yLbl, varargin)
%% Correlation Scatter Plot
% [rVal, pVal] = corrScatPlot(xDta, yDta, xLbl, yLbl, varargin);
% xDta = X-data
% yDta = Y-data
% xLbl = X-axis Label
% yLbl = Y-axis Label
%%
if nargin == 2
    xLbl = [];
    yLbl = [];
end
if strcmp(varargin, 'zroNaN')
    if sum(isnan(xDta))
        nanSpt = isnan(xDta);
        xDta(nanSpt) = 0;
        yDta(nanSpt) = 0;
    elseif sum(isnan(yDta))
        nanSpt = isnan(yDta);
        yDta(nanSpt) = 0;
        xDta(nanSpt) = 0;
    end
end
[r p] = corrcoef(xDta, yDta);
if sum(strcmp(varargin{1}, 'markerStyle'))>=1
    mrkrSpt = find(strcmp(varargin{1}, 'markerStyle'));
    scatter(xDta, yDta, varargin{1}{mrkrSpt+1});
else
    scatter(xDta, yDta);
end
hold on
eq1 = polyfit(xDta,yDta,1);
vCalc1 = polyval(eq1, xDta);
plot(xDta, vCalc1, 'red', 'linewidth', 2);
if p(2)<=0.05
    annotation(gcf, 'textbox', get(gca, 'position'), 'string',...
     [{['r = ' num2str(r(2))]}; {['p = ' num2str(p(2))]}], 'linestyle', 'none', 'color', 'r');
else
    annotation(gcf, 'textbox', get(gca, 'position'), 'string',...
     [{['r = ' num2str(r(2))]}; {['p = ' num2str(p(2))]}], 'linestyle', 'none');
end
xlabel(xLbl);
ylabel(yLbl);

rVal = r(2);
pVal = p(2);
if strcmp(varargin, 'coordOn')
    hold on
    line(get(gca, 'xlim'), [0 0], 'linewidth', 0.5, 'linestyle', ':', 'color', 'black')
    line([0 0], get(gca, 'ylim'), 'linewidth', 0.5, 'linestyle', ':', 'color', 'black')
end
if strcmp(varargin, 'gridOn')
    grid on;
end

drawnow;
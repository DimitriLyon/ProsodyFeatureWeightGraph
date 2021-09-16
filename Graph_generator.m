clear;
filename = input('Type the name of the file that was output from FileProcessor.py: ')
data = load(filename,'-ascii');
%initiate color for the bubbles
the_color = [0, 0.4470, 0.7410];
%set ticks on the x-axis
graph_scale = [-1600,-800,-400,0,400,800,1600];
%set places where labels on the y-axis will go
y_scale = [1.5, 3.5, 5.5, 7.5, 9.5, 11.5, 13.5, 15.5, 17.5, 19.5];
%create labels for the y-axis
yLabels = {'voiced-unvoiced intensity ratio', 'late pitch peak', 'breathiness', 'creakiness', 'speaking rate', 'pitch lowness', 'pitch highness', 'pitch narrowness', 'pitch wideness', 'intensity'};
gra = axes('XLim', [-1800,1800], 'XTick', graph_scale, 'YLim', [0,26], 'YTick', y_scale);
%setting y-axis labels
set(gra, 'YTickLabel', yLabels);
%Sets the title for the x-axis.
XAxisLabel = get(gra,'XLabel');
set(XAxisLabel,'String','milliseconds');
%Gets the size of the data array so it can be iterated accross.
data_size = size(data);
for line = 1:data_size(1)
    rectThickness = data(line);
    if abs(rectThickness) > 1
        startTime = data(line,3);
        length = data(line,4)-startTime;
        pos = [startTime,data(line,2) * 2 - 1,length,1];
        if abs(rectThickness) == 3
            pos(2) = pos(2) + .25;
            pos(4) = .5;
        elseif abs(rectThickness) == 2
            pos(2) = pos(2) + .375;
            pos(4) = .25;
        end
        r(line) = rectangle('Position', pos, 'EdgeColor', the_color);
        if rectThickness > 0
            set(r(line), 'FaceColor', the_color);
        end
        curve = [1,1];
        %small length 1300+ use 1/64 curvature 
        %small length 675-1299 use 1/32 curvature
        %small 350-674 use 1/16 curvature
        %small 150-349 use 1/8 curvature
        %small 149 and below use 1/4 curvature
        if abs(rectThickness) == 2
            if length >= 1300
                curve(1) = 1/64;
            elseif length >= 675
                curve(1) = 1/32;
            elseif length >= 350
                curve(1) = 1/16;
            elseif length >= 150
                curve(1) = 1/8;
            else
                curve(1) = 1/4;
            end
        %med 1100+ use 1/16 curvature
        %med 650-1099 use 3/32 curvature
        %med 400-649 use 3/16 curvature
        %med 200-399 use 1/4 curvature
        %med 199 and below use 6/8 curvature
        elseif abs(rectThickness) == 3
            if length >= 1100
                curve(1) = 1/16;
            elseif  length >= 700
                curve(1) = 3/32;
            elseif length >= 400
                curve(1) = 3/16;
            elseif length >= 200
                curve(1) = 1/4;
            else
                curve(1) = 6/8;
            end
        %large 1300+ use 1/16 curvature
        %large 950-1299 use 1/8 curvature
        %large 800-949 use 3/16 curvature
        %large 600-799 use 1/4 curvature
        %large 500-599 use 5/16 curvature
        %large 350-499 use 3/8 curvature
        %large 300-349 use 7/16 curvature
        %large 150-299 use 5/8 curvature
        %large 149 and below use 15/16 curvature    
        else
            if length >= 1300
                curve(1) = 1/16;
            elseif length >= 950
                curve(1) = 1/8;
            elseif length >= 800
                curve(1) = 3/16;
            elseif length >= 600
                curve(1) = 1/4;
            elseif length >= 500
                curve(1) = 5/16;
            elseif length >= 350
                curve(1) = 3/8;
            elseif length >= 300
                curve(1) = 7/16;
            elseif length >= 150
                curve(1) = 5/8;
            else
                curve(1) = 15/16;
            end
        end
        set(r(line), 'Curvature', curve);
    end
end

%Creates legend rectangles.
%-1000 - -400 with a length of 200
%large will have a curve of 5/8
%height of 22 and 24
%med will have a curve of 1/2
%height of 22.125 and 24.125
%small will have a curve of 1/8
%height of 22.375 and 24.375 
rectLegend(1,1) = rectangle('Position', [-1000,22,200,1], 'Curvature', [5/8,1], 'EdgeColor', the_color);
rectLegend(2,1) = rectangle('Position', [-800,22.25,200,.5], 'Curvature', [1/4,1], 'EdgeColor', the_color);
rectLegend(3,1) = rectangle('Position', [-600,22.375,200,.25], 'Curvature', [1/8,1], 'EdgeColor', the_color);
rectLegend(1,2) = rectangle('Position', [-1000,24,200,1], 'Curvature', [5/8,1], 'EdgeColor', the_color, 'FaceColor', the_color);
rectLegend(2,2) = rectangle('Position', [-800,24.25,200,.5], 'Curvature', [1/4,1], 'EdgeColor', the_color, 'FaceColor', the_color);
rectLegend(3,2) = rectangle('Position', [-600,24.375,200,.25], 'Curvature', [1/8,1], 'EdgeColor', the_color, 'FaceColor', the_color);

legend(1) = text(-300,22.5,'negative weights: > .08,> .04,> .02');
legend(2) = text(-300,24.5,'positive weights: > .08,> .04,> .02');

%Code to save the figure
filenameSize = size(filename);
filenameSize = filenameSize(2);
fig = get(gra,'Parent');
figname = cat(2,filename(1:filenameSize-3),'fig');
saveas(fig,figname);

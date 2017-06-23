classdef tiny_visualizer < handle
    properties
        figure
        marker
    end
    
    methods
        function this = tiny_visualizer(state)
            [locx, locy]= getlocation(state);
            this.figure = figure;
            I = imread('tiny-rl-example.png');
            imshow(I);
            hold on            
            this.marker = plot(locx,locy,'o', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
            hold off
        end
        
        function update(this, state)
            [this.marker.XData, this.marker.YData]= getlocation(state);             
            drawnow
            pause(0.2)
        end
        
        function delete(this)
            if ishandle(this.figure)
                close(this.figure)
            end
        end
    end
    
end

function [x,y] = getlocation(s)
switch s
    case 0
        x = 70;
        y = 75;
    case 1
        x = 95;
        y = 75;
    case 2
        x = 70;
        y = 45;
    case 3
        x = 95;
        y = 45;
    case 4
        x = 70;
        y = 15;
    case 5
        x = 95;
        y = 15;
end
end
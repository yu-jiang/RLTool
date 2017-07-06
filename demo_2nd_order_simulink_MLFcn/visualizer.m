classdef visualizer < handle
    properties
        figure
        marker
    end
    
    methods
        function this = visualizer(state)
           % [locx, locy]= getlocation(state);
            this.figure = figure();       
            this.marker = plot(state(1),0,'o', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
            axis([-1 1 -0.25 0.25]);
        end
        
        function update(this, state)
            this.marker.XData = state(1);            
            drawnow
            %pause(0.1)
        end
        
        function delete(this)
            if ishandle(this.figure)
                close(this.figure)
            end
        end
    end
    
end
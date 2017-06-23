classdef double_integ_env < handle
    properties
        s_init % second order system
        viewer
    end
    
    properties
        IsStopped = false;
        s
        t = 0; % time, or number of steps        
    end
    
    methods
        function this = double_integ_env(initstate)
            this.s_init = initstate;
            this.viewer = visualizer(initstate);            
        end
        
        function this = reset(this)
            this.t = 0;
            this.s = this.s_init;
            this.IsStopped = false;
        end
        
         function this = randomStart(this)
            this.t = 0;
            this.s = [rand-.5; 0];
         end
        
        function [s_new, r] = step(this, a)
            
            %this.viewer.update(this.s);
            
            %%
            dt = 0.1;
            if ~this.IsStopped                                
                r = -this.s(1)^2 - this.s(2)^2;                                    
                [~, y] = ode45(@(t,x)double_integ_sys(t,x,a), [0 dt], this.s);
                s_new = y(end,:);
                this.s = s_new;
                this.t = this.t + dt;
            else
                s_new = this.s;
                this.t = this.t + dt;
                r = -100;
            end
            
            %% Check termination
            if abs(s_new(1)) > 1
                this.IsStopped = true;
                r = -100;
                disp('Failed')
            end
        end
    end
end


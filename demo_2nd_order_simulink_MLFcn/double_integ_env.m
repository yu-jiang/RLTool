classdef double_integ_env < handle
    properties
        s_init % second order system
        viewer
        model
        dt = 0.05
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
            this.model = 'sl_demo';
            open_system(this.model);
            set_param(this.model,'FastRestart','on')
            set_param(this.model, 'StopTime', num2str(this.dt));
            
            assignin('base', 'x0', initstate(1));
            assignin('base', 'dx0', initstate(2));
            assignin('base', 'action', 0);
        end
        
        function term(this)
            set_param(this.model,'FastRestart','off')
        end
        
        function this = reset(this)
            this.t = 0;
            this.s = this.s_init;
            this.IsStopped = false;
            assignin('base', 'x0', this.s(1));
            assignin('base', 'dx0', this.s(2));
        end
        
         function this = randomStart(this)
            this.t = 0;
            this.s = [(rand()-.5) 0];
            assignin('base', 'x0', this.s(1));
            assignin('base', 'dx0', this.s(2));
         end
        
        function [s_new, r] = step(this, a)
            
            this.viewer.update(this.s);
            
            %%
            if ~this.IsStopped
                r = 1/(100*this.s(1)^2+this.s(2)^2+0.01);
                assignin('base', 'x0', this.s(1));
                assignin('base', 'dx0', this.s(2));
                assignin('base', 'action',a);
                simresults = sim(this.model);
                y = simresults.get('xout');
                s_new = y(end,:);
                this.s = s_new;
            else
                s_new = this.s;                
                r = -1000;
            end
            
            %% Check termination
            if min(s_new) < -1 || max(s_new) > 1
                this.IsStopped = true;
                r = -100;
                disp('Failed')
            end
            
         end
    end
end


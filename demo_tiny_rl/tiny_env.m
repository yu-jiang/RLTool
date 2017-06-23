classdef tiny_env < handle
    properties
        s_init
        viewer
    end
    
    properties
        IsStopped = false;
        s
        t = 0; % time, or number of steps        
    end
    
    methods
        function this = tiny_env(initstate)
            this.s_init = initstate;
            this.viewer = tiny_visualizer(initstate);            
        end
        
        function this = reset(this)
            this.t = 0;
            this.s = this.s_init;
        end
        
        function [s_new, r] = step(this, a)
            % x = 0,1,2,3,4,5
            % a = 1,2,3,4 (up, right, left, down)
            
            this.viewer.update(this.s);
            
            % reward table | up | right | left | down
            rtable =   [-1 -1 -1   -1;           % s0
                -1 -1 -1   -1;                   % s1
                -1 -1 -100 -1                    % s2
                -1 -1 -1   -1;                   % s3
                -1 -1 10   -1                    % s4
                -1 -1 -1   -1];                  % s5
            
            xtable =    [2  1  0   0;                     % s0
                3  1  0   1;                     % s1
                4  3  2   0                      % s2
                5  3  2   1;                     % s3
                4  5  0   2                      % s4
                5  5  4   3];                    % s5
            
            s_new = xtable(this.s+1, a);
            r     = rtable(this.s+1, a);
            
            this.s = s_new;
            this.t = this.t + 1;
        end
    end
end


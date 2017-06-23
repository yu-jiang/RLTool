classdef qtable_interp < handle
    
    % Q table with interpolation
    
    % defining the data 
    properties (SetAccess = protected)
        Table     % Main q table   
        Actor     % mapping: statevalue -> actionvalue
        StateGrid    rlstate
        ActionGrid   rlaction
    end
    
    % parameters for q learning
    properties
        LearningRate = 0.2;
        DiscoutingFactor = 0.9;
        Epsilon = 0.1;
    end
    
    
    methods                
        % constructor, creating a q table from stategrid and actiongrid
        function this = qtable(stategrid, actiongrid)
            this.StateGrid   = stategrid;
            this.ActionGrid  = actiongrid;
            this.Table = zeros(this.StateGrid.Length, this.ActionGrid.Length);
            this.Actor = zeros(this.StateGrid.Length, 1);
        end        
        
        % method to update Q table
        function update(this, pre_state, pre_action, new_state, reward)            
            pre_state_idx  = this.StateGrid.getIndex(pre_state);
            pre_action_idx = this.ActionGrid.getIndex(pre_action);
            new_state_idx = this.StateGrid.getIndex(new_state);
            
            % Q table update
            newQvalue = getOptimalQValue(this, new_state_idx);
            this.Table(pre_state_idx, pre_action_idx) = ...
                (1 - this.LearningRate)*this.Table(pre_state_idx, pre_action_idx) + ...
                this.LearningRate*(reward + this.DiscoutingFactor*newQvalue);                
        end        
        
        % get Optiaml value from a state index
        function Qvalue = getOptimalQValue(this, state_idx)
            %state_idx = this.StateGrid.getIndex(statevalue);
            Qvalue = max(this.Table(state_idx, :));
        end
            
        % get Optimal action with epsilon-greedy exploration
        function action = getAction(this, statevalue)
            state_idx = this.StateGrid.getIndex(statevalue);
            randvar = rand;
            if randvar > this.Epsilon
                Qvalue = getOptimalQValue(this, state_idx);
                action_idx_all = find(this.Table(state_idx, :) == Qvalue);
                if numel(action_idx_all)>1
                    randvar2 = randi(numel(action_idx_all));
                    action_idx = action_idx_all(randvar2);
                else
                    action_idx = action_idx_all;
                end
            else
                % if multiple actions have the same value, randomly pick
                % one.
                action_idx = randi(this.ActionGrid.Length, 1);               
            end
            action = this.ActionGrid.getValue(action_idx);
        end
        
        % get optimal action with no exploration
        function action = getOptimalAction(this, statevalue)
            state_idx = this.StateGrid.getIndex(statevalue);
            [~, action_idx] = max(this.Table(state_idx, :));
            action = this.ActionGrid.getValue(action_idx);
            
            action = interp1(stateIndex,v,xq)
        end
    end
end
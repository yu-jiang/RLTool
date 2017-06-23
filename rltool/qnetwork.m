classdef qnetwork < handle
    properties
        Qnn                     % q network
        
        BatchInput              %
        BatchTarget             %
        BatchInputInUse
        BatchTargetInUse
        
        LearningRate = 0.2;
        DiscoutingFactor = 0.9;
        Epsilon = 0.1;
    end
    
    properties (Access = private)
        ActionSamples = [];
    end
    
    methods
        % Constructor for qnetwork
        function this = qnetwork(statedim, actionSamples)
            % Create network
            this.Qnn = feedforwardnet(5);
            % Configure input and output size
            inputdim = 1;
            this.Qnn = configure(this.Qnn, ...
                zeros(statedim + inputdim, 1), 0);
            %
            this.ActionSamples = actionSamples;
        end
        
        % This works for discrete input actions
        function action = getOptimalAction(this, state)
            [~, action] = getOptimalQValue(this, state);
        end
        
        function collectData(this, pre_state, pre_action, new_state, reward)
            
            this.BatchInput = [this.BatchInput, ...
                [pre_state(:);
                pre_action(:)]];
            
            newQvalue = getOptimalQValue(this, new_state);
            
            targetQ = (1 - this.LearningRate)*getQValue(this, pre_state, pre_action) + ...
                this.LearningRate*(reward + this.DiscoutingFactor*newQvalue);
            
            this.BatchTarget =  [this.BatchTarget targetQ];
        end
        
        function q = getQValue(this, state, action)
            q = this.Qnn([state(:); action]);
        end
        
        function [q, action] = getOptimalQValue(this, state)
            allStateActionPairs = [repmat(state(:), 1, numel(this.ActionSamples));
                                  this.ActionSamples];
            allQs = this.Qnn(allStateActionPairs);
            [q, action_idx] = max(allQs);
            action = this.ActionSamples(action_idx);
        end
        
        function batchUpdate(this)
            this.Qnn = train(this.Qnn, this.BatchInput, this.BatchTarget);
            clearHistory(this);
        end
        
        function action = getAction(this, state)
            randvar = rand;
            if randvar > this.Epsilon
                % provide optimal action
                action = getOptimalAction(this, state);
            else
                action_idx = randi(numel(this.ActionSamples), 1);
                action = this.ActionSamples(action_idx);
            end
        end
        
        function clearHistory(this)
            this.BatchInput = [];
            this.BatchTarget = [];
        end
    end
end
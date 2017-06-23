%sgrid = rlstate(linspace(-1,1,30)-0.1, ...
%                linspace(-1,1,30)-0.1);
% agrid = rlaction([-5 -1 0 1 5]);
%qt = qtable(sgrid, agrid);
%qt.Epsilon = 0.2;
%qt.DiscoutingFactor = 1;

qnn = qnetwork(2,[-0.15:0.05:0.15]);
s = [0,0.1];
env = double_integ_env(s);
qnn.Epsilon = 0.1;
qnn.DiscoutingFactor = 1;
qnn.LearningRate = 1;


for iter = 1:100           % Iteration
    for cte = 1:100        % Episode
        env.reset();
        env.randomStart();        
        for cts = 1:100            
            a = qnn.getAction(s);
            [snew, r] = env.step(a);
            if env.IsStopped        
                break
            end
            qnn.collectData(s, a, snew, r);
            s = snew;            
        end
        disp(['### Iteration #', num2str(iter),  '--> Episode  #', num2str(cte), 'Final Time :', num2str(cts)]);
    end
    qnn.batchUpdate();
end

% for ctrun = 1:1000
%     env.reset();
%     env.randomStart();
%     qt.DiscoutingFactor = qt.DiscoutingFactor;
%     disp(['Trial #', num2str(ctrun)])
%     for ct = 1:500
%         %qt.Epsilon = 0.1/ct;
%         a = qt.getAction(s);
%         %disp(['s(1): ', num2str(s(1)), '  s(2): ', num2str(s(2))])
%         [snew, r] = env.step(a);
%         qt.update(s, a, snew, r);
%         s = snew;
%         if env.IsStopped
%             break
%         end
%     end
% end

%% Prepare model
Kd = 10;
L = 0.5;
g = 9.81;
mCart = 1;
mPend = 1;
theta0 = 0.01;
mdl = 'sl_demo';
open_system(mdl);
set_param(mdl, 'FastRestart', 'on');

% Create Q table
sgrid = rlstate(linspace(-0.2,0.2,20), ...
    linspace(-pi/4,pi/4,20), ...
    linspace(-1,1,20), ...
    linspace(-5,5,20));
agrid = rlaction([-0.01 0.01]);
qt = qtable(sgrid, agrid);
qt.Epsilon = 0.025;
qt.LearningRate = 0.9;
qt.DiscoutingFactor = 0.9;

% Initialize state and actions
xold = [0,theta0,0,0];
a = qt.getAction(xold);
dt = 0.02;

for ctrun = 1:500
    %% Reset model
    % xold = [0,0.1*(rand()-0.5),0,0];
    
%     if ctrun > 200
%         qt.Epsilon = 0.1/ctrun;
%     end
    
    simresults = sim(mdl);    
    t = simresults.get('tout');
    x = simresults.get('yout');
    disp(['Trial #', num2str(ctrun), ' Stop time =', num2str(t(end)), ' End State:' , num2str(x(end,:))]);
    
end

save qtabledata.mat qt

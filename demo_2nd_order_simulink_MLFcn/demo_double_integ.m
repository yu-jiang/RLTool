% Prepare model
mdl = 'sl_demo_16a';
open_system(mdl);
set_param(mdl, 'FastRestart', 'on');
%


% Create Q table
sgrid = rlstate(linspace(-1,1,100)-0.05, ...
                linspace(-0.25,0.25,10));
agrid = rlaction([-2 -1 1 2]);
qt = qtable(sgrid, agrid);
qt.Epsilon = 0.1;
qt.DiscoutingFactor = 0.9;

% Initialize state and actions
xold = [0,0.1];
dx0 = xold(2);
x0 = xold(1);
a = qt.getAction(xold);
dt = 0.05;

    

for ctrun = 1:200
    %% Reset model
    xold = [1.5*(rand()-0.5),0];
    dx0 = xold(2);
    x0 = xold(1);
    
    if ctrun > 200
        qt.Epsilon = 0.1/ctrun;
    end
    
    simresults = sim(mdl);    
    t = simresults.get('tout');
    disp(['Trial #', num2str(ctrun), ' Stop time =', num2str(t(end))]);
    
end

save qtabledata.mat qt

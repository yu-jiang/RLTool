sgrid = rlstate(0:5);
agrid = rlaction(1:4);
qt = qtable(sgrid, agrid);
qt.Epsilon = 0.025;


s = 3;
env = tiny_env(s);
env.reset();

for ct = 1:200
    %qt.Epsilon = 0.1/ct;
    a = qt.getAction(s);
    disp(['s: ', num2str(s), '  a: ', num2str(a)])
    [snew, r] = env.step(a);
    qt.update(s, a, snew, r);     
    s = snew;   
end
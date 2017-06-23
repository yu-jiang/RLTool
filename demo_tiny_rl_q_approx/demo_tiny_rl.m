qnn = qsvm(1, 1:4);
qnn.Epsilon = 0.2;

s = 3;
env = tiny_env(s);

for cti = 1:10
    env.reset();
    for ct = 1:20
        a = qnn.getAction(s);
        disp(['s: ', num2str(s), '  a: ', num2str(a)])
        [snew, r] = env.step(a);
        qnn.collectData(s, a, snew, r);
        s = snew;
    end
    qnn.batchUpdate();
end
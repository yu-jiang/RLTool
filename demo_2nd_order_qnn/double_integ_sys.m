function dx = double_integ_sys(t,x,u)
dx = [x(2);
      0.1*x(1) + u]; 
end
function [y,e] = za_lms(d,u,rho,mu,order)

% Input: 
%(1) d is the signal input, which in our case, is the abdomen3.
%(2) u is the teacher signal, which in our case is the thorax1 or thorax2.
%(3) mu is the step-size parameter.
%(4) order is the order of this Denoising Filter.
%(5) pho controls the strenth of the "zero-attracting term" 

% Output:
%(1) y is the prediction of signal.
%(2) e is the error, which in our case, is the extracted fECG.

[N,~] = size(u);
u = [zeros(order,1);u];

y = zeros(N,1);
e = zeros(N,1);
w = zeros(order,order);

vec_u = zeros(order,N);

for i = 1:(N-order)
    vec_u(:,i) = u(order-1+i:-1:i);
end

for n = 1:N
      y(n) = w(:,n)'*vec_u(:,n);
      e(n) = d(n) - y(n);
      w(:,n+1) = w(:,n) + mu*e(n)*vec_u(:,n)-rho*sign(w(:,n));
end


end


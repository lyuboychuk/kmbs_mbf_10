clear; clc;

N =20;
mu = [7.5 -3.25 -10.5 -1.3 0]';
sigma = [4.33 2.38 6.06 0.95 0.00]';
portf_w = [0.35 0.26 0.2 0.14 0.05]';



events = zeros (N,length(mu));
for i=1:length(mu)
    events(:,i)=normrnd(mu(i),sigma(i),1,N);
end

mu_p = portf_w'*mu
sigma_p = portf_w'*cov(events)*portf_w


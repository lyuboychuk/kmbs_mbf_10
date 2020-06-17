clear; clc;
N=10000; 
[r, trendLog] = portfolio_management(N);

% N=10000; 
% expected_depth =[.1 0.07 0.05]; std_depth =[.02 0.01 0.005];
% p_d =[.75 .65 .55];
% [r, trendLog] = stochastic_events_tree(p_d,expected_depth, std_depth, N);


figure; hold on;
title('Business activity scenarios');
xlabel('# scenario');
ylabel('relative growth');
plot(r'-1);
hold off;


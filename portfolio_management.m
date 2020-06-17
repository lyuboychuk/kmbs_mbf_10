function [r, new_trendLog] = portfolio_management(N)
    %N=10000; 
    porf_w = [0.35 0.26 0.2 0.14 0.05];

    expected_depth = zeros(length(porf_w), 3);
    std_depth= zeros(length(porf_w), 3);
    
    p_d =[.75 .65 .55;
          .8 .7 .6;
          .7 .65 .55;
          .8 .7 .6;
          .7 .65 .55;];

    expected_depth(1,:) =[.1 0.07 0.05]; std_depth(1,:) =[.02 0.01 0.005];
    expected_depth(2,:) =[-.1 -0.07 -0.05]; std_depth(2,:) =[.02 0.01 0.005];
    expected_depth(3,:) =[.5 0.035 0.025]; std_depth(3,:) =[.03 0.02 0.01];
    expected_depth(4,:) =[-.5 -0.035 -0.025]; std_depth(4,:) =[.02 0.01 0.005];
    expected_depth(5,:) =[.03 0.06 0.05]; std_depth(5,:) =[.04 0.02 0.01];

    [~,~,~,crisis_end,~,~]=InputData.crisis_params(0,0);
    r=zeros(N,crisis_end);

    % new_trendLog = zeros(N*length(expected_time),6);
    new_trendLog = [];

    for i=1:length(porf_w)
        [rr, trendLog] = stochastic_events_tree(p_d(i,:), expected_depth(i,:), std_depth(i,:), N);
        new_trendLog =[new_trendLog; [trendLog ones(length(trendLog),1)*porf_w(i)]];
        r = r+rr*porf_w(i);
    end
end
%plot(r');
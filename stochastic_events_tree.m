function [r, trendLog] = stochastic_events_tree(p_d, expected_depth,std_depth,N)

%N=10000; 
[~,~,~,crisis_end,~,~]=InputData.crisis_params(0,0);
[Initial_engaged_production_headcount, Working_days_per_month, blended_rate_hour] = InputData.company_params;

%r=ones(N,crisis_end).*(1-covid_quarantine_vacation)*Initial_engaged_production_headcount*Working_days_per_month*8*blended_rate_hour;
r=ones(N,crisis_end);

%corr =-.4;
% expected_time =6; std_time =0.75;
% expected_depth =.1; std_depth =.02;
%p_d =[.75 .65 .55];
%p_d =[1 .65 .55];
expected_time =[4 7 10]; std_time =[0.5 0.75 1];
%expected_depth =[.1 0.07 0.05]; std_depth =[.02 0.01 0.005];
corr = [-.4 -.4 -.4];


trendLog = zeros(N*length(expected_time),5);

tic;
for s=1:length(expected_time) 
    copula = copularnd('gaussian',corr(s),N);
    fprintf('step %i\n', s)
    time = round(norminv(copula(:,1),expected_time(s),std_time(s)));
    depth = norminv(copula(:,2),expected_depth(s),std_depth(s));
    %[time depth]
    for i=1:N  
        chance = rand;
        probebility = p_d(s);        
        index = find(trendLog(:,1)==s-1 & trendLog(:,2)==i,1);
         if ~isempty(index) && trendLog(index,3)
             probebility = 1- probebility;
        end
        if chance<= probebility 
            r(i,:)= r(i,:).*crisis_business_activity_parametrized(s==1, time(i),time(i)+2,depth(i));
            trendLog((s-1)*N+i,:)=[s i true time(i) depth(i)*100];
        else
            if s==1
                r(i,:) = r(i,:).*stagnation_business_activity_parametrized(time(i),time(i)+2,depth(i));            
            end
            trendLog((s-1)*N+i,:)=[s i false time(i) depth(i)*100];
        end        
    end
end
%plot(r');
toc
end
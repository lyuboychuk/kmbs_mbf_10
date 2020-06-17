clear;
clc; format short;

N=10000; 
expected_depth =[.1 0.07 0.05]; std_depth =[.02 0.01 0.005];
p_d =[.75 .65 .55];
[r, trendLog] = stochastic_events_tree(p_d, expected_depth, std_depth, N);
%[r, trendLog] = portfolio_management(N);

crisis_behaviour = covid_quarantine_vacation;
normal_behaviour = InputData.ragular_vacation_pattern;
budgeted_track = cumprod(InputData.crisis_params(0,0)^(1/12)*ones(1,length(r(1,:))));
BenchMark = company_model_parametrized(budgeted_track, normal_behaviour);
salary_optimization = zeros(length(r(1,:)),1);

%index=9999; 
%trendLog(find(trendLog(:,2)==index),:)
intervals = zeros(N,2);
for index=1:N
    track = r(index,:);
    [EBITshare, revenue, Office_cost, SnA_cost, Bench_cost,engaged_salaries]...
        = company_model_parametrized(track, crisis_behaviour);
    [BenchCostOptCostGap, Bench_crisis_start, Bench_crisis_finish] = business_response_parametrized(...
        BenchMark,EBITshare, revenue, Office_cost,SnA_cost,Bench_cost);      
    
    salary_optimization(index) = sum(BenchCostOptCostGap)/sum(engaged_salaries(Bench_crisis_start:Bench_crisis_finish))*100;
    if isnan(salary_optimization(index))
        salary_optimization(index)=0;
    else
        intervals(index,:) = [Bench_crisis_start Bench_crisis_finish-Bench_crisis_start];    
    end
    
end

intervals_nozos = intervals(intervals(:,2)~=0,:);
positive_scenarios=1-length(intervals_nozos)/length(intervals)

average_crisis_start = mean(intervals_nozos(:,1))
std_crisis_start = std(intervals_nozos(:,1))

average_crisis_length = mean(intervals_nozos(:,2))
std_crisis_length = std(intervals_nozos(:,2))

p1=0.95;
salary_optimization_nozeros = salary_optimization(salary_optimization~=0);



mu=mean(salary_optimization);
sigma=std(salary_optimization);
mu_nozeros=mean(salary_optimization_nozeros)
sigma_nozeros=std(salary_optimization_nozeros)

[pHat,pCI] = lognfit(salary_optimization_nozeros);
[ks, xx]=ksdensity(salary_optimization);
imp_cdf = cumsum(ks)/sum(ks);
[ks_nozeros, xx_nozeros]=ksdensity(salary_optimization_nozeros);
imp_cdf = cumsum(ks_nozeros)/sum(ks_nozeros);



Optimization_95_norm=norminv(p1,mu,sigma);
Optimization_95_norm_nozores=norminv(p1,mu_nozeros,sigma_nozeros)
Optimization_95_logn=logninv(0.95,pHat(1),pHat(2))
Optimization_95_imp=xx(find(imp_cdf>=.95,1));
Optimization_95_imp_nozeros=xx_nozeros(find(imp_cdf>=.95,1))


figure; 
subplot(2,1,1)
hold on;
%plot(xx, ks);
plot(xx_nozeros, ks_nozeros);
plot(xx, lognpdf(xx,pHat(1),pHat(2)));
%plot(xx,normpdf(xx,mu,sigma));
%plot(xx,normpdf(xx,mu_nozeros,sigma_nozeros));
%legend('ks density','ks density zo zeros','lognormal', 'normal', 'normal no zeros');
legend('kernal density','lognormal');
title('Salary Optimization destribution');
xlabel('% salary reduction');
ylabel('density');
hold off;

% figure; 

subplot(2,1,2)
hold on;
plot(salary_optimization, 1:N,'x')
ylabel('scenarios');
xlabel('salary reduction');
title('Salary optimization,%');
hold off;

%figure;plot(ksdensity(salary_optimization));
%fprintf('Salary optimization %.2f%%\n', salary_optimization)

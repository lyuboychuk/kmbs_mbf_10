clc; format bank;

N=10000; 
expected_depth =[.1 0.07 0.05]; std_depth =[.02 0.01 0.005];
p_d =[.75 .65 .55];
[r, trendLog] = stochastic_events_tree(p_d,expected_depth, std_depth, N);

% N=10000; 
% expected_depth =[.1 0.07 0.05]; std_depth =[.02 0.01 0.005];
% [r, trendLog] = portfolio_management(N);

track = mean(r,1);

crisis_behaviour = covid_quarantine_vacation;
normal_behaviour = InputData.ragular_vacation_pattern;
budgeted_track = cumprod(InputData.crisis_params(0,0)^(1/12)*ones(1,length(track)));
BenchMark = company_model_parametrized(budgeted_track, normal_behaviour);

index=4; 
trendLog(find(trendLog(:,2)==index),:);
%track = r(index,:);

[EBITshare, revenue, Office_cost, SnA_cost, Bench_cost,engaged_salaries]...
        = company_model_parametrized(track, crisis_behaviour);

CostGap = subplus((BenchMark-EBITshare).*revenue);
PositiveCovidEffectAdj = sum(subplus((EBITshare-BenchMark).*revenue))/sum(CostGap);
CostGap = (1-PositiveCovidEffectAdj)*CostGap;

WithOfficeCostOptCostGap = OfficeCostOptimization(CostGap,Office_cost);
AdminCostOptCostGap = AdminCostOptimization(WithOfficeCostOptCostGap,SnA_cost);
[BenchCostOptCostGap, Bench_crisis_start, Bench_crisis_finish] = BenchCostOptimization(AdminCostOptCostGap,Bench_cost);

salary_optimization = sum(BenchCostOptCostGap)/sum(engaged_salaries(Bench_crisis_start:Bench_crisis_finish))*100;

fprintf('Salary optimization %.2f%%\n', salary_optimization)
opengl software
figure; hold on;
plot(CostGap);
plot(WithOfficeCostOptCostGap);
plot(AdminCostOptCostGap);
plot(BenchCostOptCostGap);
legend('Cost gap', ' -after Office Optimization', ' -after Admin Optimization', ' -after Bench Optimization');
ylabel('$'); xlabel('Time, months')
hold off;

function NewCostGap = OfficeCostOptimization(CostGap,Office_cost)
    %smooting of discount is missing
    %discount_cap = 0.3;     
    discount_cap = InputData.OfficeOptRatio;     
    NewCostGap = subplus(CostGap-Office_cost*discount_cap);    
end


function NewCostGap = AdminCostOptimization(CostGap,Admin_cost)
    %smooting of discount is missing
    %discount_cap = 0.25;
    discount_cap = InputData.AdminOptRatio;
    NewCostGap = subplus(CostGap-Admin_cost*discount_cap);            
end

function [NewCostGap, Bench_crisis_start, Bench_crisis_finish] = ...
    BenchCostOptimization(CostGap,Bench_cost)    

    [~,~,~,Average_salary] = InputData.company_params;
    %Bench_salary_optimization = 0.15;
    %Bench_count_optimization = 0.25;
    [Bench_salary_optimization, Bench_count_optimization] =InputData.BenchOptRatio;
    
    Bench_count = Bench_cost/Average_salary;
    
    New_Bench_count = Bench_count*(1-Bench_count_optimization);
    New_Bench_salary = Average_salary*(1-Bench_salary_optimization);    
    Bench_Optimization = Bench_cost - New_Bench_count*New_Bench_salary;    
    
    NewCostGap = subplus(CostGap-Bench_Optimization);
    Bench_crisis_start=find(NewCostGap~=0,1,'first');
    Bench_crisis_finish=find(NewCostGap~=0,1,'last');
end
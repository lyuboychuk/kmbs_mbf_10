    function [mEBIT, revenue,Office_cost, SnA_cost, bench_salaries,engaged_salaries]=...
        company_model_parametrized(track, behaviour)
    
    %Budgeted_growth = 0.2; 
    Budgeted_growth = InputData.crisis_params(0,0)-1;
    
%     Average_salary = 3170;
%     Bench_production_and_presale=0.04;   
%     Annual_retention = 0.08; 
%     Workplace_cost =100;
%     Office_space_per_person = 7;
%     office_rent_per_sqm = 25;
%     Admin_headcount_ratio = 3/20;
%     SnA_ratio_to_direct_cost= 0.0551;
    
    [Initial_engaged_production_headcount, ...
    Working_days_per_month, ...
    blended_rate_hour,...
    Average_salary,...
    Bench_production_and_presale,...
    Annual_retention,...
    Workplace_cost,...
    Office_space_per_person,...
    office_rent_per_sqm,...
    Admin_headcount_ratio,...
    SnA_ratio_to_direct_cost] = InputData.company_params;

    Monthly_budgeted_growth = (1+Budgeted_growth)^(1/12)-1;
    Monthly_retention_budgeted = (1+Annual_retention)^(1/12)-1;
    Monthly_growth = diff([1 track])./[1 track(1:end-1)];

    engaged_headcount = Initial_engaged_production_headcount*track;
    diff_engaged_headcount = diff([Initial_engaged_production_headcount engaged_headcount]);

    Monthly_retention = subplus(Monthly_growth)*Monthly_retention_budgeted/Monthly_budgeted_growth;
    retention_headcount = engaged_headcount.*(Monthly_retention);

    %%%%%%%%Excessive Personal Behaviour%%%%%%%%%%%%%%%%
    decline_personnel = subplus(-diff_engaged_headcount);
    %This is adjusting retention on the excessive personnel during the decline
    decline_personnel_adj = subplus(decline_personnel -retention_headcount); %net decline
    cum_decline_personnel_adj = cumsum(decline_personnel_adj);               %accumulated net decline   
    %This is adjusting retention on the excessive personal after the decline is finished
    retention_adj_factor=~sign(decline_personnel_adj).*sign(cum_decline_personnel_adj).*retention_headcount;
    layoffs=subplus(cum_decline_personnel_adj-cumsum(retention_adj_factor));
    %This is adjusting growth on the excessive personal after the decline is finished
    growth_adj_factor = subplus(diff_engaged_headcount).*sign(layoffs);
    layoffs_growth_adj = subplus(layoffs-growth_adj_factor);
    bench = engaged_headcount.*Bench_production_and_presale+layoffs_growth_adj;
    all_prod = engaged_headcount+bench;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %discounted_rate = blended_rate_hour.*compaund(rate_discount);
    discounted_rate = 1;
    revenue_per_billable_FTE =(1-behaviour)*Working_days_per_month*8*blended_rate_hour*discounted_rate;
    revenue = engaged_headcount.*revenue_per_billable_FTE;  

    bench_salaries = bench.*Average_salary;
    engaged_salaries = engaged_headcount.*Average_salary;
    prod_salaries =bench_salaries + engaged_salaries; %all_prod.*Average_salary;

    total_workspace_cost = all_prod*Workplace_cost;
    Direct_cost = prod_salaries+total_workspace_cost;

    Office_cost = Office_space_per_person.*office_rent_per_sqm.* ...
            all_prod.*(1+Admin_headcount_ratio);

    SnA_cost= zeros(1,length(Direct_cost));
    SnA_cost(1) = SnA_ratio_to_direct_cost*Direct_cost(1);
    for i=2:length(Direct_cost)
        suggested_SnA = Direct_cost(i)*SnA_ratio_to_direct_cost;
        if SnA_cost(i-1)>suggested_SnA
            SnA_cost(i)=SnA_cost(i-1);
        else
            SnA_cost(i)=suggested_SnA;
        end
    end

    Overhead = Office_cost+SnA_cost+total_workspace_cost+bench_salaries;
    %Overhead_per_bFTE = Overhead./engaged_headcount;
    %Overhead_per_bFTEshare = Overhead_per_bFTE./revenue_per_billable_FTE;
    EBIT = revenue-Overhead-engaged_salaries;    
    mEBIT = EBIT./revenue;
end
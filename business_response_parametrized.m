function  [BenchCostOptCostGap, Bench_crisis_start, Bench_crisis_finish] = business_response_parametrized(...
        BenchMark,...
        EBITshare,...
        revenue,...
        Office_cost,...
        SnA_cost,...
        Bench_cost)

    CostGap = subplus((BenchMark-EBITshare).*revenue);
    PositiveCovidEffectAdj = sum(subplus((EBITshare-BenchMark).*revenue))/sum(CostGap);
    CostGap = (1-PositiveCovidEffectAdj)*CostGap;

    WithOfficeCostOptCostGap = OfficeCostOptimization(CostGap,Office_cost);
    AdminCostOptCostGap = AdminCostOptimization(WithOfficeCostOptCostGap,SnA_cost);
    [BenchCostOptCostGap, Bench_crisis_start, Bench_crisis_finish] = BenchCostOptimization(AdminCostOptCostGap,Bench_cost);
    
    

    
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
end
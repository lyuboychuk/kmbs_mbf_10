%%%%%%%%%%%%%%
%%% 1. L-shape ravenue 
%%% 2. U-shape ravenue with mandatory vacation 
%%% 3. Stagnated growth
%%% 4. Disount on rate V-shape with stagnated growth
%%%%%%%%%%%%%%
classdef RevenueScenarios
    methods(Static)
        function [revenue, engage_personnel, vacation]=scenario(index, RevenueStreamsDistribution, display)
            [InitialEngagedPersonal, AveDaysMonth, AveRate] = InputData.company_params;            
            if index==1
                [revenue, engage_personnel, vacation]=scenario1;
            elseif index == 2
                [revenue, engage_personnel, vacation]=scenario2;
            elseif index==3
                [revenue, engage_personnel, vacation]=scenario3;
            elseif index==4
                [revenue, engage_personnel, vacation]=scenario4;
            end
            
            function [revenue, engage_personnel, vacation]=scenario1
                revenue = crisis_business_activity.*(1-covid_quarantine_vacation)...
                    *InitialEngagedPersonal*AveDaysMonth*8*AveRate*RevenueStreamsDistribution(1);
                engage_personnel = crisis_business_activity*InitialEngagedPersonal*RevenueStreamsDistribution(1);
                vacation=covid_quarantine_vacation;
                if display
                    figure; hold on; plot(revenue); 
                    plot(crisis_business_activity*InitialEngagedPersonal*AveDaysMonth*8*AveRate*RevenueStreamsDistribution(1));
                    plot((1-covid_quarantine_vacation)*InitialEngagedPersonal*AveDaysMonth*8*AveRate*RevenueStreamsDistribution(1));
                    title('L-shape ravenue'); hold off;
                end                
            end
            function [revenue, engage_personnel, vacation]=scenario2
                [crisis_line, new_vacation_pattern]=crisis_business_vacation;
                revenue = crisis_line.*(1-new_vacation_pattern)...
                    *InitialEngagedPersonal*AveDaysMonth*8*AveRate*RevenueStreamsDistribution(2);   
                engage_personnel=stagnation_business_activity*InitialEngagedPersonal*RevenueStreamsDistribution(2);
                vacation = new_vacation_pattern;
                if display
                    figure; hold on; plot(revenue); 
                    plot(crisis_line*InitialEngagedPersonal*AveDaysMonth*8*AveRate*RevenueStreamsDistribution(2));
                    plot(engage_personnel*AveDaysMonth*8*AveRate);
                    plot((1-new_vacation_pattern)*InitialEngagedPersonal*AveDaysMonth*8*AveRate*RevenueStreamsDistribution(2));
                    title('U-shape ravenue with mandatory vacation'); hold off;
                end
            end
            function [revenue, engage_personnel, vacation]=scenario3
                revenue = stagnation_business_activity.*(1-covid_quarantine_vacation)...
                    *InitialEngagedPersonal*AveDaysMonth*8*AveRate*RevenueStreamsDistribution(3);   
                engage_personnel=stagnation_business_activity*InitialEngagedPersonal*RevenueStreamsDistribution(3);
                vacation=covid_quarantine_vacation;
                if display                
                    figure; hold on; plot(revenue);
                    plot(stagnation_business_activity*InitialEngagedPersonal*AveDaysMonth*8*AveRate*RevenueStreamsDistribution(3));
                    plot((1-covid_quarantine_vacation)*InitialEngagedPersonal*AveDaysMonth*8*AveRate*RevenueStreamsDistribution(3));
                    title('Stagnated growth'); hold off;
                end
            end
            function [revenue, engage_personnel, vacation]=scenario4
                revenue = stagnation_business_activity.*(1-covid_quarantine_vacation)...
                    .*crisis_business_discounted...
                    *InitialEngagedPersonal*AveDaysMonth*8*AveRate*RevenueStreamsDistribution(4);  
                engage_personnel=stagnation_business_activity*InitialEngagedPersonal*RevenueStreamsDistribution(4);
                vacation=covid_quarantine_vacation;
                if display
                    figure; hold on; plot(revenue); 
                    plot(stagnation_business_activity*InitialEngagedPersonal*AveDaysMonth*8*AveRate*RevenueStreamsDistribution(4));
                    plot((1-covid_quarantine_vacation)*InitialEngagedPersonal*AveDaysMonth*8*AveRate*RevenueStreamsDistribution(4));
                    plot(crisis_business_discounted*InitialEngagedPersonal*AveDaysMonth*8*AveRate*RevenueStreamsDistribution(4));
                    title('Disount on rate V-shape with stagnated growth'); hold off;
                end

            end
        end
    end
end
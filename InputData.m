classdef InputData
    methods(Static)
               
        function [i_annual_rate,crisis_start,bottom_reached,crisis_end,bottom_depth_delta,recovery_rate]= ...
                crisis_params(bottom_reached,bottom_depth_delta)            
            i_annual_rate = 1.2; crisis_start=3; crisis_end=36;
            recovery_rate=(1-bottom_depth_delta)^(-1/(crisis_end-bottom_reached));
        end

        function [back_to_office, vacation_spread_factor, quarantine_vacation_behaviour] = quarantine_behavior
            [~,crisis_start]= InputData.crisis_params(10,0.1);
            back_to_office=crisis_start+3;
            vacation_spread_factor=9;
            quarantine_vacation_behaviour = 0.1;
        end

        function business_vacation_factor = clinet_mitigation
            business_vacation_factor=0.15;
            %recovery_factor= 0.25;            
        end
                
        function vacation = ragular_vacation_pattern
            [~,~,~,crisis_end]= InputData.crisis_params(10,0.1);
            v1 = [0.1053 0.0553 0.0553 0.0853 0.1053 0.1053 0.1153 0.1053 0.0553 0.0553 0.0553 0.1053];            
            v1 = repmat(v1,1,ceil(crisis_end/length(v1)));
            vacation=v1(1:crisis_end);
        end
        function [InitialEngagedPersonal, ...
                AveDaysMonth, ...
                AveRate,...
                Average_salary,...
                Bench_production_and_presale,...
                Annual_retention,...
                Workplace_cost,...
                Office_space_per_person,...
                office_rent_per_sqm,...
                Admin_headcount_ratio,...
                SnA_ratio_to_direct_cost] = company_params
            InitialEngagedPersonal=1000;
            AveDaysMonth = 20.9166666666666;
            AveRate = 29.3;      
            
            Average_salary = 3170;
            Bench_production_and_presale=0.04;   
            Annual_retention = 0.08; 
            Workplace_cost =100;
            Office_space_per_person = 7;
            office_rent_per_sqm = 25;
            Admin_headcount_ratio = 3/20;
            SnA_ratio_to_direct_cost= 0.0551;
        end
        
        function r =OfficeOptRatio
            r= 0.3;
        end
        function r =AdminOptRatio
            r= 0.25;
        end
        function [salary_r, count_r] =BenchOptRatio
            salary_r = 0.15;
            count_r = 0.25;
        end
        
    end
end
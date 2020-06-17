function [crisis_line, new_vacation_pattern] = crisis_business_vacation
    year_factor=12;
    business_vacation_factor = InputData.clinet_mitigation;
    [i_annual_rate,crisis_start,bottom_reached,crisis_end,~,recovery_rate]= InputData.crisis_params(10,0.1);

    budgeted_line = cumprod(i_annual_rate^(1/12)*ones(1,year_factor));
    before_decline_line = budgeted_line(1:crisis_start);
    business_vacation_line =(1-business_vacation_factor)*ones(1, bottom_reached-crisis_start);   
    recovery_line = cumprod(recovery_rate*ones(1,crisis_end-bottom_reached))...
        *before_decline_line(end);

    crisis_line = [before_decline_line business_vacation_line recovery_line];
    %%%%%%%%%%%%%%%%%%%%%%%vacation management%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    vacation = InputData.ragular_vacation_pattern;
    [~, vacation_spread_factor] = InputData.quarantine_behavior;
    
    new_vacation_pattern = vacation;
    
    new_vacation_pattern(crisis_start+1:bottom_reached)=business_vacation_factor;
    vacation_gap = sum(vacation-new_vacation_pattern);
    
    p = vacation_gap...
        /sum(new_vacation_pattern(bottom_reached+1:bottom_reached+vacation_spread_factor));
    new_vacation_pattern(bottom_reached+1:bottom_reached+vacation_spread_factor) =...
        new_vacation_pattern(bottom_reached+1:bottom_reached+vacation_spread_factor)*(p+1);
    
    new_vacation_pattern(bottom_reached+1:bottom_reached+2*vacation_spread_factor)=movmean(...
        new_vacation_pattern(bottom_reached+1:bottom_reached+2*vacation_spread_factor),....
        vacation_spread_factor/3);
   end 

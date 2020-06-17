function stagnation_line= stagnation_business_activity_parametrized(crisis_start, bottom_reached,bottom_depth_delta)
year_factor=12;
[i_annual_rate,~,~,crisis_end,~,recovery_rate]= InputData.crisis_params(bottom_reached,bottom_depth_delta);

budgeted_line = cumprod(i_annual_rate^(1/12)*ones(1,year_factor));
before_decline_line = budgeted_line(1:crisis_start);
stagnation_line = before_decline_line(end)*ones(1,bottom_reached-crisis_start);

recovery_line = cumprod(recovery_rate...
        *ones(1,crisis_end-bottom_reached))...
        *before_decline_line(end);
    
 stagnation_line = [before_decline_line stagnation_line recovery_line];
end
 
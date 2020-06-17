% function crisis_line=crisis_business_activity
%     [i_annual_rate,crisis_start,bottom_reached,crisis_end,bottom_depth_delta,recovery_rate]= InputData.crisis_params;
%     year_factor=12;
% 
%     budgeted_line = cumprod(i_annual_rate^(1/12)*ones(1,year_factor));
%     before_decline_line = budgeted_line(1:crisis_start);
% 
%     decline_line = cumprod((1-bottom_depth_delta)^(1/(bottom_reached-crisis_start))...
%                     *ones(1,(bottom_reached-crisis_start)))...
%                     *before_decline_line(end);
% 
%     recovery_line = cumprod(recovery_rate...
%                      *ones(1,(crisis_end-bottom_reached)))...
%                      *decline_line(end);
%                  
%     crisis_line = [before_decline_line decline_line recovery_line];
% end

function crisis_line=crisis_business_activity
    [~,crisis_start,bottom_reached,~,bottom_depth_delta,~]= InputData.crisis_params(10,0.1);
    crisis_line=crisis_business_activity_parametrized(true, crisis_start, bottom_reached,bottom_depth_delta);
end
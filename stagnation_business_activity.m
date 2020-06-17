% function stagnation_line= stagnation_business_activity
% year_factor=12;
% [i_annual_rate,crisis_start,bottom_reached,crisis_end,~,recovery_rate]= InputData.crisis_params(10,0.1);
% %[~,recovery_factor] = InputData.clinet_mitigation;
% 
% budgeted_line = cumprod(i_annual_rate^(1/12)*ones(1,year_factor));
% before_decline_line = budgeted_line(1:crisis_start);
% stagnation_line = before_decline_line(end)*ones(1,bottom_reached-crisis_start);
% 
% recovery_line = cumprod(recovery_rate...
%         *ones(1,crisis_end-bottom_reached))...
%         *before_decline_line(end);
%     
%  stagnation_line = [before_decline_line stagnation_line recovery_line];
% end
%  

function stagnation_line= stagnation_business_activity
    stagnation_line = stagnation_business_activity_parametrized(3,10,0.1);
end

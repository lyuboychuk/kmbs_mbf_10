function new_vacation_pattern = covid_quarantine_vacation
    [~,crisis_start]= InputData.crisis_params(0,0);
    [back_to_office, vacation_spread_factor, quarantine_vacation_behaviour] = InputData.quarantine_behavior;
    
    vacation = InputData.ragular_vacation_pattern;

    new_vacation_pattern=vacation;
    new_vacation_pattern(crisis_start+1:back_to_office)=...
        new_vacation_pattern(crisis_start+1:back_to_office)...
        *quarantine_vacation_behaviour;
    vacation_gap = sum(vacation-new_vacation_pattern);
    p = vacation_gap...
        /sum(new_vacation_pattern(back_to_office+1:back_to_office+vacation_spread_factor));
    new_vacation_pattern(back_to_office+1:back_to_office+vacation_spread_factor) =...
        new_vacation_pattern(back_to_office+1:back_to_office+vacation_spread_factor)*(p+1);

    new_vacation_pattern(back_to_office+1:back_to_office+2*vacation_spread_factor)=movmean(...
        new_vacation_pattern(back_to_office+1:back_to_office+2*vacation_spread_factor),....
        vacation_spread_factor/3);
end 


function discount_line = crisis_business_discounted
    max_dicount_bottom=0.1;
    reverting_velocity_factor =3;
    [~,crisis_start,bottom_reached,crisis_end]= InputData.crisis_params(10,0.1);    

    decline_line = cumprod((1-max_dicount_bottom)^(1/(bottom_reached-crisis_start))...
        *ones(1,bottom_reached-crisis_start));
    
    total_recovery_rate = 1/decline_line(end);
    recovery_period = round((bottom_reached-crisis_start)/reverting_velocity_factor);
    recovery_line = cumprod(total_recovery_rate^(1/(recovery_period))...
        *ones(1,(recovery_period)))*decline_line(end);

    discount_line = [ones(1,crisis_start) decline_line recovery_line ones(1,crisis_end-bottom_reached-recovery_period)];
end




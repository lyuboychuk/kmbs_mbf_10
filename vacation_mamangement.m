clear;clc;

vacation = InputData.ragular_vacation_pattern;

figure; hold on;
 plot(vacation); 
 plot(covid_quarantine_vacation); 
 bar(covid_quarantine_vacation-vacation);
 legend('Historical pattern', 'Covid effect pattern', 'Diff');
 title('Vacational behavior forecast');
 xlabel('Month'); ylabel('vacation share');
hold off;

figure; hold on;
[~, mandatory_vacation] = crisis_business_vacation;
 plot(vacation); 
 plot(mandatory_vacation); 
 bar(mandatory_vacation-vacation);
hold off;
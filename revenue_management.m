clc; clear; format bank;

RevenueStreamsDistribution = [0.45 0.20 0.25 0.10];

figure; bar(RevenueStreamsDistribution);

display=true; 
[~,~,~,crisis_end,~,~]= InputData.crisis_params(10,0.1);


company_devesification = length(RevenueStreamsDistribution);
revenue=zeros(crisis_end,company_devesification);
engage_personnel=zeros(crisis_end,company_devesification);
vacation=zeros(crisis_end,company_devesification);

for i=1:company_devesification
    [revenue(:,i),engage_personnel(:,i),vacation(:,i)] =RevenueScenarios.scenario(i,RevenueStreamsDistribution,display);
end

total_revenue = sum(revenue');
total_engage_personnel = sum(engage_personnel');
total_vacation = sum(engage_personnel'.*vacation')./sum(engage_personnel');

figure; hold on; plot(total_revenue); plot(revenue,'--'); title('revenue'); hold off;
figure; hold on; plot(total_engage_personnel); plot(engage_personnel,'--'); title('engage personnel'); hold off;
figure; hold on; plot(total_vacation); plot(vacation,'--'); title('vacation'); hold off;
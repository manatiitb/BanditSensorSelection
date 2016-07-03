%function SAP (p,p1,p2,c)
clc;
clear all;
settings=[];
settings.p=.5;                             % input label distribution, probability of 0
settings.p1=.2;                            % error prob of sensor 1
settings.p2=.1;                            % error prob of sensor 2
settings.T=100000;                           % number of rounds
settings.iterations=30;


stylem = {'-^','-v','-o','-*','-d','-s','-.','--x','--o','--v','--^','--'};
colorm = [0 0 0;0 0 1;0 1 0;1 0 0;0.1*[1 1 1];0.6*[1 1 1];0 0 0;0 0 0;0 0 0;0 0 0;0.1 0.9 0.1;0.8 .9 0.8];

ind=1:0.05*settings.T:settings.T;
figure;
hold on;
m=0;
leg = {};
for c=0.05:0.05:.35
    m=m+1;
    settings.c=c;
    Regs=UCBbsc(settings);
    Reg=mean(Regs,2);
    ConfBound=1.96*std(Regs,1,2)/sqrt(settings.iterations);
    errorbar(ind, Regs(ind), ConfBound(ind), stylem{m},'Color',colorm(m,:),'LineWidth',2,'MarkerFaceColor','auto','MarkerSize',6)
    leg{m} = sprintf('c=%4.3f', c);
end

legend(leg,'fontsize',12,'Location','NorthWest');
legend('boxoff')
xlabel('time T','fontsize',12);
ylabel('cumulative regret','fontsize',12);
title('BSC','fontsize',12);





    
    
    
    
    



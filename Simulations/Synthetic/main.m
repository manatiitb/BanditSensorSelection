%function SAP (p,p1,p2,c)
clc;
clear all;
settings=[];
settings.p=.5;                             % input label distribution, probability of 0
settings.p1=.2;                            % error prob of sensor 1
settings.p2=.1;                            % error prob of sensor 2
settings.c=.42;
settings.T=10000;                           % number of rounds
settings.iterations=20;

% [missp, condp]=errorstat(settings);
% 
% stylem = {'-^','-v','-o','-*','-d','-s','-.','--x','--o','--v','--^','--'};
% colorm = [0 0 0;0 0 1;0 1 0;1 0 0;0.1*[1 1 1];0.6*[1 1 1];0 0 0;0 0 0;0 0 0;0 0 0;0.1 0.9 0.1;0.8 .9 0.8];
% 
% 
% figure;
% m=0;
% leg = {};
% for c=.06: .06:.4
%     m=m+1;
%     settings.c=c;
%     Regs=UCB(settings);
%     plot(1:0.05*settings.T:settings.T, Regs(1:0.05*settings.T:settings.T), stylem{m},'Color',colorm(m,:),'LineWidth',2,'MarkerFaceColor','auto','MarkerSize',8)
%     leg{m} = sprintf('c=%.1d', c);
% end

% legend(leg,'fontsize',12,'Location','NorthWest');
% legend('boxoff')
% xlabel('time T','fontsize',12);
% ylabel('cumulative regret','fontsize',12);
% title('BSC','fontsize',12);


cost=0.05:0.05:1;

R=zeros(size(cost,2),1);
i=0;
for c=0.05:0.05:1
    i=i+1;
    settings.c=c;
    Regs=UCB(settings);
    R(i)=Regs(settings.T)/settings.T;
end
    
plot(cost, R, '--*','LineWidth',2,'MarkerFaceColor','auto','MarkerSize',8)

%legend(leg,'fontsize',12,'Location','NorthWest');
legend('boxoff')
xlabel('cost c','fontsize',12);
ylabel('regret/round','fontsize',12);
title('BSC','fontsize',12);


    
    
    
    
    



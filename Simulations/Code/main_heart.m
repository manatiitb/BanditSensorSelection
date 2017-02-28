clear all;
clc;
global settings;
settings=[];

settings.K=3;                           %number of arms
settings.p=zeros(settings.K,1);         %stores error probabilities of each sesor
settings.c=zeros(settings.K,1);         %stores cost of each arm (cumulative)
settings.data=[];                       %stores data
settings.T=10000;                       %number of rounds
settings.iterations=10; 
settings.FeaLen=[7 11 13];   %stores feature lenghts to train each classifier (sensor) 

C=[32 397 601]';  % cost of the features

settings.fid=fopen('errorstat.txt','w+');


method=3;
method_name{1} = 'BSC';
method_name{2} = 'Diabetes';
method_name{3} = 'Heart';

stylem = {'-^','-d','-x','-*','-.','.o','.','--x','--o','--v','--^','--'};
colorm = [0 0 0;0 0 1;0 1 0;1 0 0;0.1*[1 1 1];0.6*[1 1 1];0 0 0;0 0 0;0 0 0;0 0 0;0.1 0.9 0.1;0.8 .9 0.8];



%Reward=zeros(length(Cost),numel(method_name));
Conf = zeros(length(settings.c),numel(method_name));



%%%diabetes dataset
Heart_data;

ind=1:0.1*settings.T:settings.T;
hold on;
m=0;
L=0.0001:0.0009:0.001;
Reward=zeros(size(L,2),1);
leg = {};
for l=L
    m=m+1;
    settings.c=l*C;
    Regs=UCBDiabetes_WD(settings);
    RegPerRound=Regs(settings.T,:)/settings.T;
    Reward(m,1)=mean(RegPerRound,2);
    Reg=mean(Regs,2);
    ConfBound=1.96*std(Regs,1,2)/sqrt(settings.iterations);
    errorbar(ind, Reg(ind), ConfBound(ind), stylem{m},'Color',colorm(m,:),'LineWidth',2,'MarkerFaceColor','auto','MarkerSize',6)
    leg{m} = sprintf('unsupervised, l=%4.3f', l);
    fprintf('.......\nFor Diabetes %d/%d completed\n', m, size(L,2));
end

settings.e=0;
Reward=zeros(size(L,2),1);
leg = {};
for l=L
    m=m+1;
    settings.c=l*C;
    Regs=UCBDiabetes_Std(settings);
    RegPerRound=Regs(settings.T,:)/settings.T;
    Reward(m,1)=mean(RegPerRound,2);
    Reg=mean(Regs,2);
    ConfBound=1.96*std(Regs,1,2)/sqrt(settings.iterations);
    errorbar(ind, Reg(ind), ConfBound(ind), stylem{m},'Color',colorm(m,:),'LineWidth',2,'MarkerFaceColor','auto','MarkerSize',6)
    leg{m} = sprintf('supervised, l=%4.3f', l);
    fprintf('.......\nFor Diabetes %d/%d completed\n', m, size(L,2));
end



xlabel('time T','fontsize',12);
ylabel('cumulative regret','fontsize',12);
title('Diabetes','fontsize',12);
legend(leg,'fontsize',12,'Location','NorthWest');
legend('boxoff')

% settings.e=.3;
% Reward=zeros(size(L,2),1);
% leg = {};
% for l=L
%     m=m+1;
%     settings.c=l*C;
%     Regs=UCBDiabetes_Std(settings);
%     RegPerRound=Regs(settings.T,:)/settings.T;
%     Reward(m,1)=mean(RegPerRound,2);
%     Reg=mean(Regs,2);
%     ConfBound=1.96*std(Regs,1,2)/sqrt(settings.iterations);
%     errorbar(ind, Reg(ind), ConfBound(ind), stylem{m},'Color',colorm(m,:),'LineWidth',2,'MarkerFaceColor','auto','MarkerSize',6)
%     leg{m} = sprintf('l=%4.3f', l);
%     fprintf('.......\nFor Diabetes %d/%d completed\n', m, size(L,2));
% end



% 
% ind=1:length(Cost);
% hold on;
% for m=method
%     errorbar(Cost, Reward(ind,m), Conf(ind,m), stylem{m},'Color',colorm(m,:),'LineWidth',2,'MarkerFaceColor','auto','MarkerSize',6);
% end
% 
% legend(leg,'fontsize',12,'Location','NorthWest');
% legend('boxoff')
% xlabel('cost c','fontsize',12);
% ylabel('regret per round','fontsize',12);
% %title('BSC','fontsize',12);
% fclose(settings.fid);
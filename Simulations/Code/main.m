global settings;
settings=[];

settings.p=0;
settings.p1=0;                            % error prob of sensor 1
settings.p2=0;                            % error prob of sensor 2
settings.svmStruct1=[];
settings.svmStruct2=[];
settings.data=[];
settings.T=100000;                           % number of rounds
settings.iterations=10;

settings.fid=fopen('errorstat.txt','w+');

method=[1 2 3];
method_name{1} = 'BSC';
method_name{2} = 'Diabetes';
method_name{3} = 'Heart';


Cost=0:0.05:.6;
Reward=zeros(length(Cost),numel(method_name));
Conf = zeros(length(Cost),numel(method_name));


% Sythetic
main_BSC;

m=0;   

for c=Cost
    m=m+1;
    settings.c=c;
    Regs=UCBbsc(settings);
    Regs=Regs(settings.T,:)/settings.T;
    Reward(m,1)=mean(Regs,2);
    Conf(m,1)=1.96*std(Regs,1,2)/sqrt(settings.iterations);   
    fprintf(1,'==========%s-[%d/%d]\n',method_name{1}, m, length(Cost));
end

leg{1} = 'BSC';

%diabetes dataset
main_diabetes;
m=0;   
for c=Cost
    m=m+1;
    settings.c=c;
    Regs=UCBDiabetes(settings);
    Regs=Regs(settings.T,:)/settings.T;
    Reward(m,2)=mean(Regs,2);
    Conf(m,2)=1.96*std(Regs,1,2)/sqrt(settings.iterations);
    fprintf(1,'==========%s-[%d/%d]\n',method_name{2}, m, length(Cost));
end
leg{2} = 'Diabetes';

%heart dataset
main_heart;
m=0;   
for c=Cost
    m=m+1;
    settings.c=c;
    Regs=UCBheart(settings);
    Regs=Regs(settings.T,:)/settings.T;
    Reward(m,3)=mean(Regs,2);
    Conf(m,3)=1.96*std(Regs,1,2)/sqrt(settings.iterations);
    fprintf(1,'==========%s-[%d/%d]\n',method_name{3}, m, length(Cost));
end
leg{3} = 'heart';


stylem = {'-^','-v','-o','-*','-d','-s','-.','--x','--o','--v','--^','--'};
colorm = [0 0 0;0 0 1;0 1 0;1 0 0;0.1*[1 1 1];0.6*[1 1 1];0 0 0;0 0 0;0 0 0;0 0 0;0.1 0.9 0.1;0.8 .9 0.8];


ind=1:length(Cost);
hold on;
for m=method
    errorbar(Cost, Reward(ind,m), Conf(ind,m), stylem{m},'Color',colorm(m,:),'LineWidth',2,'MarkerFaceColor','auto','MarkerSize',6);
end

legend(leg,'fontsize',12,'Location','NorthWest');
legend('boxoff')
xlabel('cost c','fontsize',12);
ylabel('regret per round','fontsize',12);
%title('BSC','fontsize',12);
fclose(settings.fid);
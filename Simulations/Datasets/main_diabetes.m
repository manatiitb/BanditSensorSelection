global svmStruct1;
global svmStruct2;
global data;

data=load('diabetes.data.txt');
Meas = data((data(:,3) > 0),:);
Xmeas = Meas(:,1:8); Y = Meas(:,9);
P = cvpartition(Y,'Holdout',0.2);
svmStruct1 = svmtrain(Xmeas(P.training,:),Y(P.training),'kernel_function','linear','boxconstraint',.01);
Ccostly = svmclassify(svmStruct1,Xmeas(P.test,:));
errRate1 = sum(Y(P.test)~= Ccostly)/P.TestSize;

Xmeas = Meas(:,[1,3,4,6:8]);
svmStruct2 = svmtrain(Xmeas(P.training,:),Y(P.training),'kernel_function','linear','boxconstraint',.01);
Ccheap = svmclassify(svmStruct2,Xmeas(P.test,:));
errRate2 = sum(Y(P.test)~= Ccheap)/P.TestSize;

index = find(Y(P.test)== Ccheap);
errCond=sum(Ccheap(index)~=Ccostly(index))/size(index,1);
errMiss=sum(Ccheap~=Ccostly)/sum(P.test);

[errRate1 errRate2 errMiss errCond];

settings=[];
settings.p=.5;                             % input label distribution, probability of 0
settings.p1=errRate2;                            % error prob of sensor 1
settings.p2=errRate1;                            % error prob of sensor 2
settings.T=10000;                           % number of rounds
settings.iterations=20;

cost=0.05:0.05:1;

R=zeros(size(cost,2),1);
i=0;
for c=0.05:0.05:1
    i=i+1;
    settings.c=c;
    Regs=UCBDiabetes(settings);
    R(i)=Regs(settings.T)/settings.T;
end
    
plot(cost, R, '--*','LineWidth',2,'MarkerFaceColor','auto','MarkerSize',8)

%legend(leg,'fontsize',12,'Location','NorthWest');
legend('boxoff')
xlabel('cost c','fontsize',12);
ylabel('regret/round','fontsize',12);
title('BSC','fontsize',12);

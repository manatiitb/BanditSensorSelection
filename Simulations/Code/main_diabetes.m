%global settings;

data=load('diabetes.data.txt');
Meas = data((data(:,3) > 0),:);
Xmeas = Meas(:,1:8); Y = Meas(:,9);
P = cvpartition(Y,'Holdout',0.2);
%svmStruct2 = svmtrain(Xmeas(P.training,:),Y(P.training),'kernel_function','linear','boxconstraint',.01);
svmStruct2 = fitcsvm(Xmeas(P.training,:),Y(P.training),'KernelFunction','linear','BoxConstraint',.01);
Ccostly = predict(svmStruct2,Xmeas(P.test,:));
errRate2 = sum(Y(P.test)~= Ccostly)/P.TestSize;

Xmeas = Meas(:,[1,3,4,6:8]);
%svmStruct1 = svmtrain(Xmeas(P.training,:),Y(P.training),'kernel_function','linear','boxconstraint',.01); %#ok<SVMTRAIN>
svmStruct1 = fitcsvm(Xmeas(P.training,:),Y(P.training),'KernelFunction','linear','BoxConstraint',.01);
Ccheap =predict(svmStruct1,Xmeas(P.test,:));
errRate1 = sum(Y(P.test)~= Ccheap)/P.TestSize;

index = find(Y(P.test)== Ccheap);
errCond=sum(Ccheap(index)~=Ccostly(index))/size(index,1);
errDiff=sum(Ccheap~=Ccostly)/sum(P.test);
errJoint=sum(Ccheap(index)~=Ccostly(index))/P.TestSize;


settings.p1=errRate1;
settings.p2=errRate2;
settings.svmStruct1=svmStruct1;
settings.svmStruct2=svmStruct2;
settings.data=data;

stat=[errRate1 errRate2 errDiff errJoint errCond];

formatSpec = 'Statistic for Diab: is [%4.3f %4.3f %4.3f %4.3f %4.3f] \n';
fprintf(settings.fid, formatSpec, stat);

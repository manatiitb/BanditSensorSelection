data=load('heart.newdata.txt');
data(data(:,14)>0,14)=1;
Xmeas = data(:,[1:13]); Y = data(:,14);
P = cvpartition(Y,'Holdout',0.2);
svmStruct2 = fitcsvm(Xmeas(P.training,:),Y(P.training),'KernelFunction','linear','BoxConstraint',.01);
Ccostly = predict(svmStruct2,Xmeas(P.test,:));
errRate2 = sum(Y(P.test)~= Ccostly)/P.TestSize;

Xmeas = data(:,1:7); Y = data(:,14);
svmStruct1 = fitcsvm(Xmeas(P.training,:),Y(P.training),'KernelFunction','linear','BoxConstraint',.01);
Ccheap = predict(svmStruct1,Xmeas(P.test,:));
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

formatSpec = 'Statistic for Hear: is [%4.3f %4.3f %4.3f %4.3f %4.3f] \n';
fprintf(settings.fid, formatSpec, stat);
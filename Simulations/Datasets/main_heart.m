data=load('heart.newdata.txt');
data(data(:,14)>0,14)=1;
Xmeas = data(:,[1:13]); Y = data(:,14);
P = cvpartition(Y,'Holdout',0.2);
svmStruct1 = svmtrain(Xmeas(P.training,:),Y(P.training),'kernel_function','linear','boxconstraint',.01);
Ccostly = svmclassify(svmStruct1,Xmeas(P.test,:));
errRate1 = sum(Y(P.test)~= Ccostly)/P.TestSize;

Xmeas = data(:,1:7); Y = data(:,14);
svmStruct2 = svmtrain(Xmeas(P.training,:),Y(P.training),'kernel_function','linear','boxconstraint',.01);
Ccheap = svmclassify(svmStruct2,Xmeas(P.test,:));
errRate2 = sum(Y(P.test)~= Ccheap)/P.TestSize;

index = find(Y(P.test)== Ccheap);
errCond=sum(Ccheap(index)~=Ccostly(index))/size(index,1);
errMiss=sum(Ccheap~=Ccostly)/sum(P.test);

[errRate1 errRate2 errMiss errCond]

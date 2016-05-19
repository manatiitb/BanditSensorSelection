data=load('thyroid.data.txt');
data(data(:,22)<3,22)=1;
Xmeas = data(:,1:21); Y = data(:,22);
P = cvpartition(Y,'Holdout',0.1);
svmStruct1 = svmtrain(Xmeas(P.training,:),Y(P.training),'kernel_function','linear','boxconstraint',1);
Ccostly = svmclassify(svmStruct1,Xmeas(P.test,:));
errRate1 = sum(Y(P.test)~= Ccostly)/P.TestSize;

Xmeas = data(:,1:20); Y = data(:,22);
svmStruct2 = svmtrain(Xmeas(P.training,:),Y(P.training),'kernel_function','linear', 'boxconstraint',1);
Ccheap = svmclassify(svmStruct2,Xmeas(P.test,:));
errRate2 = sum(Y(P.test)~= Ccheap)/P.TestSize;

index = find(Y(P.test)== Ccheap);
errCond=sum(Ccheap(index)~=Ccostly(index))/size(index,1);

errMiss=sum(Ccheap~=Ccostly)/sum(P.test);

[errRate1 errRate2 errMiss errCond]


data=load('heart.newdata.txt');
data(data(:,14)>0,14)=1;
Y = data(:,14);
P = cvpartition(Y,'Holdout',0.2);

ErrRate=zeros(settings.K,1);                % stores error rate of each classifer/sensor
ErrDiff=zeros(settings.K, settings.K);      % stores probability of disagreement between pair of sensor
ErrJoint=zeros(settings.K, settings.K);     % for each pair, stores probability of cheap sensor is correct and constlier one incorrect
Labels=zeros(P.TestSize, settings.K);       % for each sensor stores the predicted outcomes on test \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\data
svm=cell(settings.K,1);
FeaLen=settings.FeaLen;


Xmeas = data(:,1:FeaLen(1));
svm{1} = fitcsvm(Xmeas(P.training,:),Y(P.training),'KernelFunction','linear','BoxConstraint',.01);
Labels(:,1) = predict(svm{1},Xmeas(P.test,:));
ErrRate(1) = sum(Y(P.test)~= Labels(:,1))/P.TestSize;        % Error on test data


for i=2:1:settings.K
    Xmeas = data(:,1:FeaLen(i));
    svm{i} = fitcsvm(Xmeas(P.training,:),Y(P.training),'KernelFunction','linear','BoxConstraint',.01);
    Labels(:,i) = predict(svm{i},Xmeas(P.test,:));               % get labels of the test data
    ErrRate(i) = sum(Y(P.test)~= Labels(:,i))/P.TestSize;        % Error on test data
    Ccostly=Labels(:,i);
    for j=1:1:i-1
        Ccheap=Labels(:,j);                                   % get labels of the sensors obtained with fewer features
        index = find(Y(P.test)== Ccheap);                     % Index of all the test points correctly predicted by cheap sensor
        ErrDiff(i,j)=sum(Ccheap~=Ccostly)/sum(P.test);             % Number of disgreements of sensors on test data
        ErrJoint(i,j)=sum(Ccheap(index)~=Ccostly(index))/P.TestSize; % probability that cheap sensor is correct and costly one is incorrect
    end
end

settings.svm=svm;
settings.p=ErrRate;
settings.data=data;
% Xmeas = data(:,1:7); Y = data(:,14);
% svmStruct1 = fitcsvm(Xmeas(P.training,:),Y(P.training),'KernelFunction','linear','BoxConstraint',.01);
% Ccheap = predict(svmStruct1,Xmeas(P.test,:));
% errRate1 = sum(Y(P.test)~= Ccheap)/P.TestSize;        % Error on test data
% 
% index = find(Y(P.test)== Ccheap);                     % Index of all the test points correctly predicted by cheap sensor
% errCond=sum(Ccheap(index)~=Ccostly(index))/size(index,1); % Probability that costly sensor makes error given that cheap sensor is correct
% errDiff=sum(Ccheap~=Ccostly)/sum(P.test);             % Number of disgreements of sensors on test data
% errJoint=sum(Ccheap(index)~=Ccostly(index))/P.TestSize; % probability that cheap sensor is correct and costly one is incorrect
% 
% settings.p1=errRate1;
% settings.p2=errRate2;
% settings.svmStruct1=svmStruct1;
% settings.svmStruct2=svmStruct2;
% 
% 
% settings.data=data;
% 
% stat=[errRate1 errRate2 errDiff errJoint errCond];

fprintf(settings.fid, 'Statistics for Heart dataset\n\n');
fprintf(settings.fid, '1. Error rate of each classifier\n');
fprintf(settings.fid, '\n2. probability that cheap sensor is correct and costly one is incorrect (for each pair):\n');
fprintf(settings.fid, '\n3. probability that cheap and costly sensors disagree (for each pair):\n');
dlmwrite('errorstat.txt',ErrRate,'-append', 'roffset',1, 'precision','%4.3f');
dlmwrite('errorstat.txt',ErrJoint,'-append', 'roffset',1, 'precision','%4.3f');
dlmwrite('errorstat.txt',ErrDiff, '-append', 'roffset',1, 'precision','%4.3f');
clear;
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%uncomment for using diabetes dataset.

        data=load('diabetes.data.txt');
        Meas = data((data(:,3) > 0),:);
        Xmeas = Meas(:,1:8); Y = Meas(:,9);
        P = cvpartition(Y,'Holdout',0.2);
        svmStruct3 = fitcsvm(Xmeas(P.training,:),Y(P.training),'KernelFunction','linear','BoxConstraint',.01);
       % Ccostly = predict(svmStruct3,Xmeas(P.test,:));
       Ccostly = predict(svmStruct3,Xmeas);
        errRate3 = sum(Y~= Ccostly)/(P.TestSize+P.TrainSize);
        
        Xmeas = Meas(:,[1,2,3,4,6,7,8]);
        svmStruct2 = fitcsvm(Xmeas(P.training,:),Y(P.training),'KernelFunction','linear','BoxConstraint',.01);
        %Cmid =predict(svmStruct2,Xmeas(P.test,:));
        Cmid =predict(svmStruct2,Xmeas);
        errRate2 = sum(Y~= Cmid)/(P.TestSize+P.TrainSize);
        
        Xmeas = Meas(:,[1,3,4,6:8]);
        %svmStruct1 = svmtrain(Xmeas(P.training,:),Y(P.training),'kernel_function','linear','boxconstraint',.01); %#ok<SVMTRAIN>
        svmStruct1 = fitcsvm(Xmeas(P.training,:),Y(P.training),'KernelFunction','linear','BoxConstraint',.01);
        %Ccheap =predict(svmStruct1,Xmeas(P.test,:));
        Ccheap =predict(svmStruct1,Xmeas);
        errRate1 = sum(Y~= Ccheap)/(P.TestSize+P.TrainSize);
        %y=Y(P.test); 

        y=Y; y1=Ccheap;y2=Cmid;y3=Ccostly;
        n=length(y1);
       errdiff=[(errRate1-errRate2) (errRate1-errRate3)];
        Costs=[5,17.61,22.78];lam=0.005;lam=0.001 %%% 2nd sensor is optimal%%%%
        Cdiff(1)=0;Cdiff(2)=lam*(Costs(2)-Costs(1));Cdiff(3)=lam*(Costs(2)+Costs(3)-Costs(1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%
%%%%%%%%% Uncomment below for BSC data generation
    % n=500000;
    %pprior=0.7;p1=0.3;p2=0.5;p3=0.4; %channel noise
    % y = rand(n,1) <= pprior; y=double(y);%%Bernoulli
    % y1=bsc(y,p1);ind1=find(y1~=y);y2=y1;
    % y2(ind1)=bsc(y(ind1),p2);
    % ind2=find(y2~=y);
    % y3=y2;y3(ind2)=bsc(y(ind2),p3);
    % 
    % % %%% For weak domainance
    % % 
    % % 
    %  p2c=0.08;p3c=0.051;
    %  ind1c=find(y1==y);y2(ind1c) = bsc(y(ind1c),p2c);
    %  ind2c=find(y2==y);y3(ind2c) = bsc(y(ind2c),p3c);

    %Cdiff = [.1 .25 .25];
    %%%%%%%Code for USS%%%%%%%%%%%%
A=3; %% number of actions
 

obs=ones(1,A);
Y=[y1, y2, y3];
disag12=0;disag23=0;disag31=0; stats=zeros(1,A);
%L=ceil(2*log(nD^2)/D^2);
%for m=1:L
 %   for act=1:a
        
    %%%% sampling with replacement
    
    


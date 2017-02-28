function out=UCBHeart_WD(settings)

K=settings.K;
c=settings.c                           %cost vector
svm=settings.svm;
p=settings.p                               %error vector
T=settings.T;                           % number of rounds
iterations=settings.iterations;
FeaLen=settings.FeaLen;
data=settings.data;

loss=p+c
[opt, ~]=min(loss);               % optimal actions
cdiff=zeros(K,K);

for j=2:1:K
    for k=1:1:j-1
        cdiff(j,k)=c(j)-c(k);        % since agorithm works estimates the differences \gamma(1)-\gamma(i), we need the cost differences
    end
end

Regs=zeros(T,iterations);

for i=1:1:iterations
    RunLoss=zeros(T,1);                   % For each iteration stores the loss of action taken in each round
    N=zeros(K,1);                         % number of pulls of each arm
    n=zeros(K,1);                         % total number of observation of each arm
   % ycomp=zeros(K,1);                     % pairwise aggrements (comparison of y)
    feed=zeros(K,K);                      % stores cumulative dis-agreements for estimation
    hatg=zeros(K,K);
    UCB=zeros(K,K);  
   
    %% Intialization
     I=K;                                   % play arm K
     
    %% Generate a sample from dataset with replacement and observe output for the same
     x=datasample(data,1); y=zeros(I,1);                      
     for j=1:1:I
         y(j)=predict(svm{j},x(1:FeaLen(j)));
     end
     N(I)=N(I)+1;                                % update count of arm played
     n(1:I)=n(1:I)+1;                       % update count of all observations
     RunLoss(1,1)=loss(I);                  % loss from playing arm K
     
     for j=2:1:I
         for k=1:1:j-1
             feed(j,k)=feed(j,k)+xor(y(j),y(k));    % update all pairwise dis-agreements
             hatg(j,k)=feed(j,k)/n(j);
     %        UCB(j,k)=hatg(j,k) + sqrt(1.5*log(t)/n(j));
         end
    end
    %% main algorithm 
    for t=2:1:T
        if  rem(t,ceil(T/10))==1,
            fprintf(1,'.'); % fprintf('%d/%d\n',t,T);
        end
        
        
    for j=2:1:K
         for k=1:1:j-1
             UCB(j,k)=hatg(j,k) + sqrt(1.5*log(t)/n(j));
         end
    end
    

    %%% implements sorting algorithm and find the best arm
    flag=1;
    for j=1:1:K-1
        if all(cdiff((j+1):K,j)>=UCB((j+1):K,j))
            I=j;
            flag=0;
            break;
        else
            continue;
        end
    end   
     
     %% if no arm is found to be unambiguouly optimal then
     if flag
         I=K;
     end
     
     %% Generate a datasample (with replacement) and observe the predictions
     x=datasample(data,1); y=zeros(I,1);                      
     for j=1:1:I
         y(j)=predict(svm{j},x(1:FeaLen(j)));
     end  
        
     N(I)=N(I)+1;                                % update count of arm played
     n(1:I)=n(1:I)+1;                            % update count of all observations
     RunLoss(t,1)=loss(I);                       % running loss from playing arm I
     
     for j=2:1:I
         for k=1:1:j-1
             feed(j,k)=feed(j,k)+xor(y(j),y(k));    % update all pairwise dis-agreements
             hatg(j,k)=feed(j,k)/n(j);
      %       UCB(j,k)=hatg(j,k) + sqrt(1.5*log(t)/n(j));
         end
    end
     
        
   end  
 
    regret =  RunLoss- repmat(opt, size(RunLoss));
    Regs(:,i)=cumsum(regret,1);

end

out=Regs;

%%%%%%%%%%%%%%%

% p1=settings.p1;                            % error prob of sensor 1
% p2=settings.p2;                            % error prob of sensor 2
% svmStruct1=settings.svmStruct1;
% svmStruct2=settings.svmStruct2;
% data=settings.data;
% c=settings.c;
% T=settings.T;                           % number of rounds
% iterations=settings.iterations;
% dataSize=size(data,1);
% dataLen=size(data,2)-1;
% 
% Regs=zeros(T,iterations);
% 
% for i=1:1:iterations
%     
%     opt=max(p1-p2,c);               % optimal actions
%     loss=zeros(T,1);
%     N2=0;                           % counts of arm-2 pulls
%     ltot=0;
%     
%     for t=1:1:T
%         if t==1
%            x=data(randi(dataSize),:);      %generate input labels 0 with prob p
%            y1=predict(svmStruct1,x([1,3,4,6:8]));               % output of sensor 1
%            y2=predict(svmStruct2,x(1:dataLen));              % output of sensor 2
%            l=xor(y1,y2);
%            N2=N2+1;
%            ltot=ltot+l;    
%            loss(t,1)=p1-p2;     % loss from action 2;
%         else
%            x=data(randi(dataSize),:);                 %generate input labels 0 with prob p
%            y1=predict(svmStruct1,x([1,3,4,6:8]));                   % always read sensor 1
%            UCB= ltot/N2 + sqrt(2*log(t)/N2);
%     
%            if UCB > c
%               y2=predict(svmStruct2,x(1:dataLen));                % output of sensor 2
%               l=xor(y1,y2);
%               N2=N2+1;
%               ltot=ltot+l;
%               loss(t,1)=p1-p2;
%            else
%               loss(t,1)=c;
%            end
%         end
%     end
%     regret =  repmat(opt, size(loss))-loss;
%     Regs(:,i) = cumsum(regret,1);
% end        
% out= Regs;
    
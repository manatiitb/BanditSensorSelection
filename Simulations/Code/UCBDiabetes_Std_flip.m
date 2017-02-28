function out=UCBDiabetes_Std_flip(settings)

K=settings.K;
data=settings.data;
svm=settings.svm;
c=settings.c;                           %cost vector
FeaLen=settings.FeaLen;
p=settings.p;                               %error vector
T=settings.T;                           % number of rounds
iterations=settings.iterations;


loss=p+c;
[opt, ~]=min(loss);               % optimal actions


Regs=zeros(T,iterations);

for i=1:1:iterations
    RunLoss=zeros(T,1);                   % For each iteration stores the loss of action taken in each round
    N=zeros(K,1);                         % number of pulls of each arm
    n=zeros(K,1);                         % total number of observation of each arm
   % ycomp=zeros(K,1);                     % pairwise aggrements (comparison of y)
    feed=zeros(K,1);                      % stores cumulative dis-agreements for estimation
    hatg=zeros(K,1);
    UCB=zeros(K,1);  
   
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
     for j=1:1:I
         feed(j)=feed(j)+xor(x(FeaLen(K)+1),y(j));
         hatg(j)=feed(j)/n(j);
     end
  
    for t=2:1:T
        if  rem(t,ceil(T/10))==1,
            fprintf(1,'.'); % fprintf('%d/%d\n',t,T);
        end
        
        for j=1:1:K
            UCB(j)= hatg(j) - sqrt(1.5*log(t)/n(j)) + c(j);
        end
        
        [~, I]=min(UCB);
        
       % Sample Data
       x=datasample(data,1); y=zeros(I,1);                      
       for j=1:1:I
         y(j)=predict(svm{j},x(1:FeaLen(j)));
       end
         N(I)=N(I)+1;                                % update count of arm played
         n(1:I)=n(1:I)+1;                       % update count of all observations
         RunLoss(t,1)=loss(I);                  % loss from playing arm K
        for j=1:1:I
            feed(j)=feed(j)+xor(x(FeaLen(K)+1),y(j));
            hatg(j)=feed(j)/n(j);
        end      
    end  
 
    regret =  RunLoss- repmat(opt, size(RunLoss));
    Regs(:,i)=cumsum(regret,1);

end

out=Regs;
    
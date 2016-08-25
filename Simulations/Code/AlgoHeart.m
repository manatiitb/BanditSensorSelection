function out=AlgoHeart(settings)

K=settings.K;
alpha=settings.alpha;                        %alpha parameter in the algorithm
c=settings.costs;                           %cost vector

p=settings.p;                               %error vector
T=settings.T;                           % number of rounds
iterations=settings.iterations;


[opt, optind]=min(p+c);               % optimal actions

Regs=zeros(T,iterations);
N=zeros(K,1);                         % number of pulls of each arm
n=zeros(K,1);                         % total number of observation of each arm
for i=1:1:iterations
    loss=zeros(T,1);
    ltot=0;
    N=zeros(K,1);                         % number of pulls of each arm
    n=zeros(K,1);                         % total number of observation of each arm
    ne=0;                                %exploration count
                                         %estimate of gamma
    [y,ycomp]=playarm(K);
    N(K)=1;                         %update count of arm plays
    for j=1:1:K
        n(j)=n(i)+1;                %update observation count
    end
    ghat=ycomp./n;                  %estimate of gamma;
    for t=2:1:T
        N./(alpha*log(t));

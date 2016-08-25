function out=ConfiSet(N, n, ne, const, Ecost)

Condn=zeros(3,1);
K=size(N,1);              
Del=zeros(K,1);          %stores sub-optimality gap

[opt, optind]=min(Ecost);
for i=1:1:K
    Del(i)=Ecost(i)-opt;  %find sub-optimality gap
end

Del(optind)=min(Del(Del>0)); % find the smallest sub-optimality gap and replace zero gap of optimal arm by this;

D=0.5./(Del.^2);
u=cumsum(N);
if sum((u/const)>=D)==K
    Condn(1)=1;
else
    Condn(1)=0;
end


if min(u) < ne/(2*K)
    Condn(2)=1;
else
    Condn(2)=1;
end




out=Condn;





end

    

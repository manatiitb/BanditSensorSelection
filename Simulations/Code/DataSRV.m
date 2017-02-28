clear;
n=20000;
pprior=0.7;p1=0.3;p2=0.5;p3=0.4; %channel noise
y = rand(n,1) <= pprior; y=double(y);%%Bernoulli
y1=bsc(y,p1);ind1=find(y1~=y);y2=y1;
y2(ind1)=bsc(y(ind1),p2);
ind2=find(y2~=y);
y3=y2;y3(ind2)=bsc(y(ind2),p3);

%%% For weak domainance

% p2c=0.05;p3c=0.05;
% ind1c=find(y1==y);y2(ind1c) = bsc(y(ind1c),p2c);
% ind2c=find(y2==y);y3(ind2c) = bsc(y(ind2c),p3c);

A=3; %% number of actions
Cdiff = [.1 .1 .01]; 

obs=ones(1,A);
Y=[y1, y2, y3];
disag12=0;disag23=0;disag31=0; stats=zeros(1,A);
init=400;

       disag12=sum(y1(1:init)~=y2(1:init))/init;
       disag23=sum(y3(1:init)~=y2(1:init))/init;
       disag31=sum(y1(1:init)~=y3(1:init))/init;

       
       
est12 = disag12/(Cdiff(2));% + sqrt(log(obs)./obs);
est23 = disag23/(Cdiff(3));
est31 = disag31/((Cdiff(3)+Cdiff(2)));

for t=init+1:19000

    if (est12 < 1 & est31 < 1)
       a=1;obs(a)=obs(a)+1;
   elseif (est12 >= 1 & est23 < 1)
       a=2;
       obs(a)=obs(a)+1;obs(a-1)=obs(a-1)+1;
       disag12=(disag12+abs(y1(t)-y2(t)));
       est12 = disag12/(Cdiff(a)*obs(a)) + sqrt(log(obs(a))/(obs(a)*Cdiff(a)^2));
   else
       a=3;obs(a)=obs(a)+1;obs(a-1)=obs(a-1)+1;obs(a-2)=obs(a-2)+1;
       disag12=disag12+abs(y1(t)-y2(t));
       est12 = disag12/(Cdiff(a-1)*obs(a-1)) + sqrt(log(obs(a-1))/(obs(a-1)*Cdiff(a-1)^2));
       disag23=disag23+abs(y3(t)-y2(t));
       est23 = disag23/(Cdiff(a)*obs(a))+ sqrt(log(obs(a))/(obs(a)*Cdiff(a)^2));
       disag31=disag31+abs(y1(t)-y3(t));
       est31 = disag31/((Cdiff(a)+Cdiff(a-1))*obs(2))+ sqrt(log(obs(a))/(obs(a)*(Cdiff(a-1)+Cdiff(a))^2));
   end
     
end
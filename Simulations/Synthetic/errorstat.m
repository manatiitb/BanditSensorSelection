function [missp,condp]=errorstat(settings)


p=settings.p;                             % input label distribution, probability of 0
p1=settings.p1;                            % error prob of sensor 1
p2=settings.p2;                            % error prob of sensor 2
tot1=0;
tot2=0;
t1=0;

for t=1:1:1000000
    x=(rand < p);
    y1=BSC(x,p1);
    y2=BSC(x,p2);
    tot1=tot1+ xor(y1,y2);
    if x==y1
       t1=t1+1; 
       tot2=tot2+ xor(y2,x);
    end
end

missp=tot1/t;
condp=tot2/t1;

%out=[missp,condp];

end
    
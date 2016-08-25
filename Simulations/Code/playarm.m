function output=playarm(k,settings)

y=zeros(k,1);
ycomp=zeros(K,1);
K=settings.K;
data=settings.data;
dataSize=size(data,1);
x=data(randi(dataSize),:);
FeaLen=settings.FeaLen;                 %Length of feature vector for each classifier.
for i=1:1:k
    svmStruct=settings.svmStruct(i);
    y(i,1)=predict(svmStruct,x(1:FeaLen(i,1)));
end

output=y;

for i=1:1:k
    ycomp(i)=xor(y(1),y(i));
end

end




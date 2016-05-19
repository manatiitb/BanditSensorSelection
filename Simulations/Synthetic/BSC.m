function f=BSC(x,p)

if (rand<p)                 % with probability p, x is flipped
    y= ~x;
else
    y=x;
end

f=y;
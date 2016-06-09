function b = selfmedian(b)
[m,n]=size(b);
for j=1:m
    for i=3:n-2
        c = [b(j,i-2),b(j,i-1),b(j,i),b(j,i+1),b(j,i+2)];
        d = c(c==255);
        if length(d)>2
            b(j,i)=255;
        elseif b(j,i)==255
            b(j,i)=255;
        else
            b(j,i)=0;
        end
    end
end

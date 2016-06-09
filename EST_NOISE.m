function [E,sig] = EST_NOISE(J,imgNos)

for i=1:imgNos
    J{i} = double(J{i});
end
[n1,n2] = size(J{1});
E = zeros(n1,n2);
sig = zeros(n1,n2);

% EST_NOISE
for i=1:imgNos
    E = E + J{i};
end
E = (E/imgNos);
for i=1:imgNos
    sig = sig + (E - J{i}).^2;
end

sig = sqrt(sig/imgNos);
sig = sig/max(max(sig));
end
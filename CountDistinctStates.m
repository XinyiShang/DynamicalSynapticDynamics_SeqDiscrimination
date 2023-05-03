function [num] = CountDistinctStates(data)
%count the number of distict states when having more than one sequences
data(data<20) = 0;
data(data>=20) = 1;
data = table(data);
C = unique(data);
[num, ~] = size(C);

end
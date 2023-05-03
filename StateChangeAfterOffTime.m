function [NumDiff] = StateChangeAfterOffTime(r,off_time)
%determine whether there are different states are there after each stimulus 
%imput: r, off_time of each stimulus
%output: Number of unique columns
NumDiff = 0;
shape = size(r);
rowN = shape(1,1);
A = zeros(rowN, length(off_time));
r(r<20) = 0;
r(r>=20) = 1;
for i = 1:length(off_time)
    A(:,i) = r(:,off_time(i)+500);
end

NumDiff = rank (A);

end
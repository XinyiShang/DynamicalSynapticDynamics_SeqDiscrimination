function [state_d] = countStates(r,off_time)
%COUNT_STATE Summary of this function goes here
%count the number of firing unit
thresh = 20;
offT = off_time(length(off_time));
new_rd = r( : ,end-1);
mn_newrd = new_rd;
state_d = zeros(size(mn_newrd));
for i = 1:100
    if mn_newrd(i)>thresh
        state_d(i) = 1;
    else
        state_d(i) = 0;
    end
end
end


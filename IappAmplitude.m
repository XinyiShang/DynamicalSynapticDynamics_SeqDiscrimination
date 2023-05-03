clear;
%W_e0_val = [-10:1:190];
%W_ee_max_val = [-0.1:.01:1.9];
%W_e0_val = [0:2.5:250];
%W_ee_max_val = [-0.1:.02:1.9];
%W_ee_max_val = .1;
%W_e0_val = 160;、
W_e0_val = [0:50:500];
W_ee_max_val = [-0.1:.2:1.9];
W_ei_val = .665;
W_ie_val = -540;
Iapp_ratio = [0:.5:5];
Num = length(W_e0_val);
Num_Iapp = length(Iapp_ratio);

StateNum = NaN(Num,Num);
StateNum_d = zeros(Num,Num);
StateNum_f = zeros(Num,Num);
StateNum_b = zeros(Num,Num);

Rank = NaN(Num,Num);
Rank_d = zeros(Num,Num);
Rank_f = zeros(Num,Num);
Rank_b = zeros(Num,Num);

for count = 1: Num_Iapp
    
for i = 1:Num
    
    for j = 1:Num
        %for k = 1:Num_Iapp
        p = make_params("W_e0",W_e0_val(i),"W_ee_max",W_ee_max_val(j),"W_ei",W_ei_val,"W_ie",W_ie_val);
        seq = generate_sequences(p,'permutations');
        [Iapp,on_time, off_time] = make_Iapp(p,seq(1,:));
        Iapp = Iapp*Iapp(count);
        
        [r,s] = run_network_noDepression(p,Iapp,'silent','yes');
        [state] = countStates(r,off_time);
        StateNum(i,j) = sum(state);
        Rank(i,j) = StateChangeAfterOffTime(r,off_time);
        
        [r_d,s] = run_network(p,Iapp,'silent','yes');
        [state_d] = countStates(r_d,off_time);
        StateNum_d(i,j) = sum(state_d);
        Rank_d(i,j) = StateChangeAfterOffTime(r_d,off_time);
        
        [r_f,s] = run_network_onlyFacilitation(p,Iapp,'silent','yes');
        [state_f] = countStates(r_f,off_time);
        StateNum_f(i,j) = sum(state_f);
        Rank_f(i,j) = StateChangeAfterOffTime(r_f,off_time);
        
        [r_b,s] = run_network_facilitation(p,Iapp,'silent','yes');
        [state_b] = countStates(r_b,off_time);
        StateNum_b(i,j) = sum(state_b);
        Rank_b(i,j) = StateChangeAfterOffTime(r_b,off_time);
        %end
    end

end
disp(count);
foldername = 'D:\Brandeis\Lab\1\simulation_code\MyDataSave\Mar16';

fname = sprintf('StateNum_d_Mar16_6stimulus_%d.mat', count);
filepath = fullfile(foldername,fname);
save(filepath,'StateNum_d');

fname = sprintf('StateNum_f_Mar16_6stimulus_%d.mat', count);
filepath = fullfile(foldername,fname);
save(filepath,'StateNum_f');

fname = sprintf('StateNum_b_Mar16_6stimulus_%d.mat', count);
filepath = fullfile(foldername,fname);
save(filepath,'StateNum_b');

fname = sprintf('StateNum_Mar16_6stimulus_%d.mat', count);
filepath = fullfile(foldername,fname);
save(filepath,'StateNum');

fname = sprintf('Rank_d_Mar16_6stimulus_%d.mat', count);
filepath = fullfile(foldername,fname);
save(filepath,'Rank_d');

fname = sprintf('Rank_f_Mar16_6stimulus_%d.mat', count);
filepath = fullfile(foldername,fname);
save(filepath,'Rank_f');

fname = sprintf('Rank_b_Mar16_6stimulus_%d.mat', count);
filepath = fullfile(foldername,fname);
save(filepath,'Rank_b');

fname = sprintf('Rank_Mar16_6stimulus_%d.mat', count);
filepath = fullfile(foldername,fname);
save(filepath,'Rank');
end
    

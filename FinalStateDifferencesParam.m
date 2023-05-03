clear;
%W_e0_val = [-10:1:190];
%W_ee_max_val = [-0.1:.01:1.9];
%W_e0_val = [0:2.5:250];
%W_ee_max_val = [-0.1:.02:1.9];
%W_ee_max_val = .1;
%W_e0_val = 160;、
W_e0_val = [125 125 125 125];
W_ee_max_val = [-0.1:.05:1.9];
W_ei_val = .665;
W_ie_val = -540;
Iapp_ratio = 1.5;
%Num = length(W_e0_val);
%Num_Iapp = length(Iapp_ratio);

%StateNum = NaN(Num,Num);
%StateNum_d = zeros(Num,Num);
%StateNum_f = zeros(Num,Num);
%StateNum_b = zeros(Num,Num);

%Rank = NaN(Num,Num);
%Rank_d = zeros(Num,Num);
%Rank_f = zeros(Num,Num);
%Rank_b = zeros(Num,Num);
num_types = zeros(size(W_ee_max_val));
num_types_d = zeros(size(W_ee_max_val));
num_types_f = zeros(size(W_ee_max_val));
num_types_b = zeros(size(W_ee_max_val));

%%
for i = 1:length(W_ee_max_val)
final_state = zeros(101, 64);
final_state_d = zeros(101, 64);
final_state_f = zeros(101, 64);
final_state_b = zeros(101, 64);
p = make_params("W_e0",125,"W_ee_max",W_ee_max_val(i),"W_ei",W_ei_val,"W_ie",W_ie_val);
seq = generate_sequences(p,'permutations');

for count = 1: 64
        %for k = 1:Num_Iapp
        [Iapp,on_time, off_time] = make_Iapp(p,seq(count,:));
        Iapp = Iapp*1.5;
        
        [r,s] = run_network_noDepression(p,Iapp,'silent','yes');
        final_state(:,count) = r(:,end);
        
        [r_d,s] = run_network(p,Iapp,'silent','yes');
        final_state_d(:,count) = r_d(:,end);
        
        [r_f,s] = run_network_onlyFacilitation(p,Iapp,'silent','yes');
        final_state_f(:,count) = r_f(:,end);

        [r_b,s] = run_network_facilitation(p,Iapp,'silent','yes');
        final_state_b(:,count) = r_b(:,end);
        %end

%disp(count);
%foldername = 'D:\Brandeis\Lab\1\simulation_code\MyDataSave\April13';

%fname = sprintf('r_d_April13_6stimulus_%d.mat', count);
%filepath = fullfile(foldername,fname);
%save(filepath,'r_d');

%fname = sprintf('r_f_April13_6stimulus_%d.mat', count);
%filepath = fullfile(foldername,fname);
%save(filepath,'r_f');

%fname = sprintf('r_b_April13_6stimulus_%d.mat', count);
%filepath = fullfile(foldername,fname);
%save(filepath,'r_b');

%fname = sprintf('r_April13_6stimulus_%d.mat', count);
%filepath = fullfile(foldername,fname);
%save(filepath,'r');

end

foldername = 'D:\Brandeis\Lab\1\simulation_code\MyDataSave\April13_3';

fname = sprintf('final_state_d_April13_6stimulus_%d.mat', i);
filepath = fullfile(foldername,fname);
save(filepath,'final_state_d');

fname = sprintf('final_state_f_April13_6stimulus_%d.mat', i);
filepath = fullfile(foldername,fname);
save(filepath,'final_state_f');

fname = sprintf('final_state_b_April13_6stimulus_%d.mat', i);
filepath = fullfile(foldername,fname);
save(filepath,'final_state_b');

fname = sprintf('final_state_April13_6stimulus_%d.mat', i);
filepath = fullfile(foldername,fname);
save(filepath,'final_state');
    
%% convert to firing/non-firing with threshold 20Hz\
final_state_binary = zeros(101, 64);
final_state_d_binary = zeros(101, 64);
final_state_f_binary = zeros(101, 64);
final_state_b_binary = zeros(101, 64);
thresh = 20;

final_state_binary = BinaryConvert(final_state,thresh);
final_state_d_binary = BinaryConvert(final_state_d,thresh);
final_state_f_binary = BinaryConvert(final_state_f,thresh);
final_state_b_binary = BinaryConvert(final_state_b,thresh);


%% count unique column types

num_types(i) = count_unique_column_types(final_state);
num_types_d(i) = count_unique_column_types(final_state_d);
num_types_f(i) = count_unique_column_types(final_state_f);
num_types_b(i) = count_unique_column_types(final_state_b);

disp(i);
end

save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\April13_3\num_types_6stimulus.mat','num_types');
save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\April13_3\num_types_d_6stimulus.mat','num_types_d');
save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\April13_3\num_types_f_6stimulus.mat','num_types_f');
save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\April13_3\num_types_b_6stimulus.mat','num_types_b');

%%
plot(num_types_d);
title("network with depression");
xlabel("W ee max");
ylabel("# of distinct final states");

xticks(1:2:numel(num_types))
xticklabels(-0.1:.1:1.9)


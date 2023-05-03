clear;
%W_e0_val = [-10:1:190];
%W_ee_max_val = [-0.1:.01:1.9];
%W_e0_val = [0:2.5:250];
%W_ee_max_val = [-0.1:.02:1.9];
%W_ee_max_val = .1;
%W_e0_val = 160;、
W_e0_val = [125 125 125 125];
W_ee_max_val = [1.4 .3 .4 .4];
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
final_state = zeros(101, 64);
final_state_d = zeros(101, 64);
final_state_f = zeros(101, 64);
final_state_b = zeros(101, 64);
%%
p_d = make_params("W_e0",125,"W_ee_max",0.4,"W_ei",W_ei_val,"W_ie",W_ie_val);
seq_d = generate_sequences(p_d,'permutations');

p_b = make_params("W_e0",125,"W_ee_max",0.35,"W_ei",W_ei_val,"W_ie",W_ie_val);
seq_b = generate_sequences(p_b,'permutations');
        
for count = 1: 64
        
    [Iapp_d,on_time_d, off_time_d] = make_Iapp(p_d,seq_d(count,:));
    Iapp_d = Iapp_d*1.5;
    
    [Iapp_b,on_time_b, off_time_b] = make_Iapp(p_b,seq_b(count,:));
    Iapp_b = Iapp_b*1.5;
        %for k = 1:Num_Iapp
        %{
        p = make_params("W_e0",125,"W_ee_max",1.4,"W_ei",W_ei_val,"W_ie",W_ie_val);
        seq = generate_sequences(p,'permutations');
        [Iapp,on_time, off_time] = make_Iapp(p,seq(count,:));
        Iapp = Iapp*1.5;
        
        [r,s] = run_network_noDepression(p,Iapp,'silent','yes');
        final_state(:,count) = r(:,end);
        
        p_d = make_params("W_e0",125,"W_ee_max",0.4,"W_ei",W_ei_val,"W_ie",W_ie_val);
        seq = generate_sequences(p,'permutations');
        [Iapp,on_time, off_time] = make_Iapp(p,seq(count,:));
        Iapp = Iapp*1.5;
        %}
        [r_d,s] = run_network(p_d,Iapp_d,'silent','yes');
        final_state_d(:,count) = r_d(:,end);
        %{
        p = make_params("W_e0",125,"W_ee_max",0.4,"W_ei",W_ei_val,"W_ie",W_ie_val);
        seq = generate_sequences(p,'permutations');
        [Iapp,on_time, off_time] = make_Iapp(p,seq(count,:));
        Iapp = Iapp*1.5;
        
        [r_f,s] = run_network_onlyFacilitation(p,Iapp,'silent','yes');
        final_state_f(:,count) = r_f(:,end);
        
        p_b = make_params("W_e0",125,"W_ee_max",0.35,"W_ei",W_ei_val,"W_ie",W_ie_val);
        seq = generate_sequences(p,'permutations');
        [Iapp,on_time, off_time] = make_Iapp(p,seq(count,:));
        Iapp = Iapp*1.5;
        %}
        [r_b,s] = run_network_facilitation(p_b,Iapp_b,'silent','yes');
        final_state_b(:,count) = r_b(:,end);
        %end

disp(count);
foldername = 'D:\Brandeis\Lab\1\simulation_code\MyDataSave\April14';

fname = sprintf('r_d_April14_6stimulus_%d.mat', count);
filepath = fullfile(foldername,fname);
save(filepath,'r_d');
%{
fname = sprintf('r_f_April14_6stimulus_%d.mat', count);
filepath = fullfile(foldername,fname);
save(filepath,'r_f');
%}
fname = sprintf('r_b_April14_6stimulus_%d.mat', count);
filepath = fullfile(foldername,fname);
save(filepath,'r_b');
%{
fname = sprintf('r_April13_6stimulus_%d.mat', count);
filepath = fullfile(foldername,fname);
save(filepath,'r');
%}
end

%save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\April13_3\final_state_6stimulus.mat','final_state');
save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\April14\final_state_d_6stimulus.mat','final_state_d');
%save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\April13_3\final_state_f_6stimulus.mat','final_state_f');
save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\April14\final_state_b_6stimulus.mat','final_state_b');


%save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\Mar16\Rank_d_Mar02_6stimulus.mat','Rank_d');
%save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\Mar16\Rank_Mar02_6stimulus.mat','Rank');
%save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\Mar16\Rank_f_Mar02_6stimulus.mat','Rank_f');
%save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\Mar16\Rank_b_Mar02_6stimulus.mat','Rank_b');

%% Plotting

imagesc(final_state_d);
title("Network with depression");
xlabel("# of sequence");
ylabel("# of neuron");
colorbar;
caxis([0 200]);

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

%% binary plotting
imagesc(final_state_f_binary);
title("Network with facilitation");
xlabel("# of sequence");
ylabel("# of neuron");
colorbar;
caxis([0 1]);

%% count unique column types

num_types = count_unique_column_types(final_state);
num_types_d = count_unique_column_types(final_state_d);
num_types_f = count_unique_column_types(final_state_f);
num_types_b = count_unique_column_types(final_state_b);
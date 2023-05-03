clear
%p = make_params("W_e0",44,"W_ee_max",0.3,"W_ei",2.7,"W_ie",-8);
%p = make_params('sequence_length',4,"W_e0",41,"W_ee_max",1.58,"W_ei",1.475,"W_ie",-250);
p = make_params('sequence_length',4,"W_e0",23,"W_ee_max",0.1,"W_ei",1.5,"W_ie",-30);
%p = make_params('sequence_length',4);

seq = generate_sequences(p,'permutations');

%[r,s] = run_network_noDepression(p,Iapp,'silent','yes'); %network without depression and facilitation
%[r_b,D_b,s_b,F] = run_network_facilitation(p,Iapp,'silent','yes'); %network with facilitation and depression
%[r_d,D_d,s_d] = run_network(p,Iapp,'silent','yes'); %network with depression only
%[r_f,D_f,s_f] = run_network_onlyFacilitation(p,Iapp,'silent','yes'); %network with facilitation only
N = 16;
Num = 10;
endState = zeros(N,101);
endStateCount = zeros(1,Num);
figure(1)
ParaRange = (0:10:90);

for j = 1:Num
    %We0 = ParaRange(j);
    %p = make_params('sequence_length',4,"W_e0",41,"W_ee_max",1.58,"W_ei",1.475,"W_ie",-250);
    %seq = generate_sequences(p,'permutations');
    for i = 1:N
        [Iapp,on_time, off_time] = make_Iapp(p,seq(i,:));
        %[Iapp,on_time,off_time] = make_Iapp(p,seq(i,:));

        [r,s] = run_network_noDepression(p,Iapp*ParaRange(j),'silent','yes'); %network without depression and facilitation
        %[r,s] = run_network_noDepression(p,Iapp,'silent','yes');
        %r(r<20) = 0;
        %r(r>=20) = 1;
        %startState(i,:) = r(:,on_time(1)+1)';
        endState(i,:) = r(:,off_time(end)+1)';
        %subplot(4,4,i)
        %imagesc(r)
    end
    endStateCount(j) = CountDistinctStates(endState);
end
%sgtitle("Network with facilitation, Iapp*5")
%imagesc(r)
%colorbar

plot(endStateCount)
title("Distinct End States for the Network w/o Facilitation and Depression");
xlabel("Multiples of Iapp");
ylabel("# of end states");
set(gca,'xticklabels',ParaRange)

%%
figure(1)
imagesc(r)
colorbar
title("network w/o depression and facilitation");


figure(2)
imagesc(r_b)
colorbar
title("network w/ depression and facilitation");


figure(3)
imagesc(r_d)
colorbar
title("network w/ depression");


figure(4)
imagesc(r_f)
colorbar
title("network w/ facilitation");

%% plot histogram and find threshold
figure()
histogram(r)
title("network w/o depression and facilitation");

figure()
histogram(r_d)
title("network w/ depression");

figure
histogram(r_f)
title("network w/ facilitation");

figure()
histogram(r_b)
title("network w/ depression and facilitation");


%%

[state] = countStates(r,off_time);
figure(5)
imagesc(state);
colorbar;
title("network w/o depression and facilitation");


[state_d] = countStates(r_d,off_time);
figure(6)
imagesc(state_d);
colorbar;
title("network w/ depression");


[state_f] = countStates(r_f,off_time);
figure(7)
imagesc(state_f);
colorbar;
title("network w/ facilitation");


[state_b] = countStates(r_b,off_time);
figure(8)
imagesc(state_b);
colorbar;
title("network w/ depression and facilitation");
%% generate the confusion matrix

%run_expt(p,seq,expdata2,'slient','yes','no');
datadir = 'expdata2';
params = load([datadir '/params.mat']); params=params.p;
seqs = load([datadir '/seqs.mat']); seqs = seqs.seqs; nseqs = 2*size(seqs,1); %remember to change back
ntrials = params.Ntrials;
tgt_dir = [datadir '/target_trials'];
tst_dir = [datadir '/test_trials'];    
count = 0;
for i=1:10
    tgt_r = load([tgt_dir '/seq' num2str(i) '/rates.mat']); tgt_r=tgt_r.rates;
    tgt_soff = load([tgt_dir '/seq' num2str(i) '/stim_off_times.mat']); tgt_soff=tgt_soff.stim_off_times;
    tst_r = load([tst_dir '/seq' num2str(i) '/rates.mat']); tst_r=tst_r.rates;
    tst_soff = load([tst_dir '/seq' num2str(i) '/stim_off_times.mat']); tst_soff=tst_soff.stim_off_times;
    for j=1:ntrials
        count = count+1;
        soff1 = tgt_soff{j}(end);
        soff2 = tst_soff{j}(end);
        x_train(count,:) = mean(tgt_r{j}(1:params.Ne,(soff1+(.25/params.dt)):(soff1+(1.25/params.dt))),2);
        x_test(count,:) = mean(tst_r{j}(1:params.Ne,(soff2+(.25/params.dt)):(soff2+(1.25/params.dt))),2);
    end
end
x = x_train;
save([datadir '/x_train.mat'],'x','-mat')
x = x_test;
save([datadir '/x_test.mat'],'x','-mat')

convert_xtrain_xtest_2bin;
[cm] = confusion_matrix_binary('expdata2',10);

%%
%run_expt(p,seqs(1:10,:),'expdata3','silent','yes','no');

datadir = 'expdata3';
params = load([datadir '/params.mat']); params=params.p;
seqs = load([datadir '/seqs.mat']); seqs = seqs.seqs; nseqs = 2*size(seqs,1); %remember to change back
ntrials = params.Ntrials;
tgt_dir = [datadir '/target_trials'];
tst_dir = [datadir '/test_trials'];    
count = 0;
for i=1:10
    tgt_r = load([tgt_dir '/seq' num2str(i) '/rates.mat']); tgt_r=tgt_r.rates;
    tgt_soff = load([tgt_dir '/seq' num2str(i) '/stim_off_times.mat']); tgt_soff=tgt_soff.stim_off_times;
    tst_r = load([tst_dir '/seq' num2str(i) '/rates.mat']); tst_r=tst_r.rates;
    tst_soff = load([tst_dir '/seq' num2str(i) '/stim_off_times.mat']); tst_soff=tst_soff.stim_off_times;
    for j=1:ntrials
        count = count+1;
        soff1 = tgt_soff{j}(end);
        soff2 = tst_soff{j}(end);
        x_train(count,:) = mean(tgt_r{j}(1:params.Ne,(soff1+(.25/params.dt)):(soff1+(1.25/params.dt))),2);
        x_test(count,:) = mean(tst_r{j}(1:params.Ne,(soff2+(.25/params.dt)):(soff2+(1.25/params.dt))),2);
    end
end
x = x_train;
save([datadir '/x_train.mat'],'x','-mat')
x = x_test;
save([datadir '/x_test.mat'],'x','-mat')

convert_xtrain_xtest_2bin;
%%
[cm3] = confusion_matrix_binary('expdata3',10);
%%
%plot (r_f(3,:));
%hold on

%{
figure(1)
plot (state1(3,:));
hold on 
plot (state1(10,:));
hold off
%}



%{
p_p = p;
for i=1:3
    data = mean(r_f);
    states = state1;
    p_states{i} = states;
    mean_rs_p{i} = data;
end
for i=1:size(p_states{1},2)
    d12 = dist([p_states{1}(:,i) p_states{2}(:,i)]);
    d13 = dist([p_states{1}(:,i) p_states{3}(:,i)]);
    p_1_2_dists(i) = d12(1,2);
    p_1_3_dists(i) = d13(1,2);
end

%}

%% 
%{
%firing rate
figure(1);
erange = 1:100;
irange = 101:101;

r_e = r(erange,:);
r_i = r(irange,:);

plot(mean(r_e));
hold on
plot(r_i);

r_f_e = r_f(erange,:);
r_f_i = r_f(irange,:);

plot(mean(r_f_e));
plot(r_f_i);

legend('e','i','e_f','i_f');
title('firing rate');

%depression variable 
figure(2);
D_e = D(erange);
D_i = D(irange);

plot(D_e,'.');
hold on
plot(D_i,'.');

D_f_e = D_f(erange);
D_f_i = D_f(irange);

plot(D_f_e,'.');
plot(D_f_i,'.');

legend('e','i','e_f','i_f');
title('depression');

%facilitation variable 
figure(3);
F_e = F(erange);
F_i = F(irange);

plot(F_e,'.');
hold on
plot(F_i,'.');

legend('e_f','i_f');
title('facilitation');

%synaptic gating variable
figure(4);
s_e = s(erange);
s_i = s(irange);

plot(s_e,'.');
hold on
plot(s_i,'.');

s_f_e = s_f(erange);
s_f_i = s_f(irange);

plot(s_f_e,'.');
plot(s_f_i,'.');

legend('e','i','e_f','i_f');
title('synaptic gating');
%}

%%
%{
p = make_params();
seq = generate_sequences(p,'permutations');
basedir = 'D:\Brandeis\Lab\1\simulation_code\expdata' ;
init_type = 'silent';
memoptimize = 'yes';
delrfiles = 'yes';
run_expt(p,seq,basedir,init_type,memoptimize,delrfiles);
%}
%%
%figVersion = 'final_version2';
%figFolder = '8';
%saveStr = ['figures/' figVersion '/' figFolder]; mkdir(saveStr);

%%
p = make_params("W_e0",100,"W_ee_max",.2,"W_ei",.665,"W_ie",-540);
%p = make_params();
seq = generate_sequences(p,'permutations');
[Iapp,on_time, off_time] = make_Iapp(p,seq(8,:));
[r,s] = run_network(p,Iapp*10,'silent','yes');,

%Iapp = Iapp*1.4625;
%[r_2,s] = run_network(p,Iapp,'silent','yes');,

%Iapp = Iapp*1000;
%[r_3,s] = run_network(p,Iapp,'silent','yes');,
[isDiff] = StateChangeAfterOffTime(r,off_time);
imagesc(r)
%%
figure;
imagesc(r)
colorbar;
title("Network with facilitation and depression(Iapp ratio = 1)");
ylabel("Unit #");
xlabel("time");


figure;
imagesc(r_2)
colorbar;
title("Network with facilitation and depression(Iapp ratio = 100)");
ylabel("Unit #");
xlabel("time");

figure;
imagesc(r_3)
colorbar;
title("Network with facilitation and depression(Iapp ratio = 100000)");
ylabel("Unit #");
xlabel("time");

%% Run a network to exam the facilitation & depression variable
p = make_params("W_e0",600,"W_ee_max",.5);
%p = make_params();
seq = generate_sequences(p,'permutations');
[Iapp,on_time, off_time] = make_Iapp(p,seq(1,:));
[r,s] = run_network_noDepression(p,Iapp*0,'silent','yes');

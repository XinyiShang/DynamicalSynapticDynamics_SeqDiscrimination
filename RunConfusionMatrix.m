
W_ei_val = .665;
W_ie_val = -540;
p_d = make_params("W_e0",125,"W_ee_max",0.3,"W_ei",W_ei_val,"W_ie",W_ie_val);
seq_d = generate_sequences(p_d,'permutations');
%%
run_expt(p_d,seq_d,'expdata4','silent', 'yes' ,'yes');

%%
nnets = 1;
param1 = 'W_e0'; % 1st parameter to be varied. Must be a field in the parameter structure
param2 = 'W_ee_max'; % 2nd parameter to be varied
run_log.param1 = param1; run_log.param2 = param2;
run_log.param1_range = 125; run_log.param2_range = 0.3;
run_log.nnets = nnets; % # of nets at each parameter value to test
startMode = 'silent';
save(['D:\Brandeis\Lab\1\simulation_code\expdata4\run_log.mat'],'run_log','-mat')

%% make train
datadir = 'expdata4';
[x_train, x_test] = make_xtrain_xtest('D:\Brandeis\Lab\1\simulation_code\expdata4');

%% convert to bin

% Set the directory containing x_train.mat and x_test.mat
datadir = 'D:\Brandeis\Lab\1\simulation_code\expdata4';

% Set the threshold for binarization
thresh = 20;

% Load x_train and x_test
xtr = load([datadir '/x_train.mat']); xtr=xtr.x;
xtst = load([datadir '/x_test.mat']); xtst=xtst.x;

% Binarize x_train and x_test using the threshold
xtr_bin = (xtr > thresh);
xtst_bin = (xtst > thresh);

% Save the binarized versions
x = xtr_bin;
save([datadir '/x_train_bin.mat'],'x','-mat')
x = xtst_bin;
save([datadir '/x_test_bin.mat'],'x','-mat')

disp('done with binarization')

%%
train_and_test_decision_networks('D:\Brandeis\Lab\1\simulation_code\expdata4',[4 5 6],[1 2 3],'train_rand_order_binary','no');

%%
[worstSeqs,worstErrRates] = analyze_choices('D:\Brandeis\Lab\1\simulation_code\expdata4',10,'train_rand_order_binary','yes','yes','no');
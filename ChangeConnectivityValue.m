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

for count = 1: 64
    
for i = 1:Num
    
    for j = 1:Num
        %for k = 1:Num_Iapp
        p = make_params("W_e0",W_e0_val(i),"W_ee_max",W_ee_max_val(j),"W_ei",W_ei_val,"W_ie",W_ie_val);
        seq = generate_sequences(p,'permutations');
        [Iapp,on_time, off_time] = make_Iapp(p,seq(count,:));
        Iapp = Iapp*1.5;
        
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
    
%figure;
%imagesc(StateNum_d)
%colorbar;

%save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\Mar16\StateNum_d_Mar16_6stimulus.mat','StateNum_d');
%save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\Mar16\StateNum_Mar16_6stimulus.mat','StateNum');
%save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\Mar16\StateNum_f_Mar16_6stimulus.mat','StateNum_f');
%save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\Mar16\StateNum_b_Mar16_6stimulus.mat','StateNum_b');


%save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\Mar16\Rank_d_Mar02_6stimulus.mat','Rank_d');
%save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\Mar16\Rank_Mar02_6stimulus.mat','Rank');
%save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\Mar16\Rank_f_Mar02_6stimulus.mat','Rank_f');
%save('D:\Brandeis\Lab\1\simulation_code\MyDataSave\Mar16\Rank_b_Mar02_6stimulus.mat','Rank_b');

%% ei & ie
W_ei_val = [2.625:0.05:3.125];
W_ie_val = -[7.5:0.15:9];
W_e0 = 40;
W_ee_max = 1.5;
Num = 10;

StateNum = zeros(Num,Num);
StateNum_d = zeros(Num,Num);
StateNum_f = zeros(Num,Num);
StateNum_b = zeros(Num,Num);
Count = 0;
s_save = zeros(Num,Num);

for i = 1:Num
    
    for j = 1:Num
        p = make_params("W_e0",W_e0,"W_ee_max",W_ee_max,"W_ei",W_ei_val(i),"W_ie",W_ie_val(j));
        seq = generate_sequences(p,'permutations');
        [Iapp,on_time, off_time] = make_Iapp(p,seq(1,:));
        
        %[r,s] = run_network(p,Iapp,'silent','yes');
        %[state_d] = countStates(r,off_time);
        %s_save(i,j) = (s(2));
        %StateNum_d(i,j) = sum(state_d);
        
        %[r,s] = run_network_onlyFacilitation(p,Iapp,'silent','yes');
        %[state_f] = countStates(r,off_time);
        %StateNum_f(i,j) = sum(state_f);

        
        [r,s] = run_network_onlyFacilitation(p,Iapp,'silent','yes');
        [state] = countStates(r,off_time);
        StateNum(i,j) = sum(state);

        
        %[r,s] = run_network_facilitation(p,Iapp,'silent','yes');
        %[state_b] = countStates(r,off_time);
        %StateNum_b(i,j) = sum(state_b);

    end

end
    
figure;
imagesc(StateNum);
%title("Network w/0 STSP");
colorbar;

%figure;
%imagesc(StateNum_d);
%title("Network w/ depression");
%colorbar;

%figure;
%imagesc(StateNum_f);
%title("Network w/ facilitation");
%colorbar;

%figure;
%imagesc(StateNum_b);
%title("Network w/ STSP");
%colorbar;

%% load data
cd 'D:\Brandeis\Lab\1\simulation_code\MyDataSave\Mar02'
sum = zeros(11,11);
for count = 1:10
    fname = sprintf('StateNum_Mar02_6stimulus_%d.mat',count);
    load(fname);
    sum = sum + StateNum;
end
sum = sum/10;


%% plot figures with different connectivity values
figure;
%cd 'D:\Brandeis\Lab\1\simulation_code\MyDataSave\Jan24'

%load('StateNum_0.mat')
%imagesc(StateNum);
%title("Network w/0 STSP");

%load('StateNum_d_0.mat')
%imagesc(StateNum_d);
%title("Network w/ depression");

%load('StateNum_f_0.mat')
%imagesc(StateNum_f);
%title("Network w/ facilitation");

%load('StateNum_Jan24.mat')
%imagesc(StateNum_d);

imagesc(sum)
title("Network without facilitation and depression(average for 10 rounds)");
colorbar; 

xlabel('W ee max');
ylabel('W e0');
%xticklabels([-0.1:.01:1.9])
%yticklabels([-10:1:190]);
xt = get(gca, 'XTick'); 
xt = linspace(1, 11, 11);                         % Original 'XTick' Values
xtlbl = linspace(-0.1, 1.9, numel(xt));                     % New 'XTickLabel' Vector
set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XTickLabelRotation',40) 

yt = get(gca, 'YTick'); 
yt = linspace(0, max(yt),11);                        % Original 'XTick' Values
ytlbl = linspace(0, 500, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 

%% plot figures with different Iapp ratio
figure;
plot(Iapp_ratio,transpose(StateNum_d));
xticklabels([0:1:10]);
xlabel('ratio of applied current');
ylabel('number of firing units');
%title("Network without facilitation and depression");
%title("Network with facilitation and depression");
title("Network with depression");
%title("Network with facilitation");

%% plot figures with rank
figure;
z1 = squeeze(Rank_f(2, :, :));
imagesc(z1);
colorbar
title("Network without facilitation (We_0 = 5)");
xlabel('ratio of applied current');
ylabel('W ee max');
yt = get(gca, 'YTick'); 
yt = linspace(0, max(yt),21);                        % Original 'XTick' Values
ytlbl = linspace(-0.1, 1.9, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 

xt = get(gca, 'XTick'); 
xt = linspace(0, max(xt),11);                         % Original 'XTick' Values
xtlbl = linspace(0, 3, numel(xt));                     % New 'XTickLabel' Vector
set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XTickLabelRotation',40)

%%
cd 'D:\Brandeis\Lab\1\simulation_code\MyDataSave\Mar16'
N = 32;
fig = figure;
nS   = sqrt(N);
nCol = ceil(nS);
nRow = nCol - (nCol * nCol - N > nCol - 1);
for k = 1:32
  curr = k + 32;
  fname = sprintf('StateNum_f_Mar16_6stimulus_%d.mat',curr);
  %fname = sprintf('StateNum_f_Mar16_6stimulus_%d.mat',k);
  load(fname);
  subplot(nRow, nCol, k);
  %colormap(hot(256))
  imagesc(StateNum_f);
  %caxis ([0 100]);
  colorbar;
  value = k;
  %titleName = "seq # " + k;
  titleName = "seq # " + curr;
  title(titleName);
  xt = get(gca, 'XTick'); 
  xt = linspace(1, 11, 5);                         % Original 'XTick' Values
  xtlbl = linspace(-0.1, 1.9, numel(xt));                     % New 'XTickLabel' Vector
  set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XTickLabelRotation',40) 

  yt = get(gca, 'YTick'); 
  yt = linspace(0, max(yt),5);                        % Original 'XTick' Values
  ytlbl = linspace(0, 500, numel(yt));                     % New 'XTickLabel' Vector
  set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'W e0');
xlabel(han,'W ee max');
sgtitle('Network with facilitation');
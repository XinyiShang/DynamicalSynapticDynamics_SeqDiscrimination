W_e0_val = 0:25:200;
W_ee_max_val = 0:0.2:2; 
W_ei_val = 0.665;
W_ie_val = -540;
Iapp_ratio = 2;

stateNum = zeros(length(W_e0_val),length(W_ee_max_val));
stateNum_d = zeros(length(W_e0_val),length(W_ee_max_val));
stateNum_f = zeros(length(W_e0_val),length(W_ee_max_val));
stateNum_b = zeros(length(W_e0_val),length(W_ee_max_val));

Rank = zeros(length(W_e0_val),length(W_ee_max_val));
Rank_d = zeros(length(W_e0_val),length(W_ee_max_val));
Rank_f = zeros(length(W_e0_val),length(W_ee_max_val));
Rank_b = zeros(length(W_e0_val),length(W_ee_max_val));
for j = 1:length(W_e0_val)

    for k = 1:length(W_ee_max_val)
        p = make_params("W_e0",W_e0_val(j),"W_ee_max",W_ee_max_val(k),"W_ei",W_ei_val,"W_ie",W_ie_val);
        seq = generate_sequences(p,'permutations');
        %disp ("Iteration " + k);
        
        [Iapp, on_time, off_time] = make_Iapp(p,[1 2 1 2 1 2]);
         Iapp = Iapp * Iapp_ratio;            

         [r, s] = run_network_noDepression(p,Iapp,'silent','yes');
        state = countStates(r,off_time);
        stateNum(j,k) =sum(state);
        Rank(j,k) = StateChangeAfterOffTime(r,off_time);


        [r_d, s] = run_network(p,Iapp,'silent','yes');
        state = countStates(r_d,off_time);
        stateNum_d(j,k) =sum(state);
        Rank_d(j,k) = StateChangeAfterOffTime(r_d,off_time);

        [r_f, s] = run_network_onlyFacilitation(p,Iapp,'silent','yes');
        state = countStates(r_f,off_time);
        stateNum_f(j,k) =sum(state);
        Rank_f(j,k) = StateChangeAfterOffTime(r_f,off_time);


        [r_b, s] = run_network_facilitation(p,Iapp,'silent','yes');
        state = countStates(r_b,off_time);
        stateNum_b(j,k) = sum(state);
        Rank_b(j,k) = StateChangeAfterOffTime(r_b,off_time);

    end
end
thresh = 20;

%% plotting
figure;
subplot (2,2,1)
imagesc(Rank);
colorbar; 
%title("a)");
xlabel("W ee max");
ylabel("W e0");
colorbar;
%caxis([0 101]);
caxis([0 6]);

yt = get(gca, 'YTick'); 
yt = linspace(1, 9 ,9);                        % Original 'XTick' Values
ytlbl = linspace(0, 200, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 
%ylim([0.5, 10.5]);          % Ensure XTicks extend to the edges of the plot

xt = get(gca, 'XTick'); 
xt = linspace(1,11,6);                         % Original 'XTick' Values
xtlbl = linspace(0, 2, numel(xt));                     % New 'XTickLabel' Vector
set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XTickLabelRotation',40)
%xlim([0.5, 20.5]);          % Ensure XTicks extend to the edges of the plot
title("A")

subplot (2,2,2)
imagesc(Rank_f);
colorbar; 
%title("a)");
xlabel("W ee max");
ylabel("W e0");
colorbar;
%caxis([0 101]);
caxis([0 6]);

yt = get(gca, 'YTick');  
yt = linspace(1, 9 ,9);                        % Original 'XTick' Values
ytlbl = linspace(0, 200, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 
%ylim([0.5, 10.5]);          % Ensure XTicks extend to the edges of the plot

xt = get(gca, 'XTick'); 
xt = linspace(1,11,6);                         % Original 'XTick' Values
xtlbl = linspace(0, 2, numel(xt));                     % New 'XTickLabel' Vector
set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XTickLabelRotation',40)
%xlim([0.5, 20.5]);          % Ensure XTicks extend to the edges of the plot
title("B")

subplot (2,2,3)
imagesc(Rank_d);
colorbar; 
%title("a)");
xlabel("W ee max");
ylabel("W e0");
colorbar;
%caxis([0 101]);
caxis([0 6]);

yt = get(gca, 'YTick'); 
yt = linspace(1, 9 ,9);                        % Original 'XTick' Values
ytlbl = linspace(0, 200, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 
%ylim([0.5, 10.5]);          % Ensure XTicks extend to the edges of the plot

xt = get(gca, 'XTick'); 
xt = linspace(1,11,6);                         % Original 'XTick' Values
xtlbl = linspace(0, 2, numel(xt));                     % New 'XTickLabel' Vector
set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XTickLabelRotation',40)
%xlim([0.5, 20.5]);          % Ensure XTicks extend to the edges of the plot
title("C")

subplot (2,2,4)
imagesc(Rank_b);
colorbar; 
%title("a)");
xlabel("W ee max");
ylabel("W e0");
colorbar;
%caxis([0 101]);
caxis([0 6]);

yt = get(gca, 'YTick'); 
yt = linspace(1, 9 ,9);                        % Original 'XTick' Values
ytlbl = linspace(0, 200, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 
%ylim([0.5, 10.5]);          % Ensure XTicks extend to the edges of the plot

xt = get(gca, 'XTick'); 
xt = linspace(1,11,6);                         % Original 'XTick' Values
xtlbl = linspace(0, 2, numel(xt));                     % New 'XTickLabel' Vector
set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XTickLabelRotation',40)
%xlim([0.5, 20.5]);          % Ensure XTicks extend to the edges of the plot
title("D")

%%
save('C:\Users\anna_\OneDrive\Documents\MATLAB\PaulMillerLab\PaulMillerLab\MyDataSave\Set3\Rank_d_April29_6stimulus.mat','Rank_d');
save('C:\Users\anna_\OneDrive\Documents\MATLAB\PaulMillerLab\PaulMillerLab\MyDataSave\Set3\Rank_April29_6stimulus.mat','Rank');
save('C:\Users\anna_\OneDrive\Documents\MATLAB\PaulMillerLab\PaulMillerLab\MyDataSave\Set3\Rank_f_April29_6stimulus.mat','Rank_f');
save('C:\Users\anna_\OneDrive\Documents\MATLAB\PaulMillerLab\PaulMillerLab\MyDataSave\Set3\Rank_b_April29_6stimulus.mat','Rank_b');

save('C:\Users\anna_\OneDrive\Documents\MATLAB\PaulMillerLab\PaulMillerLab\MyDataSave\Set3\StateNum_d_April29_6stimulus.mat','StateNum_d');
save('C:\Users\anna_\OneDrive\Documents\MATLAB\PaulMillerLab\PaulMillerLab\MyDataSave\Set3\StateNum_April29_6stimulus.mat','StateNum');
save('C:\Users\anna_\OneDrive\Documents\MATLAB\PaulMillerLab\PaulMillerLab\MyDataSave\Set3\StateNum_f_April29_6stimulus.mat','StateNum_f');
save('C:\Users\anna_\OneDrive\Documents\MATLAB\PaulMillerLab\PaulMillerLab\MyDataSave\Set3\StateNum_b_April29_6stimulus.mat','StateNum_b');


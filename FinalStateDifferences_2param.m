%W_e0_val = 50:5:100; %for the first set
W_e0_val = 0:5:200;
W_ee_max_val = 0:0.1:2; 
W_ei_val = 0.665;
W_ie_val = -540;
Iapp_ratio = 2;

final_state = zeros(101, 64, length(W_e0_val), length(W_ee_max_val));
final_state_d = zeros(size(final_state));
final_state_f = zeros(size(final_state));
final_state_b = zeros(size(final_state));
disp("Started Running");

%addAttachedFiles(gcp, {'make_Iapp.m'});

parfor j = 1:length(W_e0_val)
    state_j = zeros(101, 64, length(W_ee_max_val));
    state_j_d = zeros(size(state_j));
    state_j_f = zeros(size(state_j));
    state_j_b = zeros(size(state_j));

    for k = 1:length(W_ee_max_val)
        p = make_params("W_e0",W_e0_val(j),"W_ee_max",W_ee_max_val(k),"W_ei",W_ei_val,"W_ie",W_ie_val);
        seq = generate_sequences(p,'permutations');
        %disp ("Iteration " + k);
        for count = 1: 64
            [Iapp, on_time, off_time] = make_Iapp(p,seq(count,:));
            Iapp = Iapp * Iapp_ratio;

            [r, s] = run_network_noDepression(p,Iapp,'silent','yes');
            state_j(:, count, k) = r(:, end);

            [r_d, s] = run_network(p,Iapp,'silent','yes');
            state_j_d(:, count, k) = r_d(:, end);

            [r_f, s] = run_network_onlyFacilitation(p,Iapp,'silent','yes');
            state_j_f(:, count, k) = r_f(:, end);

            [r_b, s] = run_network_facilitation(p,Iapp,'silent','yes');
            state_j_b(:, count, k) = r_b(:, end);
        end

        %disp(k)
        thresh = 20;
        state_j(:, :, k) = BinaryConvert(state_j(:, :, k),thresh);
        state_j_d(:, :, k) = BinaryConvert(state_j_d(:, :, k),thresh);
        state_j_f(:, :, k) = BinaryConvert(state_j_f(:, :, k),thresh);
        state_j_b(:, :, k) = BinaryConvert(state_j_b(:, :, k),thresh);
    end

    disp ("End of k " + j)
    final_state(:, :, j, :) = state_j;
    final_state_d(:, :, j, :) = state_j_d;
    final_state_f(:, :, j, :) = state_j_f;
    final_state_b(:, :, j, :) = state_j_b;
end

%save('/content/drive/MyDrive/MyDataSave/num_types_6stimulus.mat','num_types');
%save('/content/drive/MyDrive/MyDataSave/num_types_d_6stimulus.mat','num_types_d');
%save('/content/drive/MyDrive/MyDataSave/num_types_f_6stimulus.mat','num_types_f');
%save('/content/drive/MyDrive/MyDataSave/num_types_b_6stimulus.mat','num_types_b');

save('C:\Users\anna_\OneDrive\Documents\MATLAB\PaulMillerLab\PaulMillerLab\MyDataSave\Set3\Set3_3\final_state_6stimulus.mat','final_state');
save('C:\Users\anna_\OneDrive\Documents\MATLAB\PaulMillerLab\PaulMillerLab\MyDataSave\Set3\Set3_3\final_state_d_6stimulus.mat','final_state_d');
save('C:\Users\anna_\OneDrive\Documents\MATLAB\PaulMillerLab\PaulMillerLab\MyDataSave\Set3\Set3_3\final_state_f_6stimulus.mat','final_state_f');
save('C:\Users\anna_\OneDrive\Documents\MATLAB\PaulMillerLab\PaulMillerLab\MyDataSave\Set3\Set3_3\final_state_b_6stimulus.mat','final_state_b');



%% data conversion

[m,n,x,y] = size(final_state);
num_types = zeros(size(x,y));
num_types_d = size(num_types);
num_types_f = size(num_types);
num_types_b = size(num_types);

for i = 1:x
    for j = 1:y
        unique_column = count_unique_column_types(final_state(:,:,i,j));
        num_types(i,j) = unique_column;

        unique_column_d = count_unique_column_types(final_state_d(:,:,i,j));
        num_types_d(i,j) = unique_column_d;

        unique_column_f = count_unique_column_types(final_state_f(:,:,i,j));
        num_types_f(i,j) = unique_column_f;

        unique_column_b = count_unique_column_types(final_state_b(:,:,i,j));
        num_types_b(i,j) = unique_column_b;
    end
end

%% plotting
figure;
subplot (2,2,1)
imagesc(num_types);
colorbar; 
%title("a)");
xlabel("W ee max");
ylabel("W e0");
colorbar;
caxis([0 64]);

yt = get(gca, 'YTick'); 
yt = linspace(1, 41,5);                        % Original 'XTick' Values
ytlbl = linspace(0, 200, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 
%ylim([0.5, 10.5]);          % Ensure XTicks extend to the edges of the plot

xt = get(gca, 'XTick'); 
xt = linspace(1, 21,5);                         % Original 'XTick' Values
xtlbl = linspace(0, 2, numel(xt));                     % New 'XTickLabel' Vector
set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XTickLabelRotation',40)
%xlim([0.5, 20.5]);          % Ensure XTicks extend to the edges of the plot

subplot (2,2,2)
imagesc(num_types_f);
colorbar; 
%title("b)");
xlabel("W ee max");
ylabel("W e0");
colorbar;
caxis([0 64]);

yt = get(gca, 'YTick'); 
yt = linspace(1, 41,5);                        % Original 'XTick' Values
ytlbl = linspace(0, 200, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 
%ylim([0.5, 10.5]);          % Ensure XTicks extend to the edges of the plot

xt = get(gca, 'XTick'); 
xt = linspace(1, 21,5);                         % Original 'XTick' Values
xtlbl = linspace(0, 2, numel(xt));                     % New 'XTickLabel' Vector
set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XTickLabelRotation',40)
%xlim([0.5, 20.5]);          % Ensure XTicks extend to the edges of the plot


subplot (2,2,3)
imagesc(num_types_d);
colorbar; 
%title("c)");
xlabel("W ee max");
ylabel("W e0");
colorbar;
caxis([0 64]);

yt = get(gca, 'YTick'); 
yt = linspace(1, 41,5);                        % Original 'XTick' Values
ytlbl = linspace(0, 200, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 
%ylim([0.5, 10.5]);          % Ensure XTicks extend to the edges of the plot

xt = get(gca, 'XTick'); 
xt = linspace(1, 21,5);                         % Original 'XTick' Values
xtlbl = linspace(0, 2, numel(xt));                     % New 'XTickLabel' Vector
set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XTickLabelRotation',40)
%xlim([0.5, 20.5]);          % Ensure XTicks extend to the edges of the plot


subplot (2,2,4)
imagesc(num_types_b);
colorbar; 
%title("d)");
xlabel("W ee max");
ylabel("W e0");
colorbar;
caxis([0 64]);

yt = get(gca, 'YTick'); 
yt = linspace(1, 41,5);                        % Original 'XTick' Values
ytlbl = linspace(0, 200, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 
%ylim([0.5, 10.5]);          % Ensure XTicks extend to the edges of the plot

xt = get(gca, 'XTick'); 
xt = linspace(1, 21,5);                         % Original 'XTick' Values
xtlbl = linspace(0, 2, numel(xt));                     % New 'XTickLabel' Vector
set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XTickLabelRotation',40)
%xlim([0.5, 20.5]);          % Ensure XTicks extend to the edges of the plot

subplot(2,2,1);
text(-10,1,'(a)','FontSize',14);
subplot(2,2,2);
text(-10,1,'(b)','FontSize',14);
subplot(2,2,3);
text(-10,1,'(c)','FontSize',14);
subplot(2,2,4);
text(-10,1,'(d)','FontSize',14);


%% log plot
log_num_types = log(num_types);
log_num_types_f = log(num_types_f);
log_num_types_d = log(num_types_d);
log_num_types_b = log(num_types_b);
%%

figure;
subplot (2,2,1)
imagesc(log_num_types);
colorbar; 
%title("a)");
xlabel("W ee max");
ylabel("W e0");
% Create a colorbar
cb = colorbar;
ticks = linspace(0, 4.1589, 2); % Assuming 5 ticks
tickLabels = cellstr(num2str((0:64:64)', '%d')); % Assuming 5 ticks, incrementing by 64
cb.Ticks = ticks;
cb.TickLabels = tickLabels;

caxis([0 4.1589]);

yt = get(gca, 'YTick'); 
yt = linspace(1, 41,5);                        % Original 'XTick' Values
ytlbl = linspace(0, 200, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 
%ylim([0.5, 10.5]);          % Ensure XTicks extend to the edges of the plot

xt = get(gca, 'XTick'); 
xt = linspace(1, 21,5);                         % Original 'XTick' Values
xtlbl = linspace(0, 2, numel(xt));                     % New 'XTickLabel' Vector
set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XTickLabelRotation',40)
%xlim([0.5, 20.5]);          % Ensure XTicks extend to the edges of the plot

subplot (2,2,2)
imagesc(log_num_types_f);
colorbar; 
%title("b)");
xlabel("W ee max");
ylabel("W e0");

cb = colorbar;
ticks = linspace(0, 4.1589, 2); % Assuming 5 ticks
tickLabels = cellstr(num2str((0:64:64)', '%d')); % Assuming 5 ticks, incrementing by 64
cb.Ticks = ticks;
cb.TickLabels = tickLabels;

caxis([0 4.1589]);

yt = get(gca, 'YTick'); 
yt = linspace(1, 41,5);                        % Original 'XTick' Values
ytlbl = linspace(0, 200, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 
%ylim([0.5, 10.5]);          % Ensure XTicks extend to the edges of the plot

xt = get(gca, 'XTick'); 
xt = linspace(1, 21,5);                         % Original 'XTick' Values
xtlbl = linspace(0, 2, numel(xt));                     % New 'XTickLabel' Vector
set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XTickLabelRotation',40)
%xlim([0.5, 20.5]);          % Ensure XTicks extend to the edges of the plot


subplot (2,2,3)
imagesc(log_num_types_d);
colorbar; 
%title("c)");
xlabel("W ee max");
ylabel("W e0");

cb = colorbar;
ticks = linspace(0, 4.1589, 2); % Assuming 5 ticks
tickLabels = cellstr(num2str((0:64:64)', '%d')); % Assuming 5 ticks, incrementing by 64
cb.Ticks = ticks;
cb.TickLabels = tickLabels;

caxis([0 4.1589]);

yt = get(gca, 'YTick'); 
yt = linspace(1, 41,5);                        % Original 'XTick' Values
ytlbl = linspace(0, 200, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 
%ylim([0.5, 10.5]);          % Ensure XTicks extend to the edges of the plot

xt = get(gca, 'XTick'); 
xt = linspace(1, 21,5);                         % Original 'XTick' Values
xtlbl = linspace(0, 2, numel(xt));                     % New 'XTickLabel' Vector
set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XTickLabelRotation',40)
%xlim([0.5, 20.5]);          % Ensure XTicks extend to the edges of the plot


subplot (2,2,4)
imagesc(log_num_types_b);
colorbar; 
%title("d)");
xlabel("W ee max");
ylabel("W e0");

cb = colorbar;
ticks = linspace(0, 4.1589, 2); % Assuming 5 ticks
tickLabels = cellstr(num2str((0:64:64)', '%d')); % Assuming 5 ticks, incrementing by 64
cb.Ticks = ticks;
cb.TickLabels = tickLabels;


caxis([0 4.1589]);

yt = get(gca, 'YTick'); 
yt = linspace(1, 41,5);                        % Original 'XTick' Values
ytlbl = linspace(0, 200, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 
%ylim([0.5, 10.5]);          % Ensure XTicks extend to the edges of the plot

xt = get(gca, 'XTick'); 
xt = linspace(1, 21,5);                         % Original 'XTick' Values
xtlbl = linspace(0, 2, numel(xt));                     % New 'XTickLabel' Vector
set(gca, 'XTick',xt, 'XTickLabel',xtlbl, 'XTickLabelRotation',40)
%xlim([0.5, 20.5]);          % Ensure XTicks extend to the edges of the plot

subplot(2,2,1);
text(-10,1,'(a)','FontSize',14);
subplot(2,2,2);
text(-10,1,'(b)','FontSize',14);
subplot(2,2,3);
text(-10,1,'(c)','FontSize',14);
subplot(2,2,4);
text(-10,1,'(d)','FontSize',14);

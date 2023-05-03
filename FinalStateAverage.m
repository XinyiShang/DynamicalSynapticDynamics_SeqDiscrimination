% Set the folder path where the data is saved
folder_path = 'MyDataSave\Set2';

% Set the number of datasets to load
num_datasets = 10;

% Initialize an empty matrix to store the data from all datasets
average = zeros(31,21,num_datasets);
average_d = zeros(31,21,num_datasets);
average_f = zeros(31,21,num_datasets);
average_b = zeros(31,21,num_datasets);

% Load each dataset and concatenate their data to the all_data matrix
for k = 1:num_datasets
    % Construct the full file path for the i-th dataset
    dataset_path = fullfile(folder_path, ['Set2_', num2str(k)], 'final_state_6stimulus.mat');
    dataset_path_d = fullfile(folder_path, ['Set2_', num2str(k)], 'final_state_d_6stimulus.mat');
    dataset_path_f = fullfile(folder_path, ['Set2_', num2str(k)], 'final_state_f_6stimulus.mat');
    dataset_path_b = fullfile(folder_path, ['Set2_', num2str(k)], 'final_state_b_6stimulus.mat');

    
    % Load the data from the i-th dataset
    load(dataset_path, 'final_state');
    load(dataset_path_d, 'final_state_d');
    load(dataset_path_f, 'final_state_f');
    load(dataset_path_b, 'final_state_b');
    
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

    average(:,:,k) = num_types;
    average_d(:,:,k) = num_types_d;
    average_f(:,:,k) = num_types_f;
    average_b(:,:,k) = num_types_b;

end

% Calculate the average of all datasets
average = mean(average, 3);
average_d = mean(average_d, 3);
average_f = mean(average_f, 3);
average_b = mean(average_b, 3);

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
yt = linspace(0.5, 30.5,5);                        % Original 'XTick' Values
ytlbl = linspace(50, 200, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 
%ylim([0.5, 10.5]);          % Ensure XTicks extend to the edges of the plot

xt = get(gca, 'XTick'); 
xt = linspace(0.5, 20.5,5);                         % Original 'XTick' Values
xtlbl = linspace(0, 1, numel(xt));                     % New 'XTickLabel' Vector
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
yt = linspace(0.5, 30.5,5);                        % Original 'XTick' Values
ytlbl = linspace(50, 200, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 
%ylim([0.5, 10.5]);          % Ensure XTicks extend to the edges of the plot

xt = get(gca, 'XTick'); 
xt = linspace(0.5, 20.5,5);                         % Original 'XTick' Values
xtlbl = linspace(0, 1, numel(xt));                     % New 'XTickLabel' Vector
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
yt = linspace(0.5, 30.5,5);                        % Original 'XTick' Values
ytlbl = linspace(50, 200, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 
%ylim([0.5, 10.5]);          % Ensure XTicks extend to the edges of the plot

xt = get(gca, 'XTick'); 
xt = linspace(0.5, 20.5,5);                         % Original 'XTick' Values
xtlbl = linspace(0, 1, numel(xt));                     % New 'XTickLabel' Vector
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
yt = linspace(0.5, 30.5,5);                        % Original 'XTick' Values
ytlbl = linspace(50, 200, numel(yt));                     % New 'XTickLabel' Vector
set(gca, 'YTick',yt, 'YTickLabel',ytlbl, 'YTickLabelRotation',0) 
%ylim([0.5, 10.5]);          % Ensure XTicks extend to the edges of the plot

xt = get(gca, 'XTick'); 
xt = linspace(0.5, 20.5,5);                         % Original 'XTick' Values
xtlbl = linspace(0, 1, numel(xt));                     % New 'XTickLabel' Vector
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

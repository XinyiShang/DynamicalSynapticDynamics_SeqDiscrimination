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

%% find the maximum
[row, col] = find(ismember(num_types, max(num_types(:))));
[row_d, col_d] = find(ismember(num_types_d, max(num_types_d(:))));
[row_f, col_f] = find(ismember(num_types_f, max(num_types_f(:))));
[row_b, col_b] = find(ismember(num_types_b, max(num_types_b(:))));



%% for the network with facilitation, retrive the final state table
state = final_state(:,:,4,8);
%state = final_state_f (:,:,12,10);
maxState = max(max(num_types));

%% get the seq # of the same final state
%num_types = count_unique_column_types(state)
matrix = state;
matrix = matrix';

% Convert each row vector to a character vector
char_matrix = char('0' + matrix.').';

% Convert the matrix of rows to a cell array
row_cells = mat2cell(char_matrix, ones(1, size(char_matrix, 1)), size(char_matrix, 2));

[unique_rows, ~, unique_indices] = unique(row_cells);

%% concatinate unique_indicies and seq

label = [seq,unique_indices];
%% feature determination -- what determines the differences 
%Considering 3 factors: # of l/r cue, starting cue, ending cue

%% considering # of l/r cue
%convert the seq to # of l cue
seq_Lcue = sum(seq,2) - 6;
label_Lcue = [seq_Lcue, unique_indices];

data = label_Lcue;
% Define the range of datapoints and labels
datapoint_range = 0:6;
label_range = 1:maxState;

% Initialize the table with zeros
table_data = zeros(length(datapoint_range), length(label_range));

% Loop through each datapoint and label to count the number of datapoints in each group
for i = 1:length(datapoint_range)
    for j = 1:length(label_range)
        table_data(i,j) = sum((data(:,1) == datapoint_range(i)) & (data(:,2) == label_range(j)));
    end
end

% Display the table
%disp(table_data)

%% Consider the initial cue
%{
%convert the seq to # of l cue
seq_Lcue = seq(:,1);
label_Lcue = [seq_Lcue, unique_indices];

data = label_Lcue;
% Define the range of datapoints and labels
datapoint_range = 1:2;
label_range = 1:maxState;

% Initialize the table with zeros
table_data_ini = zeros(length(datapoint_range), length(label_range));

% Loop through each datapoint and label to count the number of datapoints in each group
for i = 1:length(datapoint_range)
    for j = 1:length(label_range)
        table_data_ini(i,j) = sum((data(:,1) == datapoint_range(i)) & (data(:,2) == label_range(j)));
    end
end

% Display the table
%disp(table_data);

%% Consider the final cue

%convert the seq to # of l cue
seq_Lcue = seq(:,6);
label_Lcue = [seq_Lcue, unique_indices];

data = label_Lcue;
% Define the range of datapoints and labels
datapoint_range = 1:2;
label_range = 1:maxState;

% Initialize the table with zeros
table_data_final = zeros(length(datapoint_range), length(label_range));

% Loop through each datapoint and label to count the number of datapoints in each group
for i = 1:length(datapoint_range)
    for j = 1:length(label_range)
        table_data_final(i,j) = sum((data(:,1) == datapoint_range(i)) & (data(:,2) == label_range(j)));
    end
end

% Display the table
%disp(table_data_final);
%}

%% Loop over cues
% Loop through each cue in the sequence
for cue_num = 1:6
    % Convert the cue to the number of left cues
    seq_Lcue = seq(:,cue_num);
    label_Lcue = [seq_Lcue, unique_indices];

    data = label_Lcue;
    % Define the range of datapoints and labels
    datapoint_range = 1:2;
    label_range = 1:maxState;

    % Initialize the table with zeros
    table_data_cue{cue_num} = zeros(length(datapoint_range), length(label_range));

    % Loop through each datapoint and label to count the number of datapoints in each group
    for i = 1:length(datapoint_range)
        for j = 1:length(label_range)
            table_data_cue{cue_num}(i,j) = sum((data(:,1) == datapoint_range(i)) & (data(:,2) == label_range(j)));
        end
    end
    
    % Display the table for the current cue
    disp(['Table for cue ' num2str(cue_num) ':']);
    disp(table_data_cue{cue_num});
end

%% plotting
figure;
%figure('Position',[0 0 800 400]);

% Subplot 1
subplot(4,2,1.5)
h = heatmap(table_data, 'Colormap', parula, 'ColorLimits', [0 max(max(table_data))], 'XLabel', 'Final State ID', 'YLabel', 'Number of Left Cues');
title("A");
yticklabels = {'0', '1', '2', '3', '4', '5', '6'};
hAx = gca;
hAx.YDisplayLabels = yticklabels;

% Loop through each cue in the sequence (except for the first and last)
for cue_num = 1:6
    % Plot the current subplot
    subplot(4,2,cue_num+2);
    %imagesc(table_data_cue{cue_num});
    h = heatmap(table_data_cue{cue_num}, 'Colormap', parula, 'ColorLimits', [0 max(max(table_data_cue{cue_num}))], 'XLabel', 'Final State ID', 'YLabel', 'Signal');
    yticklabels = {'R', 'L'};
    hAx = gca;
    hAx.YDisplayLabels = yticklabels;
    colorbar;
    title(sprintf('%s) Cue %d', char('A'+cue_num), cue_num));
    %xlabel('Firing State');
    %ylabel('Left Cues');
end


%{
% Subplot 2
subplot(2,2,2)
heatmap(table_data_ini, 'Colormap', parula, 'ColorLimits', [0 max(max(table_data_ini))], 'XLabel', 'Final State ID', 'YLabel', 'First signal');
title("B");
yticklabels = {'R', 'L'};
hAx = gca;
hAx.YDisplayLabels = yticklabels;
% Define the figure

% Subplot 3
subplot(2,2,3)
heatmap(table_data_final, 'Colormap', parula, 'ColorLimits', [0 max(max(table_data_final))], 'XLabel', 'Final State ID', 'YLabel', 'Last signal');
title("C");
yticklabels = {'R', 'L'};
hAx = gca;
hAx.YDisplayLabels = yticklabels;
%}

%%
% Get the unique final state IDs
final_state_ids = unique(unique_indices);

% Initialize the table with empty cells
table_data = cell(length(final_state_ids), length(final_state_ids));

% Loop through each sequence and assign it to the corresponding grid
for i = 1:size(seq, 1)
    final_state_id = unique_indices(i);
    table_data{final_state_id, final_state_id} = [table_data{final_state_id, final_state_id}; seq(i, :)];
end

% Display the table
disp('Final State Sequence Table:');
disp(table_data);

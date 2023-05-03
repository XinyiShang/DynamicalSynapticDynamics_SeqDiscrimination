%% similarity matrix
state = final_state_d (:,:,12,5);
input = state;
seq = input';
% Compute similarity matrix using hamming distance
simMat = zeros(64,64);
for i = 1:64
    for j = i:64
        d = sum(seq(i,:) ~= seq(j,:)); % hamming distance
        simMat(i,j) = d;
        simMat(j,i) = d;
    end
end

% Display similarity matrix
figure;
imagesc(simMat);
colorbar;
title('Similarity matrix based on Hamming distance');
xlabel('Sequence number');
ylabel('Sequence number');

%% PCA for similarity matrix

% load similarity matrix into variable 'similarity_matrix'
% similarity_matrix should be a 64x64 matrix

% perform PCA on the similarity matrix
[coeff, score, latent] = pca(simMat);

% plot scree plot to see how much variance each principal component explains
figure;
plot(latent, 'ro-', 'LineWidth', 2);
title('Scree Plot');
xlabel('Principal Component');
ylabel('Variance Explained (%)');
grid on;

% plot biplot to visualize principal components and relationships between the 64 sequences
figure;
biplot(coeff(:,1:2), 'Scores', score(:,1:2), 'VarLabels', cellstr(num2str([1:64]')));
title('Biplot of Principal Components 1 and 2');
xlabel('Principal Component 1');
ylabel('Principal Component 2');

%% PCA for data
% Load your matrix data into the variable 'data'
% data should be a 101 x 64 matrix
data = input;
% Calculate the mean of each column
colMean = mean(data, 1);

% Subtract the mean from each data point
data = bsxfun(@minus, data, colMean);

% Calculate the covariance matrix
covariance = cov(data);

% Perform PCA on the covariance matrix
[coeff, score, latent] = pca(covariance);

% Plot the principal component variances
figure;
pareto(latent);

% Plot the scores for the first two principal components
figure;
scatter(score(:,1), score(:,2));

% Get the loadings for the first two principal components
loadings = coeff(:,1:2);

%% correlation
p = make_params();
seq = generate_sequences(p,'permutations');
corr_coeffs = corr(seq, input);
heatmap(corr_coeffs);

%% herichical clustering
% Load your 5 datasets into a cell array
data = cell(1, 2);
data{1} = final_state_d(:,:,12,5);
data{2} = final_state_d (:,:,8,10);
%data{3} = final_state_d (:,:,11,10);
%data{4} = final_state_d (:,:,10,10);
%data{5} = final_state_d (:,:,10,9);

% Compute the similarity matrix for each dataset
sim_matrices = cell(1, 2);
for i = 1:2
    sim_matrices{i} = pdist(data{i}', 'correlation');
end

% Compute the linkage matrix for each dataset using Ward linkage method
linkage_matrices = cell(1, 2);
for i = 1:2
    linkage_matrices{i} = linkage(sim_matrices{i}, 'ward');
end

% Plot the dendrograms for each dataset
for i = 1:2
    figure();
    dendrogram(linkage_matrices{i});
    title(['Dendrogram for Dataset ', num2str(i)]);
end

%% Similarity then herichical clustering
% Load the data into a cell array
%{
data = cell(1, 5);

data{1} = final_state_d(:,:,9,13)';
data{2} = final_state_d(:,:,10,11)';
data{3} = final_state_d(:,:,11,10)';
data{4} = final_state_d(:,:,10,10)';
data{5} = final_state_d(:,:,10,9)';
%}

data = cell(1, 2);
data{1} = final_state_d(:,:,12,5)';
data{2} = final_state_d(:,:,8,10)';
%data{1} = final_state_b(:,:,10,5)';
%data{2} = final_state_b(:,:,10,6)';
%data{3} = final_state_b(:,:,10,7)';
%data{4} = final_state_b(:,:,11,7)';
%data{5} = final_state_b(:,:,11,8)';
%data{6} = final_state_b(:,:,10,11)';

% Initialize the similarity matrix
num_datasets = length(data);
num_sequences = size(data{1}, 1);
similarity_matrix = zeros(num_sequences, num_sequences);

% Compute the similarity matrix for each dataset and sum them up
for i = 1:num_datasets
    % Compute the similarity matrix for the current dataset
    current_data = data{i};
    current_similarity = pdist(current_data);
    current_similarity = squareform(current_similarity);
    
    % Add the current similarity matrix to the overall similarity matrix
    similarity_matrix = similarity_matrix + current_similarity;
end

% Average out the similarity matrix
similarity_matrix = similarity_matrix / num_datasets;
figure;
xlabels = cellstr(num2str(seq));

imagesc(similarity_matrix)
xticks(1:length(xlabels));
xtickangle(45)
xticklabels(xlabels);
set(gca, 'FontSize', 7)
title('Similarity Matrix')
colorbar;
c = colorbar;
c.Label.String = 'Distance';

% Perform hierarchical clustering
% Compute linkage and plot dendrogram
labels = cellstr(num2str(seq));
Z = linkage(similarity_matrix);
figure();
subplot(1,2,1)
[dendro,~,perm] = dendrogram(Z,0,'Orientation','left','Labels',labels);
title('A) Hierarchical Clustering')
set(dendro,'LineWidth',1.5);
set(gca, 'FontSize', 7)

similarity_matrix = similarity_matrix(perm, perm);
similarity_matrix = similarity_matrix(end:-1:1, :);
similarity_matrix = fliplr(similarity_matrix);
% Plot similarity matrix
subplot(1,2,2)
imagesc(similarity_matrix)
colorbar
c = colorbar;
c.Label.String = 'Distance';
%colormap(jet)
%xticks(1:64)
%xticklabels(labels)
%xtickangle(90)
%yticks(1:64)
%yticklabels(labels)
set(gca,'xticklabels',[]);
set(gca,'yticklabels',[]);
title('B) Similarity Matrix')
set(gca, 'FontSize', 7)

%%
figure;
% Plot the dendrogram
labels = cellstr(num2str(seq));
dendrogram(Z);

%% kmeans
% calculate the average similarity matrix from the five datasets
similarity_matrix_avg = similarity_matrix;

% perform k-means clustering
num_clusters = 2;
[cluster_idx, centroid] = kmeans(similarity_matrix_avg, num_clusters);

% plot the clustered similarity matrix
figure;
imagesc(similarity_matrix_avg);
colormap jet;
colorbar;
title('Clustered Similarity Matrix');
xlabel('Sequence Number');
ylabel('Sequence Number');

% mark the cluster boundaries
hold on;
boundary_idx = find(diff(cluster_idx));
for i = 1:length(boundary_idx)
    plot([boundary_idx(i), boundary_idx(i)], ylim, 'k', 'LineWidth', 2);
end

%%
% Compute hierarchical clustering and extract cluster labels
Y = pdist(similarity_matrix);
Z = linkage(Y);
T = cluster(Z,'MaxClust',2);
[coeff,score,latent] = pca(similarity_matrix_avg);
X = score(:,1:2);

% Create scatter plot
figure;
gscatter(X(:,1), X(:,2), T);
title('Scatter Plot Grouping Similar Results Together');
xlabel('Principle Component 1');
ylabel('Principle Component 2');

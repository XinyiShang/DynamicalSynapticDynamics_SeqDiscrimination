function num_types = count_unique_column_types(matrix)
% COUNT_UNIQUE_COLUMN_TYPES  Counts the number of unique column types in a binary matrix.
%
% Inputs:
%   matrix: binary matrix of size MxN, where M is the number of rows and N is the number of columns
%
% Outputs:
%   num_types: scalar integer representing the number of unique column types in the matrix

matrix = matrix';

% Convert each row vector to a character vector
char_matrix = char('0' + matrix.').';

% Convert the matrix of rows to a cell array
row_cells = mat2cell(char_matrix, ones(1, size(char_matrix, 1)), size(char_matrix, 2));

% Find the unique rows in the cell array
[unique_rows, ~, unique_indices] = unique(row_cells);

% Count the number of unique column types
num_types = size(unique_rows, 1);

end

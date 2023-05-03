function [target, seqsToTrain] = generate_perceptron_target(seqs,input)
% This function generates target outputs and training data for a perceptron model

% Compute the length of each sequence
seqLength = size(seqs, 2);

% Initialize the target outputs and training data
target = [];
seqsToTrain = [];

% Generate the target outputs and training data for each sequence
for i = 1:size(seqs, 1)
    % Add the target output for this sequence
    if input == 1
        target = [target, ones(1, seqLength)];
    else
        target = [target, -ones(1, seqLength)];
    end
    
    % Add the training data for this sequence
    seqsToTrain = [seqsToTrain; seqs(i, :)];
end
end


end
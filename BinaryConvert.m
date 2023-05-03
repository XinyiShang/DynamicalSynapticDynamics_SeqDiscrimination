function [seq] = BinaryConvert(input,thresh)

seq = input; 
seq (input < thresh) = 0;
seq (input > thresh) = 1;


end
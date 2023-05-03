p = make_params('sequence_length',4,"W_e0",41,"W_ee_max",1.58,"W_ei",1.475,"W_ie",-250);
%p = make_params('sequence_length',4,"W_e0",44,"W_ee_max",0.3,"W_ei",2.7,"W_ie",-8);
%p = make_params('sequence_length',4,"W_e0",23,"W_ee_max",0.1,"W_ei",1.5,"W_ie",-30);

%p = make_params('sequence_length',4);
seq = generate_sequences(p,'permutations');
N = 1;
NumNeuron = 100;
Threshold = 20;
state = zeros(length(seq),NumNeuron);
for j = 1:N
    for i = 1:16
        [Iapp,on_time, off_time] = make_Iapp(p,seq(i,:));
        %[Iapp,on_time,off_time] = make_Iapp(p,seq(i,:));

        [r,s] = run_network_onlyFacilitation(p,Iapp*3,'silent','yes'); %network without depression and facilitation
        %[r,s] = run_network_noDepression(p,Iapp,'silent','yes');
        r(r<20) = 0;
        r(r>=20) = 1;
        state(i,:)= r(1:100,end);
    end
end

%%
figure(1)
%names = num2str(seq)
Y = pdist(state);
Z = linkage(Y);
labels = cellstr(num2str(seq));
dendrogram(Z,'Labels', labels);
%#xlabel('sequence #')
title('Hierarchal Clustering of the network with facilitation');
set(gca,'YTick', [] )%,'xticklabels',names)

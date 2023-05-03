%p = make_params('sequence_length',4,"W_e0",44,"W_ee_max",1.58,"W_ei",1.475,"W_ie",-250);
%p = make_params('sequence_length',4,"W_e0",44,"W_ee_max",0.3,"W_ei",2.7,"W_ie",-8);

p = make_params('sequence_length',4);
seq = generate_sequences(p,'permutations');
      
N = 10;
state = zeros(N,length(seq));
for j = 1:N
    for i = 1:16
        %[Iapp,on_time,off_time] = make_Iapp_amplitudeChange(p,seq(1,:),seq(i,:));
        [Iapp,on_time,off_time] = make_Iapp(p,seq(i,:));

        [r,s] = run_network_facilitation(p,Iapp,'silent','yes'); %network w/ STSP
        %[r,s] = run_network_noDepression(p,Iapp,'silent','yes');
        state(j,i) = sum(countStates(r,off_time));
    end
end

state_T = state';
%%
figure(2)
imagesc(state_T)
colorbar
xlabel('Experiment #')
ylabel('sequence #')
title('Post-sequence firing unit # in the network with depression & facilitation');

figure(3)
Y = pdist(state_T);
Z = linkage(Y);
dendrogram(Z);
xlabel('sequence #')
title('Hierarchal Clustering of the network with depression & facilitation');
set(gca,'YTick', [])
%[r_b,D_b,s_b,F] = run_network_facilitation(p,Iapp,'silent','yes'); %network with facilitation and depression
%[r_d,D_d,s_d] = run_network(p,Iapp,'silent','yes'); %network with depression only
%[r_f,D_f,s_f] = run_network_onlyFacilitation(p,Iapp,'silent','yes'); %network with facilitation only
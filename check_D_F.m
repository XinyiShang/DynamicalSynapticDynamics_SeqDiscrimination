
W_e0_val = 100;
W_ee_max_val = 0.2; 
W_ei_val = 0.665;
W_ie_val = -540;
Iapp_ratio = 2; 

p = make_params("W_e0",W_e0_val,"W_ee_max",W_ee_max_val,"W_ei",W_ei_val,"W_ie",W_ie_val);
%p = make_params();
seq = generate_sequences(p,'permutations');
        %disp ("Iteration " + k);
        
[Iapp, on_time, off_time] = make_Iapp(p,[1 2 1 2 1 2]);
Iapp = Iapp * Iapp_ratio; 

%[r, s] = run_network_noDepression(p,Iapp,'silent','no');

%[r_d, D,s] = run_network(p,Iapp,'silent','no');
%state_j_d(:, count, k) = r_d(:, end);

%[r_f, s, F] = run_network_onlyFacilitation(p,Iapp,'silent','no');
%state_j_f(:, count, k) = r_f(:, end);
 
[r_b, D, s, F] = run_network_facilitation(p,Iapp,'silent','no');
%state_j_b(:, count, k) = r_b(:, end);
state = countStates(r_b,off_time);
stateNum_test = sum(state)

%% plotting
figure
subplot(1,2,1)
imagesc(r)
title("firing rate (r)")
ylabel("Neuron #")
xlabel("Time (s)")
xticks_original = get(gca, 'XTick');
xticks_new = xticks_original / 1000;
set(gca, 'XTick', xticks_original, 'XTickLabel', xticks_new)
colorbar;

subplot(1,2,2)
imagesc(s)
title("gating variable (s)")
ylabel("Neuron #")
xlabel("Time (s)")
xticks_original = get(gca, 'XTick');
xticks_new = xticks_original / 1000;
set(gca, 'XTick', xticks_original, 'XTickLabel', xticks_new)
colorbar;
sgtitle("Network without facilitation and depression")
%% plotting
figure;
subplot (2,2,1.5)
imagesc(r_f)
title("firing rate (r)")
ylabel("Neuron #")
xlabel("Time (s)")
xticks_original = get(gca, 'XTick');
xticks_new = xticks_original / 1000;
set(gca, 'XTick', xticks_original, 'XTickLabel', xticks_new)
colorbar;

subplot(2,2,3)
imagesc(s)
title("gating variable (s)")
ylabel("Neuron #")
xlabel("Time (s)")
xticks_original = get(gca, 'XTick');
xticks_new = xticks_original / 1000;
set(gca, 'XTick', xticks_original, 'XTickLabel', xticks_new)
colorbar;


subplot(2,2,4)
imagesc(F)
title("facilitation variable (F)")
ylabel("Neuron #")
xlabel("Time (s)")
xticks_original = get(gca, 'XTick');
xticks_new = xticks_original / 1000;
set(gca, 'XTick', xticks_original, 'XTickLabel', xticks_new)
colorbar;

sgtitle("Network with facilitation")

%% plotting 
figure;
subplot (2,2,1)
imagesc(r_b)
title("firing rate (r)")
ylabel("Neuron #")
xlabel("Time (s)")
xticks_original = get(gca, 'XTick');
xticks_new = xticks_original / 1000;
set(gca, 'XTick', xticks_original, 'XTickLabel', xticks_new)
colorbar;

subplot (2,2,2)
imagesc(s)
title("gating variable (s)")
ylabel("Neuron #")
xlabel("Time (s)")
xticks_original = get(gca, 'XTick');
xticks_new = xticks_original / 1000;
set(gca, 'XTick', xticks_original, 'XTickLabel', xticks_new)
colorbar;


subplot(2,2,3)
imagesc(F)
title("facilitation variable (F)")
ylabel("Neuron #")
xlabel("Time (s)")
xticks_original = get(gca, 'XTick');
xticks_new = xticks_original / 1000;
set(gca, 'XTick', xticks_original, 'XTickLabel', xticks_new)
colorbar;

subplot(2,2,4)
imagesc(D)
title("depression variable (D)")
ylabel("Neuron #")
xlabel("Time (s)")
xticks_original = get(gca, 'XTick');
xticks_new = xticks_original / 1000;
set(gca, 'XTick', xticks_original, 'XTickLabel', xticks_new)
colorbar;

sgtitle("Network with depression and facilitation")


%% Make a line plot
figure;
subplot(5,1,1);
plot(r_b(30,:));    
ylabel("r")
xticks_original = get(gca, 'XTick');
xticks_new = xticks_original / 1000;
set(gca, 'XTick', xticks_original, 'XTickLabel', xticks_new)

subplot(5,1,2);
plot(s(30,:));
ylabel("S")
xticks_original = get(gca, 'XTick');
xticks_new = xticks_original / 1000;
set(gca, 'XTick', xticks_original, 'XTickLabel', xticks_new)


subplot(5,1,3);
plot(Iapp(30,:));
ylabel("Iapp")
xticks_original = get(gca, 'XTick');
xticks_new = xticks_original / 1000;
set(gca, 'XTick', xticks_original, 'XTickLabel', xticks_new)


subplot(5,1,4);
plot(F(30,:));
ylabel("F")
xticks_original = get(gca, 'XTick');
xticks_new = xticks_original / 1000;
set(gca, 'XTick', xticks_original, 'XTickLabel', xticks_new)

subplot(5,1,5);
plot(D(30,:));
ylabel("D")
xlabel("Time (s)")
xticks_original = get(gca, 'XTick');
xticks_new = xticks_original / 1000;
set(gca, 'XTick', xticks_original, 'XTickLabel', xticks_new)


sgtitle ("Network with facilitation and depression");



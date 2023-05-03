p = make_params("W_e0",100,"W_ee_max",0.5);
seq = generate_sequences(p,'permutations');
[Iapp, on_time, off_time] = make_Iapp(p,seq(1,:));
Iapp = Iapp * 2;

[r, s] = run_network_noDepression(p,Iapp,'silent','yes');
            

[r_d, s] = run_network(p,Iapp,'silent','yes');
         

[r_f, s] = run_network_onlyFacilitation(p,Iapp,'silent','yes');
            

[r_b, s] = run_network_facilitation(p,Iapp,'silent','yes');

figure;
subplot(2,2,1);
histogram(r);
%title("network without facilitation and depression");
xlabel('r(Hz)');
ylabel('number of firing rates');

subplot(2,2,2);
histogram(r_f);
%title("network with depression");
xlabel('r(Hz)');
ylabel('number of firing rates');

subplot(2,2,3);
histogram(r_d);
%title("network with facilitation");
xlabel('r(Hz)');
ylabel('number of firing rates');

subplot(2,2,4);
histogram(r_b);
%title("network with facilitation and depression");
xlabel('r(Hz)');
ylabel('number of firing rates');

%%
subplot(2,2,1);
text(-25,900000,'(a)','FontSize',14);
subplot(2,2,2);
text(-25,900000,'(b)','FontSize',14);
subplot(2,2,3);
text(-25,1150000,'(c)','FontSize',14);
subplot(2,2,4);
text(-25,900000,'(d)','FontSize',14);
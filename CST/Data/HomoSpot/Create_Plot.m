hold on

plot(Array1{:,1}, Array1{:,2},'Linewidth',1)
plot(Array2{:,1}, Array2{:,2},'Linewidth',1)
plot(Array3{:,1}, Array3{:,2},'Linewidth',1)
plot(Array4{:,1}, Array4{:,2},'Linewidth',1)
plot(Array5{:,1}, Array5{:,2},'Linewidth',1)
plot(Array6{:,1}, Array6{:,2},'Linewidth',2)



legend('1', '2', '3', '4', '5', '6')
xlim([0 11])
ylabel('B1 (arb)')
xlabel('h2 (cm)')



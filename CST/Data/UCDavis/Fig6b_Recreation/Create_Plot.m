hold on



plot(NoCopper{:,1}, NoCopper{:,2},'black', 'Linewidth',2)
plot(Cop0mm{:,1}, Cop0mm{:,2},'blue','Linewidth',2)
plot(Cop6mm{:,1}, Cop6mm{:,2},'red', 'Linewidth',2)
%plot(Cop12mm{:,1}, Cop12mm{:,2},'green', 'Linewidth',2)
xlim([-0.6 4])
ylabel('B1 (arb)')
xlabel('h2 (cm)')
legend('No Copper', '0 mm', '6 mm')
percent = (Cop0mm{201,2}-NoCopper{201,2})./NoCopper{201,2}*100

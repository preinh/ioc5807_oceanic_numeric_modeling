% Programa para calculo de derivadas por diferencas finitas
clear all; close all; clc

dx=0.1;
x=0:dx:pi;
f=sin(x);
deranalit=cos(x);deranalit=deranalit';
deranalit2=-sin(x);deranalit2=deranalit2';

jmax=size(x,2);
dfava=zeros(jmax,1);
dfret=zeros(jmax,1);
dfcen=zeros(jmax,1);
dfseg=zeros(jmax,1);

dfava(1:jmax-1)=(f(2:jmax) -   f(1:jmax-1)) / dx;
dfret(2:jmax)  =(f(2:jmax) -   f(1:jmax-1)) / dx;
dfcen(2:jmax-1)=(f(3:jmax) -   f(1:jmax-2)) / (2*dx);
dfseg(2:jmax-1)=(f(3:jmax) - 2*f(2:jmax-1) + f(1:jmax-2)) / (dx^2);

figure(1)
plot(x,f,'LineWidth',2)
grid on
hold
plot(x(1:jmax-1), dfava(1:jmax-1),'r','LineWidth',2)
plot(x(2:jmax),   dfret(2:jmax),  'g','LineWidth',2)
plot(x(2:jmax-1), dfcen(2:jmax-1),'k','LineWidth',2)
axis([x(1) x(jmax) -inf inf])
title('Funcao (azul) e difer finitas: av (verm), ret (verde), centr (preto)','fontsize',12)
ylabel('f, df/dx','fontsize',12)
xlabel('x','fontsize',12)

difer1  = zeros(jmax,1);
difer2  = zeros(jmax,1);
difer3  = zeros(jmax,1);
difer2a = zeros(jmax,1);

difer1(1:jmax-1)  = deranalit(1:jmax-1)  - dfava(1:jmax-1);
difer2(2:jmax)    = deranalit(2:jmax)    - dfret(2:jmax);
difer3(2:jmax-1)  = deranalit(2:jmax-1)  - dfcen(2:jmax-1);
difer2a(2:jmax-1) = deranalit2(2:jmax-1) - dfseg(2:jmax-1);

figure(2)
plot(x(1:jmax-1),difer1(1:jmax-1),'r','LineWidth',2)
grid on
hold
plot(x(2:jmax),difer2(2:jmax),'g','LineWidth',2)
plot(x(2:jmax-1),difer3(2:jmax-1),'k','LineWidth',2)
axis([x(1) x(jmax) -0.06 0.06])
title('Errros para derivada analitica: av (verm), ret (verde), centr (preto)','fontsize',12)
ylabel('Erro','fontsize',12)
xlabel('x','fontsize',12)

estat=['media,mediana, dp, min e max dos erros das diferencas finitas avan, retard e centrada']
estat_avanc=[mean(difer1) median(difer1) std(difer1) min(difer1) max(difer1)]
estat_retar=[mean(difer2) median(difer2) std(difer2) min(difer2) max(difer2)]
estat_centr=[mean(difer3) median(difer3) std(difer3) min(difer3) max(difer3)]

figure(3)
plot(x,f,'LineWidth',2)
grid on
hold
plot(x,deranalit2,'g','LineWidth',2)
plot(x(2:jmax-1),dfseg(2:jmax-1),'r','LineWidth',2)
plot(x(2:jmax-1),difer2a(2:jmax-1),'k','LineWidth',2)
title('Funcao (azul) e deriv 2a por difer finitas (verm), analit (verde) com erro (preto)',...
    'fontsize',12)
ylabel('f, d2f/dx2, erro','fontsize',12)
xlabel('x','fontsize',12)

estat=['media,mediana, dp, min e max dos erros das diferencas finitas na derivada segunda']
estat_2der=[mean(difer2a) median(difer2a) std(difer2a) min(difer2a) max(difer2a)]

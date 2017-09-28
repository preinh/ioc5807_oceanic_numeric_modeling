% Programa para calculo de derivadas por diferencas finitas de alta ordem
clear all; close all; clc

dx=0.1;
x=0:dx:pi;
f=sin(x);
deranalit=cos(x);deranalit=deranalit';

jmax=size(x,2);
dfava=zeros(jmax,1);
dfret=zeros(jmax,1);
dfcen=zeros(jmax,1);
dfseg=zeros(jmax,1);

dfava(1:jmax-2)=(-3*f(1:jmax-2)+4*f(2:jmax-1)-f(3:jmax))/(2*dx);
dfret(3:jmax)=(3*f(3:jmax)-4*f(2:jmax-1)+f(1:jmax-2))/(2*dx);
dfcen(3:jmax-2)=2*(f(4:jmax-1)-f(2:jmax-3))/(2*dx)-(f(5:jmax)-f(1:jmax-4))/(4*dx);

figure(1)
plot(x,f,'LineWidth',2)
grid on
hold
plot(x(1:jmax-2),dfava(1:jmax-2),'r','LineWidth',2)
plot(x(3:jmax),dfret(3:jmax),'g','LineWidth',2)
plot(x(3:jmax-2),dfcen(3:jmax-2),'k','LineWidth',2)
axis([x(1) x(jmax) -inf inf])
title('Funcao (azul) e difer finitas: av(verm), ret(verde), centr(preto)','fontsize',12)
ylabel('f, df/dx alta ordem','fontsize',12)
xlabel('x','fontsize',12)

difer1=zeros(jmax,1);
difer2=zeros(jmax,1);
difer3=zeros(jmax,1);

difer1(1:jmax-2)=deranalit(1:jmax-2)-dfava(1:jmax-2);
difer2(3:jmax)=deranalit(3:jmax)-dfret(3:jmax);
difer3(3:jmax-2)=deranalit(3:jmax-2)-dfcen(3:jmax-2);

figure(2)
plot(x(1:jmax-2),difer1(1:jmax-2),'r','LineWidth',2)
grid on
hold
plot(x(3:jmax),difer2(3:jmax),'g','LineWidth',2)
plot(x(3:jmax-2),difer3(3:jmax-2),'k','LineWidth',2)
axis([x(1) x(jmax) -0.004 0.004])
title('Erros p/ deriv analit: av(verm), ret(verde), centr(preto)','fontsize',12)
ylabel('Erro - alta ordem','fontsize',12)
xlabel('x','fontsize',12)

estat=['media,mediana, dp, min e max dos erros das diferencas finitas avan, retard e centrada']
estat_avanc=[mean(difer1) median(difer1) std(difer1) min(difer1) max(difer1)]
estat_retar=[mean(difer2) median(difer2) std(difer2) min(difer2) max(difer2)]
estat_centr=[mean(difer3) median(difer3) std(difer3) min(difer3) max(difer3)]




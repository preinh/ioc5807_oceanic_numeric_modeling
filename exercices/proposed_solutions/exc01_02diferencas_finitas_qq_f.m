% Programa para calculo de derivadas por diferencas finitas
clear all; close all; clc

dx=0.1;

x=0:dx:pi;
f=x.*sin(x).*exp(-x.^2);

jmax=size(x,2);
dfava1=zeros(jmax,1);
dfret1=zeros(jmax,1);
dfcen2=zeros(jmax,1);
dfava2=zeros(jmax,1);
dfret2=zeros(jmax,1);
dfcen3=zeros(jmax,1);

dfava1(1:jmax-1)=(f(2:jmax)-f(1:jmax-1))/dx;
dfret1(2:jmax)=(f(2:jmax)-f(1:jmax-1))/dx;
dfcen2(2:jmax-1)=(f(3:jmax)-f(1:jmax-2))/(2*dx);

figure(1)
plot(x,f,'LineWidth',2)
grid on
hold
plot(x(1:jmax-1),dfava1(1:jmax-1),'r','LineWidth',2)
plot(x(2:jmax),dfret1(2:jmax),'g','LineWidth',2)
plot(x(2:jmax-1),dfcen2(2:jmax-1),'k','LineWidth',2)
axis([x(1) x(jmax) -inf inf])
title('Funcao (azul) e difer finitas: av (verm), ret (verde), centr (preto)','fontsize',12)
ylabel('f, df/dx - baixa ordem','fontsize',12)
xlabel('x','fontsize',12)

dfava2(1:jmax-2)=(-3*f(1:jmax-2)+4*f(2:jmax-1)-f(3:jmax))/(2*dx);
dfret2(3:jmax)=(3*f(3:jmax)-4*f(2:jmax-1)+f(1:jmax-2))/(2*dx);
dfcen3(3:jmax-2)=2*(f(4:jmax-1)-f(2:jmax-3))/(2*dx)-(f(5:jmax)-f(1:jmax-4))/(4*dx);

figure(2)
plot(x,f,'LineWidth',2)
grid on
hold
plot(x(1:jmax-2),dfava2(1:jmax-2),'r','LineWidth',2)
plot(x(3:jmax),dfret2(3:jmax),'g','LineWidth',2)
plot(x(3:jmax-2),dfcen3(3:jmax-2),'k','LineWidth',2)
axis([x(1) x(jmax) -inf inf])
title('Funcao (azul) e difer finitas: av (verm), ret (verde), centr (preto)','fontsize',12)
ylabel('f, df/dx - alta ordem','fontsize',12)
xlabel('x','fontsize',12)




% Programa para adveccao, difusao e decaimento 2D
% de vazamento instantaneo de poluente no mar
% (com monitoramento da concentracao total)

% adveccao - explicito, centrado no tempo
% difusao - explicito, avancado no tempo
% decaimento - implicito

%%%%constantes do modelo (Sistema Internacional de Unidades - SI)
clear all; close all; clc

jmax=150;
kmax=150;
nmax=480;
dx=10;
dy=10;
dt=1;
kx=0.1;
ky=0.1;
r=5e-3; 
freqplot=60;
concorte=0.0001;
xgrid=((1:jmax)-1)*dx;
ygrid=((1:kmax)-1)*dy;
%%%%%testar com r=0;

%%%%%Condicoes iniciais
% kj em vez de jk !!!!!!
fant=zeros(kmax,jmax);
fatu=zeros(kmax,jmax);
fren=zeros(kmax,jmax);
xderr=70:80;
yderr=70:80;
cderr=100; % [kg]

[xder,yder]=meshgrid(xderr,yderr);
fant(yder,xder)=cderr;
fatu(yder,xder)=cderr;
['Valores iniciais do total de poluente e seu maximo']
soma=sum(sum(fatu))
maximo=max(max(fatu))

%%%%Campo de velocidades
u=ones(kmax,jmax)*1.0;
v=ones(kmax,jmax)*1.0;

quadv=dt/dx;
qvadv=dt/dy;
qudif=2*dt*kx/dx/dx;
qvdif=2*dt*ky/dy/dy;
rdec=1+2*dt*r; % (eq. 4.33)

%%%%%Equacao da adveccao - difusao - decaimento 2D
kplot=2;
for n=3:nmax
fren(2:kmax-1,2:jmax-1)=(fant(2:kmax-1,2:jmax-1)...
    -u(2:kmax-1,2:jmax-1)*quadv.*(fatu(2:kmax-1,3:jmax)-fatu(2:kmax-1,1:jmax-2))...
    -v(2:kmax-1,2:jmax-1)*qvadv.*(fatu(3:kmax,2:jmax-1)-fatu(1:kmax-2,2:jmax-1))...
    +qudif*(fant(2:kmax-1,3:jmax)-2*fant(2:kmax-1,2:jmax-1)+fant(2:kmax-1,1:jmax-2))...
    +qvdif*(fant(3:kmax,2:jmax-1)-2*fant(2:kmax-1,2:jmax-1)+fant(1:kmax-2,2:jmax-1)))/rdec;
ind=find(fren<concorte);
fren(ind)=0;
kplot=kplot+1;
if(kplot==freqplot)
kplot=0;
%%%%%calculo da soma das concentracoes e seu maximo
soma=sum(sum(fren));
maximo=max(max(fren));
figure(1)
plot(xgrid(xder),ygrid(yder),'xm','LineWidth',2)
hold
contourf(xgrid,ygrid,fren,[concorte:maximo])
colorbar
axis([xgrid(1) xgrid(jmax) ygrid(1) ygrid(kmax)])
tempo=n*dt;
%%%%%calculo da soma das concentracoes e seu maximo
soma=sum(sum(fren));
maximo=max(max(fren));
title(['Adv,dif,dec conc em t=',num2str(tempo),'seg soma ',num2str(soma),' max ',num2str(maximo)],'fontsize',12)
xlabel('DISTANCIA NA GRADE (m)','fontsize',12)
ylabel('DISTANCIA NA GRADE (m)','fontsize',12)
grid on
hold off
%pause
end
fant=fatu;
fatu=fren;
end

    















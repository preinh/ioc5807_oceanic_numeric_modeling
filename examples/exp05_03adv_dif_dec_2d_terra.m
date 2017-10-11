% Programa para adveccao, difusao e decaimento 2D
% de vazamento instantaneo de poluente no mar
% (com monitoramento da concentracao total)

% adveccao - explicito, centrado no tempo
% difusao - explicito, avancado no tempo
% decaimento - implicito

% Inclusao de contornos terrestres e ilhas

%%%%constantes do modelo (Sistema Internacional de Unidades - SI)
clear all; close all; clc

jmax=150;
kmax=150;
nmax=660;
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

% batimetria da grade
bat(1:kmax,1:jmax)=10;
bat(kmax-10:kmax,1:jmax)=0;
bat(1:kmax,jmax-10:jmax)=0;
kilha=100:105;
jilha=100:105;
bat(kilha,jilha)=0;

% Definicao de chave para os pontos de grade
% 1 maritimo, 0 terrestre
kmar(1:kmax,1:jmax)=1;
ind_terr=find(bat<=0);
kmar(ind_terr)=0;

[XBAT,YBAT]=meshgrid(xgrid,ygrid);
%plotando batimetria
figure(1)
contourf(XBAT,YBAT,bat,'LineWidth',2);
colorbar;
title(['Batimetria da regiao modelada (m)'],'fontsize',12)
axis([xgrid(1) xgrid(jmax) ygrid(1) ygrid(kmax)])
xlabel('Distancia na grade (m) EW','fontsize',12)
ylabel('Distancia na grade (m) NS','fontsize',12)
%print -djpeg fig_batim

[XKMAR,YKMAR]=meshgrid(1:jmax,1:kmax);
%plotando chaves 
figure(2)
contourf(XKMAR,YKMAR,kmar,'LineWidth',2);
colorbar;
title(['Chaves da regiao modelada (1 mar, 0 terra)'],'fontsize',12)
axis([1 jmax 1 kmax])
xlabel('Indices na grade - EW','fontsize',12)
ylabel('Indices na grade - NS','fontsize',12)
%print -djpeg fig_kmar

%%%%%Condicoes iniciais
fant=zeros(kmax,jmax);
fatu=zeros(kmax,jmax);
fren=zeros(kmax,jmax);
xderr=60:70;
yderr=60:70;
cderr=100;

[xder,yder]=meshgrid(xderr,yderr);
fant(yder,xder)=cderr;
fatu(yder,xder)=cderr;

%%%%Campo de velocidades
u=ones(kmax,jmax)*1.0;
v=ones(kmax,jmax)*1.0;

quadv=dt/dx;
qvadv=dt/dy;
qudif=2*dt*kx/dx/dx;
qvdif=2*dt*ky/dy/dy;
rdec=1+2*dt*r;

%%%%%Equacao da adveccao - difusao - decaimento 2D
kplot=2;
for n=3:nmax
fren(2:kmax-1,2:jmax-1)=(fant(2:kmax-1,2:jmax-1)...
    -kmar(2:kmax-1,3:jmax).*kmar(2:kmax-1,1:jmax-2).*...
    u(2:kmax-1,2:jmax-1)*quadv.*(fatu(2:kmax-1,3:jmax)-fatu(2:kmax-1,1:jmax-2))...
    -kmar(3:kmax,2:jmax-1).*kmar(1:kmax-2,2:jmax-1).*...
     v(2:kmax-1,2:jmax-1)*qvadv.*(fatu(3:kmax,2:jmax-1)-fatu(1:kmax-2,2:jmax-1))...
    +qudif*kmar(2:kmax-1,3:jmax).*kmar(2:kmax-1,1:jmax-2).*...
    (fant(2:kmax-1,3:jmax)-2*fant(2:kmax-1,2:jmax-1)+fant(2:kmax-1,1:jmax-2))...
    +qvdif*kmar(3:kmax,2:jmax-1).*kmar(1:kmax-2,2:jmax-1).*...
    (fant(3:kmax,2:jmax-1)-2*fant(2:kmax-1,2:jmax-1)+fant(1:kmax-2,2:jmax-1)))/rdec;
fren=fren.*kmar;
ind=find(fren<concorte);
fren(ind)=0;

kplot=kplot+1;
if(kplot==freqplot)
kplot=0;
maximo=max(max(fren));
figure(3)
contour(XBAT,YBAT,bat,[0.1 0.2 0.3],'LineWidth',2);
hold
plot(xgrid(xder),ygrid(yder),'xm','LineWidth',2)
contourf(xgrid,ygrid,fren,[concorte:maximo])
colorbar
axis([xgrid(1) xgrid(jmax) ygrid(1) ygrid(kmax)])
tempo=n*dt;
title(['Adv,dif,dec conc em t=',num2str(tempo),'seg'],'fontsize',12)
xlabel('DISTANCIA NA GRADE (m)','fontsize',12)
ylabel('DISTANCIA NA GRADE (m)','fontsize',12)
grid on
hold off
%pause
end
fant=fatu;
fatu=fren;
end

    















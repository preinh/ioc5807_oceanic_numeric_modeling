% Solucao da equacao da adveccao - difusao 2D com esquema de alta ordem

clear all; close all; clc

jmax=170;           % numero de colunas da grade 
kmax=160;           % numero de linhas da grade
nmax=250;           % numero de passos de tempo de simulacao

dx=5;               % espacamento horizontal na direcao x, em m
dx2=dx*dx;
dy=5;               % espacamento horizontal na direcao y, em m
dy2=dy*dy;
dt=15;              % passo de tempo, em segundos
Dh=0.1;             % coeficiente de difusao horizontal, em m2/s
qhu=dt*Dh/dx2;
qhv=dt*Dh/dy2;
concorte=0.001;     % concentracao de corte para graficos
xgrid=((1:jmax)-1)*dx;
ygrid=((1:kmax)-1)*dy;

freqplot=30;        % frequencia de plotagem

kdesp=80;jdesp=85;  % local do despejo continuo
despejo=0.1;        % lancamento continuo

umed=0.1;   % velocidade media na direcao ew, em m/s
vmed=0.1;   % velocidade media na direcao ns, em m/s

%inicializacao das matrizes:
fant=zeros(kmax,jmax);
fatu=zeros(kmax,jmax);
fren=zeros(kmax,jmax);
fdespejo=zeros(kmax,jmax);

%Condicao inicial
fdespejo(kdesp,jdesp)=despejo;

% Loop do tempo
for n=3:nmax
% Termos T1 adveccao em x e T2 adveccao em y 
% Termos T3 difusao em x e T4 difusao em y 

T1=(dt/dx)*umed.*(fatu(2:end-1,3:end)-fatu(2:end-1,1:end-2));
T2=(dt/dy)*vmed.*(fatu(3:end,2:end-1)-fatu(1:end-2,2:end-1)); 
T3=qhu*(fant(2:end-1,3:end)-2*fant(2:end-1,2:end-1)+fant(2:end-1,1:end-2));    
T4=qhv*(fant(3:end,2:end-1)-2*fant(2:end-1,2:end-1)+fant(1:end-2,2:end-1));    
fren(2:end-1,2:end-1)=fant(2:end-1,2:end-1)-T1-T2+T3+T4;
fren(fren<0)=0;
fren=fren+fdespejo;
fant=fatu;
fatu=fren;
conmax=max(max(fatu));

% plot de resultados
    if rem(n,freqplot)==0
        contourf(xgrid,ygrid,fatu,[concorte:0.01:conmax]);
        axis([xgrid(jdesp-10) xgrid(jdesp+80) ygrid(kdesp-10) ygrid(kdesp+80)]);
        grid
        colorbar
        tempo=n*dt;
        title(['Adv-Dif contaminante - solucao alta ordem - tempo ',...
            num2str(tempo),'seg'],'fontsize',12)
        xlabel('DISTANCIA NA GRADE (m)','fontsize',12)
        ylabel('DISTANCIA NA GRADE (m)','fontsize',12)
        F(n)=getframe;
    end
end    
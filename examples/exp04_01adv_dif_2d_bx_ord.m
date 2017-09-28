% Solucao da equacao da adveccao - difusao 2D com esquema de baixa ordem

clear all; close all; clc

jmax=170;           % numero de colunas da grade
kmax=160;           % numero de linhas da grade
nmax=600;           % numero de passos de tempo de simulacao

dx=5;               % espacamento horizontal na direcao x [m]
dx2=dx*dx;
dy=5;               % espacamento horizontal na direcao y [m]
dy2=dy*dy;
dt=6;               % passo de tempo, em segundos
Dh=0.5;             % coeficiente de difusao horizontal [m2/s]
qhu=dt*Dh/dx2;
qhv=dt*Dh/dy2;
concorte=0.001;     % concentracao de corte para graficos
xgrid=((1:jmax)-1)*dx;
ygrid=((1:kmax)-1)*dy;

freqplot=30;        % frequencia de plotagem

kdesp=80;jdesp=85;  % local do despejo continuo
despejo=0.1;        % lancamento continuo [kg]

umed=0.10;   % velocidade media na direcao ew, em m/s
vmed=0.10;   % velocidade media na direcao ns, em m/s

%inicializacao das matrizes:
fatu=zeros(kmax,jmax); % linha, coluna invertida.... (our matlab convention)
fren=zeros(kmax,jmax);
fdespejo=zeros(kmax,jmax);

%Condicao inicial
fdespejo(kdesp,jdesp)=despejo;

jminplot=jdesp-10; jmaxplot=jdesp+60; kminplot=kdesp-10; kmaxplot=kdesp+60;

% Loop do tempo
for n=2:nmax
% Termos T1 adveccao em x e T2 adveccao em y (laterais no espaco)
% Termos T3 difusao em x e T4 difusao em y (centrados no espaco)

if umed <0
    T1=(dt/dx)*umed.*(fatu(2:end-1,3:end)  -fatu(2:end-1,2:end-1)); %adveccao u negativo
else
    T1=(dt/dx)*umed.*(fatu(2:end-1,2:end-1)-fatu(2:end-1,1:end-2)); %adveccao u positivo
end
if vmed <0
    T2=(dt/dy)*vmed.*(fatu(3:end,  2:end-1)-fatu(2:end-1,2:end-1)); %adveccao v negativo
else
    T2=(dt/dy)*vmed.*(fatu(2:end-1,2:end-1)-fatu(1:end-2,2:end-1)); %adveccao v positivo
end
T3=qhu*(fatu(2:end-1,3:end)  -2*fatu(2:end-1,2:end-1)+fatu(2:end-1,1:end-2)); % difusao em u
T4=qhv*(fatu(3:end,  2:end-1)-2*fatu(2:end-1,2:end-1)+fatu(1:end-2,2:end-1)); % difusao em v

fren(2:end-1,2:end-1) = fatu(2:end-1,2:end-1)-T1-T2+T3+T4;
% zerando alguma parte
ind=find(fren<concorte);
fren(ind)=0;
% acumulando despejo
fren=fren+fdespejo;
% concentração máxima
conmax=max(max(fren));

% plot de resultados [rem = resto da divis??o]
    if rem(n,freqplot)==0
        contourf(xgrid,ygrid,fren,[concorte:0.01:conmax]);
        grid;
        axis([xgrid(jminplot) xgrid(jmaxplot) ygrid(kminplot) ygrid(kmaxplot)]);
        colorbar
        tempo=n*dt;
        title(['Adv-Dif contaminante - solucao baixa ordem - tempo ',...
            num2str(tempo),'seg'],'fontsize',12)
        xlabel('DISTANCIA NA GRADE (m)','fontsize',12)
        ylabel('DISTANCIA NA GRADE (m)','fontsize',12)
        F(n)=getframe;
    end
fatu=fren;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modelo Numerico de dispersao 2D (advecçao / difusao / decaim) %
% Baía de Guanabara                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc

% parametros iniciais do modelo
nmax=60; % numero passos de tempo 
dt=360;  % passo de tempo, em segundos
gama=0.5 % coeficiente para filtragem no espaco
gama1=0.5*gama*(1-gama);
gama2=0.25*gama*gama;
kx=5; % definindo coeficientes de difusao kx e ky, em m2/s
ky=5;
rdec=5e-5;   % coeficiente de decaimento (s-1)
concorte=1;  % concentracao de corte para graficos e calculos

% carregar arquivo com longitude, latitude e profundidade
batim=load('guanab_bat_disp.dat');

lon=batim(:,3);
lat=batim(:,4);
prof=batim(:,5);

lonmin=min(lon)
lonmax=max(lon)
latmin=min(lat)
latmax=max(lat)
profmin=min(prof)
profmax=max(prof)

nupon=size(batim,1)
kmax=batim(end,2);
jmax=batim(end,1);

lon2=reshape(lon,kmax,jmax);
lat2=reshape(lat,kmax,jmax);
prof2=reshape(prof,kmax,jmax);

% definição dos espacamentos de grade
dx=zeros(kmax,jmax);
dy=zeros(kmax,jmax);
fat=pi/180;
RT = 6.37813559e6;

for k=1:kmax-1
    for j=1:jmax-1
        varla=(lat2(k+1,j)-lat2(k,j))*fat;
        latmed=(lat2(k+1,j)+lat2(k,j))/2;
        varlo=(lon2(k+1,j)-lon2(k,j))*fat*cosd(latmed);
        dy(k,j)=sqrt(varla^2+varlo^2)*RT;
        varla=(lat2(k,j+1)-lat2(k,j))*fat;
        latmed=(lat2(k,j+1)+lat2(k,j))/2;
        varlo=(lon2(k,j+1)-lon2(k,j))*fat*cosd(latmed);
        dx(k,j)=sqrt(varla^2+varlo^2)*RT;
    end
end
for j=1:jmax
    dx(kmax,j)=dx(kmax-1,j);
    dy(kmax,j)=dy(kmax-1,j);
end
for k=1:kmax
    dx(k,jmax)=dx(k,jmax-1);
    dy(k,jmax)=dy(k,jmax-1);
end

dx2=dx.*dx;
dy2=dy.*dy;

% zerando matrizes no instante inicial
cant=zeros(kmax,jmax);
catu=zeros(kmax,jmax);
cren=zeros(kmax,jmax);
cadv=zeros(kmax,jmax);
cderr=zeros(kmax,jmax);
cfilt=zeros(kmax,jmax);
u=zeros(kmax,jmax);
v=zeros(kmax,jmax);

% definindo a velocidade de advecção
u=ones(kmax,jmax)*0.2;
v=ones(kmax,jmax)*0.2;

% parâmetros do derrame - coordenadas em x,y e volume
jderr=160:162; 
kderr=180:182; 
vderr=1*dt; % kg
cderr(kderr,jderr)=vderr;
jdemi=min(jderr);
jdema=max(jderr);
kdemi=min(kderr);
kdema=max(kderr);

% concentracoes nos instantes iniciais (n=1 e n=2)
cant=cderr;
catu=cderr;
      
kmar=ones(kmax,jmax);
as=find(prof2<=0);
kmar(as)=0;

%%%%% Equacao da adveccao - difusao - decaim 2D %%%%%
% advecção (esquema centrado no tempo e no espaço)
% difusao e decaim (esquema avancado no tempo e centrado no espaco)

for n=3:nmax
    cren(2:end-1,2:end-1)=cant(2:end-1,2:end-1)...
    -dt./dx(2:end-1,2:end-1).*(u(2:end-1,2:end-1).*(catu(2:end-1,3:end)-catu(2:end-1,1:end-2)))...
    -dt./dy(2:end-1,2:end-1).*(v(2:end-1,2:end-1).*(catu(3:end,2:end-1)-catu(1:end-2,2:end-1)))...
    +kx*dt./dx2(2:end-1,2:end-1).*(cant(2:end-1,3:end)-2*cant(2:end-1,2:end-1)+cant(2:end-1,1:end-2))...
    +ky*dt./dy2(2:end-1,2:end-1).*(cant(3:end,2:end-1)-2*cant(2:end-1,2:end-1)+cant(1:end-2,2:end-1))...
    -rdec*dt*cant(2:end-1,2:end-1);
    bs=find(cren<concorte);
    cren(bs)=0;
        cfilt(2:end-1,2:end-1)=cren(2:end-1,2:end-1)+...
        gama1*(cren(1:end-2,2:end-1)+cren(3:end,2:end-1)+...
        cren(2:end-1,1:end-2)+cren(2:end-1,3:end)-4*cren(2:end-1,2:end-1))+...
        gama2*(cren(1:end-2,1:end-2)+cren(1:end-2,3:end)+...
        cren(3:end,1:end-2)+cren(3:end,3:end)-4*cren(2:end-1,2:end-1));
    cren=cfilt;
    cfilt=(cant+2*catu+cren)/4;
    catu=cfilt;
    cren=cren+cderr;
    cren=cren.*kmar;
    conmax=max(max(cren));

    figure(3)
    contour(lon2,lat2,prof2,[0.1 0.2]),'LineWidth',2; 
    hold on; 
    contour(lon2,lat2,cren,[concorte:100:conmax],'LineWidth',2);
    axis([lonmin lonmax latmin latmax])
    colorbar
    tempo=n*dt;
    title(['Adv Dif Dec 2D vaz contin-concentr em t = ',...
          num2str(tempo/3600),' horas'],'fontsize',12)
    xlabel('LONGITUDE','fontsize',12)
    ylabel('LATITUDE','fontsize',12)
    hold off
    cant=catu;
    catu=cren;
end
    
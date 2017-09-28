% Rotina para difusao e advecao de um poluente
% proveniente de um emissario, lancado a taxa
% constante no ambiente 
clear all; close all; clc

% CONSTANTES DO MODELO
jmax=21;		% numero de celulas na direcao x
kmax=21;		% numero de celulas na direcao y
lmax=11;		% numero de celulas na direcao z
nmax=150;		% numero passos de tempo		
dh=.025;     	% coeficiente de difusao horizontal (m2/s)
dv=.01; 		% coeficiente de difusao vertical (m2/s)
r=5e-3;         % coeficiente de decaimento (s-1)
dx=10;			% espacamento de grade na horizontal em x (m)
dy=10;			% espacamento de grade na horizontal em y (m)
dz=0.5;	    	% espacamento de grade na vertical (m)
dt=5;		    % passo de tempo (s)
freqplo=6;      % frequencia de plotagem

jdesc=4;kdesc=4;ldesc=8;desc=10;  % posicao de descarga e valor

vel=1.0;			    % velocidade ambiente (m/s)
dir=22.5;			    % direcao em relacao a Leste 
u=vel*cos(dir*pi/180);	%componente zonal da velocidade (m/s)
v=vel*sin(dir*pi/180);	%componente meridional da velocidade (m/s)
w=0.02;	  			    %componente vertical da velocidade (m/s)

dx2=2*dx;
dy2=2*dy;
dz2=2*dz;
qhx=dh*2*dt/dx^2;
qhy=dh*2*dt/dy^2;
qv=dv*2*dt/dz^2;
rdec=1+2*dt*r;
fant=zeros(kmax,jmax,lmax);
fatu=zeros(kmax,jmax,lmax);
fren=zeros(kmax,jmax,lmax);
concorte=0.001;
xgrid=((1:jmax)-1)*dx;
ygrid=((1:kmax)-1)*dy;
zgrid=((1:lmax)-1)*dz;

contplo=1;
kfig=0;

% LOOP NO TEMPO
for n=2:nmax
   fren(2:end-1,2:end-1,2:end-1)=(fant(2:end-1,2:end-1,2:end-1)+...
      qhy*(fant(3:end,2:end-1,2:end-1)-2*fant(2:end-1,2:end-1,2:end-1)+fant(1:end-2,2:end-1,2:end-1))...
      -v*[(fatu(3:end,2:end-1,2:end-1)-fatu(1:end-2,2:end-1,2:end-1))/dx2]+...
      qhx*(fant(2:end-1,3:end,2:end-1)-2*fant(2:end-1,2:end-1,2:end-1)+fant(2:end-1,1:end-2,2:end-1))...
      -u*[(fatu(2:end-1,3:end,2:end-1)-fatu(2:end-1,1:end-2,2:end-1))/dx2]+...
      qv*(fant(2:end-1,2:end-1,3:end)-2*fant(2:end-1,2:end-1,2:end-1)+fant(2:end-1,2:end-1,1:end-2))...
      -w*[(fatu(2:end-1,2:end-1,3:end)-fatu(2:end-1,2:end-1,1:end-2))/dz2])/rdec;
  % introducao do poluente no ambiente
  fren(kdesc,jdesc,ldesc)=fren(kdesc,jdesc,ldesc)+desc; 
  k=find(fren<concorte);fren(k)=0;
     
   contplo=contplo+1;
   if(contplo==freqplo)
      contplo=0;
      kfig=kfig+1;
      figure (kfig)
      tempo=n*dt/60;
      subplot(2,2,1);max04=max(max(fren(:,:,4)));
      contourf(xgrid,ygrid,fren(:,:,4),[concorte:max04]);colorbar;grid on;
      title('Adv/Dif/Dec 3D - prof 1.5m','fontsize',12);
      xlabel('DISTANCIA NA GRADE (m)','fontsize',12)
      subplot(2,2,2);max06=max(max(fren(:,:,6)));
      contourf(xgrid,ygrid,fren(:,:,6),[concorte:max06]);colorbar;grid on;
      title('prof 2.5m','fontsize',12);
      ylabel('DISTANCIA NA GRADE (m)','fontsize',12)
      subplot(2,2,3);max08=max(max(fren(:,:,8)));
      contourf(xgrid,ygrid,fren(:,:,8),[concorte:max08]);colorbar;grid on;
      title('prof 3.5m','fontsize',12);
      subplot(2,2,4);max10=max(max(fren(:,:,10)));
      contourf(xgrid,ygrid,fren(:,:,10),[concorte:max10]);colorbar;grid on;
      title(['Prof. 4.5 m - tempo ' ,num2str(tempo),' minutos'],'fontsize',12);
      if(kfig>1) close(figure(kfig-1)); end
   	% pause
   end
   fant=fatu;
   fatu=fren;
end

% Plotagem do perfil vertical de concentracoes
% no ponto de descarga, ao final do processamento
figure (99)
perfil(1:lmax)=fren(kdesc,ldesc,1:lmax);
plot(perfil,-zgrid)
grid on
title('PERFIL VERT FINAL DE CONCENTR NO PTO DE DESCARGA'...
    ,'fontsize',12)
xlabel('CONCENTRACOES','fontsize',12)
ylabel('PROFUNDIDADE (m)','fontsize',12)


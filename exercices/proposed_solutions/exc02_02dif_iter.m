%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Equacao de difusao unidimensional p/ sinal retangular%
%f(j dx)=0 para j < 225 e j > 275                     %
%f(j dx)=99 para 225 <=  j <= 275                     %
%solucao atraves de esquema iterativo                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc

%parametros iniciais
jmax=500;  %numero de pontos de grade
nmax=7600; %numero de passos de tempo

%condicao inicial
j=1:jmax;
fatu(j)=0;
fatu(225:275)=99; 
fcin=fatu;

d=10;    %em m2/s
dt=1;    %em s
dx=8;    %em m 
q=d*dt/(dx*dx);
xgrid=((1:jmax)-1)*dx;

%esquema explicito avan t, centr em x
fren=fatu;
fast=fatu;
freqplot=720;
kplot=719;
kfig=0;
for n=2:nmax
    tempo=n*dt;
    kplot=kplot+1;
    fast(2:jmax-1)=fatu(2:jmax-1)+ q*(fatu(3:jmax)-2*fatu(2:jmax-1)+fatu(1:jmax-2));
    fren(2:jmax-1)=fatu(2:jmax-1)+ q*(fast(3:jmax)-2*fast(2:jmax-1)+fast(1:jmax-2));
    fren((fren<0))=0;   
        if(kplot==freqplot)
        kplot=0;
        XX=num2str(tempo);
        eval(['save -ascii result/fren_iter',XX,'.dat fren']);
        figure(1)
        plot(xgrid,fcin,'r','LineWidth',2)
        hold
        plot(xgrid,fren,'LineWidth',2)
        grid on
   	    axis([xgrid(1) xgrid(jmax) 0 100]);
        title(['Difusao - iterativo - tempo ',num2str(tempo/3600),...
            ' horas'],'fontsize',12)
        xlabel('DISTANCIA NA GRADE (m)','fontsize',12)
        ylabel('conc','fontsize',12)
        grafico=['print -djpeg result/tempo_iter',XX];
        eval(grafico);
        pause
        hold off
        end
    fatu=fren;
end

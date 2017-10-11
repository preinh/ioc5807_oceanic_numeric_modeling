%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Equacao de difusao unidimensional p/ sinal retangular%
%f(j dx)=0 para j < 225 e j > 275                     %
%f(j dx)=99 para 225 <=  j <= 275                     %
%solucao atraves de esquema explicito                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc

%parametros iniciais
jmax=200;  %numero de pontos de grade
nmax=6000; %numero de passos de tempo

%condicao inicial
j=1:jmax;
fatu(j)=0;
fatu(75:125)=99; 
fcin=fatu;

d=10;    %em m2/s
dt=2;    %em s
dx=8;    %em m 
q=d*dt/(dx*dx);
xgrid=((1:jmax)-1)*dx;

%esquema explicito avan t, centr em x
fren=fatu;
freqplot=360;
kplot=359;
kfig=0;
for n=2:nmax
    tempo=n*dt;
    kplot=kplot+1;
    fren(2:jmax-1)=fatu(2:jmax-1)+ q*(fatu(3:jmax)-2*fatu(2:jmax-1)+fatu(1:jmax-2));
    fren((fren<0))=0;
    % fronteira rigida
    fren(1)=0; fren(jmax)=0;
    fatu=fren;
        if(kplot==freqplot)
        kplot=0;
        XX=num2str(tempo);
        eval(['save -ascii result/dif_cc01_',XX,'.dat fren']);
        figure(1)
        plot(xgrid,fcin,'r','LineWidth',2)
        hold
        plot(xgrid,fren,'LineWidth',2)
        grid on
   	    axis([xgrid(1) xgrid(jmax) 0 100]);
        title(['Difusao - explicito - cc01- tempo ',num2str(tempo/3600),...
            ' horas'],'fontsize',12)
        xlabel('DISTANCIA NA GRADE (m)','fontsize',12)
        ylabel('conc','fontsize',12)
        grafico=['print -djpeg result/dif_cc01_',XX];
        eval(grafico);
        pause
        hold off
        end
end

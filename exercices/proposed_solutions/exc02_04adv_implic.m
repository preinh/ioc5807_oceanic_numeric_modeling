%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Equacao de adveccao unidimensional p/ sinal retangular%
%f(j dx)=0 para j < 225 e j > 275                      %
%f(j dx)=99 para 225 <=  j <= 275                      %
%solucao atraves de esquema implicito                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc

%parametros iniciais
jmax=500;  %numero de pontos de grade
nmax=792;  %numero de passos de tempo

%condicao inicial
j=1:jmax;
fatu(j)=0;
fatu(225:275)=99; 
fcin=fatu;

c=2;    %em m/s
dt=1;   %em s
dx=8;   %em m
xgrid=((1:jmax)-1)*dx;

%esquema implicito cent t, centr em x
fant=fatu;
fren=fatu;
freqplot=30;
kplot=29;
kfig=0;

sj=zeros(1,jmax);
pj=zeros(1,jmax);
dj=zeros(1,jmax);

aj=-c/(2*dx);
bj=1/(2*dt);
cj=c/(2*dx);
    
for n=3:nmax
   tempo=n*dt;
   kplot=kplot+1;
   
   dj=fant*1/(2*dt);
   %varredura ascendente
   for j=2:jmax-1   
   sj(j)=-cj/(bj+aj*sj(j-1));
   pj(j)=(dj(j)-aj*pj(j-1))/(bj+aj*sj(j-1));
   end
   %varredura descendente
   for j=jmax-1:-1:2    
   fren(j)=sj(j)*fren(j+1)+pj(j);
   end
   fren((fren<0))=0;
    
   if(kplot==freqplot)
   kplot=0;
   XX=num2str(tempo);
   eval(['save -ascii result/fren_imp',XX,'.dat fren']);
   figure(1)
   plot(xgrid,fcin,'r','LineWidth',2)
   hold
   plot(xgrid,fren,'LineWidth',2)
   grid on
   axis([xgrid(1) xgrid(jmax) 0 100]);
   title(['Adveccao - implicito - tempo ',num2str(tempo/3600),...
       ' horas'],'fontsize',12)
   xlabel('DISTANCIA NA GRADE (m)','fontsize',12)
   ylabel('conc','fontsize',12)
   grafico=['print -djpeg result/tempo_adv_imp',XX];
   eval(grafico);
   pause
   hold off
   end
   
   fant=fatu;
   fatu=fren;

 end

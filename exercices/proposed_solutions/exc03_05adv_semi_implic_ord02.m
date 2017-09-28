% SOLUCAO DA EQUACAO DA ADVECCAO UNI-DIMENSIONAL LINEAR 
% POR METODO SEMI IMPLICITO DE SEGUNDA ORDEM NO TEMPO E NO ESPACO. 
% SOLUCAO DA ADVECCAO DE UM SINAL RETANGULAR EM SUB-REGIAO DA GRADE   

% FORNECER NUMERO DE PONTOS DA GRADE, NUMERO DE PASSOS DE TEMPO, VELOCIDADE (m/s),
% ESPACAMENTO DE GRADE (m), PASSO DE TEMPO (s),
% AMPLITUDE DO SINAL E SUA POSICAO INICIAL NA GRADE
% E FREQUENCIA DE PLOTAGEM

clear all; close all; clc

% CONSTANTES DO MODELO
jmax=200;
nmax=45;
c=-2;
% testar com c=2;
dx=10;
dt=8;
pol=100;
posini=95;
posfim=105;
freqplo=5;
xgrid=((1:jmax)-1)*dx;

% CONDICOES INICIAIS
fant=zeros(jmax,1);
fatu=zeros(jmax,1);
fren=zeros(jmax,1);

fant(posini:posfim)=pol;
fatu(posini:posfim)=pol;
fcin=fatu;

contplo=2;
pol050=0.5*pol;
pol150=1.5*pol;

sj=zeros(1,jmax);
pj=zeros(1,jmax);
dj=zeros(1,jmax);

aj=-c*dt/(2*dx);
bj=1;
cj=c*dt/(2*dx);
dj=zeros(1,jmax);

q=c*dt/(2*dx);
    
for n=3:nmax
   tempo=n*dt;
 
   dj(2:jmax-1)=fant(2:jmax-1)-q*(fant(3:jmax)-fant(1:jmax-2));
   
   %varredura ascendente
   for j=2:jmax-1   
   sj(j)=-cj/(bj+aj*sj(j-1));
   pj(j)=(dj(j)-aj*pj(j-1))/(bj+aj*sj(j-1));
   end
   %varredura descendente
   for j=jmax-1:-1:2    
   fren(j)=sj(j)*fren(j+1)+pj(j);
   end
   contplo=contplo+1;
   if(contplo==freqplo)
   contplo=0;
   figure (1)
   plot(xgrid,fcin,'r','LineWidth',2)
   hold
   plot(xgrid,fren,'LineWidth',2)
   axis([xgrid(1) xgrid(jmax) -pol050 pol150]);
   title(['Adveccao de sinal retangular (semi implic, 2a ordem) - tempo ',...
       num2str(tempo),' segundos'],'fontsize',12)
   xlabel('DISTANCIA NA GRADE(m)','fontsize',12)
   ylabel('conc','fontsize',12)
   grid on
   pause
   hold off
   end
   fant=fatu;
   fatu=fren;
end
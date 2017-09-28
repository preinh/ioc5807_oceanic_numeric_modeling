% SOLUCAO DA EQUACAO DA ADVECCAO UNI-DIMENSIONAL LINEAR 
% POR METODO IMPLICITO DE PRIMEIRA ORDEM NO TEMPO E NO ESPACO.
% (AVANCADO NO TEMPO E NO ESPACO)
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
fatu=zeros(jmax,1);
fren=zeros(jmax,1);

fatu(posini:posfim)=pol;
fcin=fatu;

contplo=1;
pol020=0.2*pol;
pol120=1.2*pol;

sj=zeros(1,jmax);
pj=zeros(1,jmax);
dj=zeros(1,jmax);

aj=0;
bj=1-c*dt/dx;
cj=c*dt/dx;
    
for n=2:nmax
   tempo=n*dt;
 
   dj=fatu;
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
   axis([xgrid(1) xgrid(jmax) -pol020 pol120]);
   title(['Adveccao de sinal retangular (implic, 1a ordem) - tempo ',...
       num2str(tempo),' segundos'],'fontsize',12)
   xlabel('DISTANCIA NA GRADE(m)','fontsize',12)
   ylabel('conc','fontsize',12)
   grid on
   pause
   hold off
   end
   fatu=fren;
end
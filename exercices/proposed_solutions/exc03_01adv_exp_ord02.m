% SOLUCAO DA EQUACAO DA ADVECCAO UNI-DIMENSIONAL LINEAR 
% POR METODO EXPLICITO DE SEGUNDA ORDEM NO TEMPO E NO ESPACO. 
% SOLUCAO DA ADVECCAO DE UM SINAL RETANGULAR EM SUB-REGIAO DA GRADE   

% FORNECER NUMERO DE PONTOS DA GRADE, NUMERO DE PASSOS DE TEMPO, VELOCIDADE (m/s),
% ESPACAMENTO DE GRADE (m), PASSO DE TEMPO (s),
% AMPLITUDE DO SINAL E SUA POSICAO INICIAL NA GRADE
% E FREQUENCIA DE PLOTAGEM

clear all; close all; clc

% CONSTANTES DO MODELO
jmax=200;
nmax=90;
c=-2;
% testar com c=2;
dx=10;
dt=4;
pol=100;
posini=95;
posfim=105;
freqplo=5;
xgrid=((1:jmax)-1)*dx;

% CALCULOS INICIAIS
q=c*dt/dx;

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

% LOOP NO TEMPO
% CONDICOES DE CONTORNO
% FORMULA DE RECORRENCIA
% PLOTAGEM (PRESSIONE ENTER PARA EVOLUIR NO TEMPO)
% EVOLUCAO NO TEMPO DAS VARIAVEIS
for n=3:nmax
   tempo=n*dt;
   fren(2:jmax-1)=fant(2:jmax-1)-q*(fatu(3:jmax)-fatu(1:jmax-2));
   contplo=contplo+1;
   if(contplo==freqplo)
   contplo=0;
   figure (1)
   plot(xgrid,fcin,'r','LineWidth',2)
   hold
   plot(xgrid,fren,'LineWidth',2)
   axis([xgrid(1) xgrid(jmax) -pol050 pol150]);
   title(['Adveccao de sinal retangular (explic, 2a ordem) - tempo ',...
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

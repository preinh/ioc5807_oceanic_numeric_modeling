% SOLUCAO DA EQUACAO DA ADVECCAO UNI-DIMENSIONAL LINEAR 
% PELO METODO EXPLICITO CENTRADO NO TEMPO E NO ESPACO. 
% SOLUCAO DA ADVECCAO DE UM SINAL SENOIDAL NO PONTO INICIAL DA GRADE   

clear all; close all; clc

% FORNECER NUMERO DE PONTOS DA GRADE, NUMERO DE PASSOS DE TEMPO, VELOCIDADE (m/s),
% ESPACAMENTO DE GRADE (m), PASSO DE TEMPO (s),
% AMPLITUDE DA OSCILACAO NA BORDA (m) E SEU PERIODO (s)
% E FREQUENCIA DE PLOTAGEM

% CONSTANTES DO MODELO
jmax=200;
nmax=1200;
c=5;
dx=10;
dt=1;
amp=0.5;
per=60;
freqplo=5;

q=c*dt/dx;
omega=2*pi/per;
fant=zeros(jmax,1);
fatu=zeros(jmax,1);
fren=zeros(jmax,1);

% CONDICOES INICIAIS (NA BORDA)
fant(1)=amp*sin(omega*dt);
fatu(1)=amp*sin(omega*2*dt);
contplo=2;
amp2=2*amp;
xgrid=((1:jmax)-1)*dx;

% LOOP NO TEMPO
% CONDICOES DE CONTORNO
% FORMULA DE RECORRENCIA
% PLOTAGEM (PRESSIONE ENTER PARA EVOLUIR NO TEMPO)
% EVOLUCAO NO TEMPO DAS VARIAVEIS
for n=3:nmax
   tempo=n*dt;
   fren(1)=amp*sin(omega*tempo);
   fren(2:jmax-1)=fant(2:jmax-1)-q*(fatu(3:jmax)-fatu(1:jmax-2));
   % fronteira rigida
   fren(jmax)=0;
   contplo=contplo+1;
   if(contplo==freqplo)
   contplo=0;
   plot(xgrid,fren,'LineWidth',2)
   grid on
   axis([xgrid(1) xgrid(jmax) -amp2 amp2]);
   xlabel('DISTANCIA NA GRADE (m)','fontsize',12)
   ylabel('m','fontsize',12)
   title(['Adv sinal senoidal na borda (2a ordem) cc01 - tempo ',...
       num2str(tempo),' seg'],'fontsize',12)
   pause
   end
   fant=fatu;
   fatu=fren;
end

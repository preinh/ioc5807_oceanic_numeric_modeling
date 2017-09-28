% SOLUCAO DA EQUACAO DA ADVECCAO UNI-DIMENSIONAL LINEAR
% POR METODO AVANCADO NO TEMPO E RETARDADO NO ESPACO.
% SOLUCAO DA ADVECCAO DE UM SINAL SENOIDAL NO PONTO INICIAL DA GRADE

% FORNECER NUMERO DE PONTOS DA GRADE, NUMERO DE PASSOS DE TEMPO, VELOCIDADE (m/s),
% ESPACAMENTO DE GRADE (m), PASSO DE TEMPO (s),
% AMPLITUDE DA OSCILACAO NA BORDA (m) E SEU PERIODO (s)
% E FREQUENCIA DE PLOTAGEM

clear all; close all; clc

% CONSTANTES DO MODELO
jmax=200;
nmax=360;
c=5;
dx=10;
dt=1;
amp=0.5;
per=60;
freqplo=5;

% CALCULOS INICIAIS
q=c*dt/dx;
omega=2*pi/per;

% CONDICOES INICIAIS
fatu=zeros(jmax,1);
fren=zeros(jmax,1);

% CONDICOES INICIAIS (NA BORDA)
fatu(1)=amp*sin(omega*dt);

contplo=1;
amp2=amp*1.2;
xgrid=((1:jmax)-1)*dx;

% LOOP NO TEMPO
% CONDICOES DE CONTORNO
% FORMULA DE RECORRENCIA
% PLOTAGEM (PRESSIONE ENTER PARA EVOLUIR NO TEMPO)
% EVOLUCAO NO TEMPO DAS VARIAVEIS
for n=2:nmax
   tempo=n*dt;
% IMPOSICAO DE CONDICOES DE CONTORNO
   fren(1)=amp*sin(omega*tempo);
% FORMULA DE RECORRENCIA
   fren(2:jmax-1) = fatu(2:jmax-1) ...
                  - q*(fatu(2:jmax-1)-fatu(1:jmax-2));   
   contplo=contplo+1;
   if(contplo==freqplo)
% APRESENTACAO DE RESULTADOS
   contplo=0;
   plot(xgrid,fren,'LineWidth',2)
   axis([xgrid(1) xgrid(jmax) -amp2 amp2]);
   title(['Adveccao de sinal senoidal na borda (1a ordem) - tempo ',...
       num2str(tempo),' segundos'],'fontsize',12)
   xlabel('DISTANCIA NA GRADE (m)','fontsize',12)
   ylabel('m','fontsize',12)
   grid on
   pause
   end
% TRANSFERENCIA DE VARIAVEIS NO TEMPO
   fatu=fren;
end

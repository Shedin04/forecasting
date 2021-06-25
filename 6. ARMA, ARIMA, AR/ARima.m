clc;
flag=input('Ви хочете згенерувати новий час. ряд? [1-Так, 0-Ні]: ');

if (flag==1)
clear all;
N=input('Введіть довжину часового ряду: N=');% довжина часового ряду, кількість спостережень
K=input('На скільки прогнозуємо: K=');
A=input('Введіть параметри для генерації: \nA='); %
B=input('B=');
C=input('C=');
D=input('D=');
t=1:N;
YY=A*(t.^2)+B*t.*sin(t)+C.*rand(1,N)+D; % генерація часового ряду
end;

if (exist('YY')==0) % перевірка, чи є час. ряд
    error('Помилка: Згенеруйте часовий ряд!')
end;

if (mod(N,2)~=0) % якщо ряд непарний
n=ceil(N/2)-1;
else
n=N/2;
end

fprintf('\nОсновні характеристики час. ряду:\n');
YY_avg=mean(YY); % знаходчення МО
fprintf('- МО = %.2f \n',YY_avg);
D=cov(YY); % розрахунок дисперсії
fprintf('- Дисперсія = %.4f \n',D);
COR=xcorr(YY);% повертає послідовність автокореляції
P=((t-mean(t))*(YY-mean(YY))')/sqrt(((t-mean(t))*(t-mean(t))')*((YY-mean(YY))*(YY-mean(YY))')); % Коефіцієнт кореляції Пірсона
fprintf('- Коеф. Пірсона = %.4f \n\n',P);

figure(1)
[acf, lags]=autocorr(YY);
stem(lags,acf)% будує графік функції автокореляції (корелограми)
grid on

KK=N-K;
Y=YY(1:KK);

figure(2)
plot(1:KK+K,YY(1:KK+K),'--ko');
grid on;
legend('Час. ряд')
title('Вихідний час. ряд')

% arma
fprintf('- ARMA модель\n')
p=input('Введіть параметри:\np=');
q=input('q=');
data=iddata(Y',[]);
sys1=armax(data,[p q]);
p1=forecast(sys1,data,K);
p1_znach = p1.OutputData;

figure(3)
plot(data,'--bo',p1,'--ro')
grid on
legend('Часовий ряд','Прогноз')
title(['ARMA: p=',num2str(p),', q=',num2str(q)])

%ARIMA%
fprintf('\n- ARIMA модель\n')
p=input('Введіть параметри:\np=');
fprintf('d=1\n')
q=input('q=');
sys2=armax(data,[4 5],'IntegrateNoise',1); %arima
p2=forecast(sys2,data,K);
p2_znach = p2.OutputData;

figure(4)
plot(data,'--bo',p2,'--ro');
grid on;
legend('Час. ряд', 'прогноз')
title(['ARIMA: p=',num2str(p),', d=1, q=',num2str(q)])

%AR%
fprintf('\n- AR модель\n')
p=input('Введіть параметр: p=');
sys3=armax(data,[p 0]); %ar
p3=forecast(sys3,data,K);
p3_znach = p3.OutputData;

figure(5)
plot(data,'--bo',p3,'--ro');
grid on;
legend('Час. ряд', 'прогноз')
title(['AR: p=',num2str(p)])

Y_fact=YY(KK+1:N); % залишаємо лише фактичні значення
fprintf('\nПОКАЗНИКИ ПОМИЛОК:\n');
fprintf('ARMA:\n');
error_rate(Y_fact,p1_znach, K)

fprintf('ARIMA:\n');
error_rate(Y_fact,p2_znach, K)

fprintf('AR:\n');
error_rate(Y_fact,p3_znach, K)

figure(6)
plot(KK+1:N,YY(KK+1:N),'--ko',KK+1:N,p1_znach,'-r',KK+1:N,p2_znach,'-b',KK+1:N,p3_znach,'-g');
grid on;
legend('Час. ряд', 'ARMA','ARIMA','AR')

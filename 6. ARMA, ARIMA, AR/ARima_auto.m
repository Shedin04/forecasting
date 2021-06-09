clc;
clear all;

N=input('Введіть довжину часового ряду: N=');% довжина часового ряду, кількість спостережень
K=input('На скільки прогнозуємо: K=');
A=input('Введіть параметри для генерації: \nA='); %
B=input('B=');
C=input('C=');
D=input('D=');
t=1:N;
YY=A*(t.^2)+B*t.*sin(t)+C.*rand(1,N)+D; % генерація часового ряду

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

MAE_lvl=input('Введіть допустиме значення MAE: ');

figure(1)
[acf, lags]=autocorr(YY);
stem(lags,acf)% будує графік функції автокореляції (корелограми)
grid on


KK=N-K;
Y=YY(1:KK);
Y_fact=YY(KK+1:N); % залишаємо лише фактичні значення

figure(2)
plot(1:KK+K,YY(1:KK+K),'--ko');
grid on;
legend('Час. ряд')
title('Вихідний час. ряд')

data=iddata(Y',[]);
% arma
fprintf('\n- ARMA модель\n')
MAE_p1=MAE_lvl*2;% початкове значення mae
p=1;
q=1;
k=0;
while MAE_p1>MAE_lvl
    if q>16-k % 16 - макс. коеф.
        p=p+1;
        q=0;
        k=k+1; % скільки разів додаємо p
    end;
    sys1=armax(data,[p q]);
    p1=forecast(sys1,data,K);
    p1_znach = p1.OutputData;
    p1_first=p1_znach(1);
        % середня абсолютна помилка
    MAE_p1=0; 
    for i=1:N-KK
        MAE_p1=MAE_p1+abs(Y_fact(i)-p1_znach(i));
    end
    MAE_p1=MAE_p1/(N-KK);
    q=q+1;
end
fprintf('Параметри: p=%.0f; q=%.0f\n',p,q);
    
figure(3)
plot(data,'--bo',p1,'--ro')
grid on
legend('Часовий ряд','Прогноз')
title(['ARMA: p=',num2str(p),', q=',num2str(q)])

% arima
fprintf('\n- ARIMA модель\n')
MAE_p2=MAE_lvl*2;% початкове значення mae
p=1;
q=1;
k=0;
while MAE_p2>MAE_lvl
    if q>16-k 
        p=p+1;
        q=0;
        k=k+1;
    end;
    sys2=armax(data,[p q],'IntegrateNoise',1); %arima
    p2=forecast(sys2,data,K);
    p2_znach = p2.OutputData;
    p2_first=p2_znach(1);
        % середня абсолютна помилка
    for i=1:N-KK
        MAE_p2=MAE_p2+abs(Y_fact(i)-p2_znach(i));
    end
    MAE_p2=MAE_p2/(N-KK);
    q=q+1;
end
fprintf('Параметри: p=%.0f; d=1; q=%.0f\n',p,q);
    
figure(4)
plot(data,'--bo',p2,'--ro');
grid on;
legend('Час. ряд', 'прогноз')
title(['ARIMA: p=',num2str(p),', d=1, q=',num2str(q)])

% ar
fprintf('\n- AR модель\n')
MAE_p3=MAE_lvl*2;% початкове значення mae
p=1;
while MAE_p3>MAE_lvl  
    sys3=armax(data,[p 0]); %ar
    p3=forecast(sys3,data,K);
    p3_znach = p3.OutputData;
    p3_first=p3_znach(1);
     % середня абсолютна помилка
    MAE_p3=0; 
    for i=1:N-KK
        MAE_p3=MAE_p3+abs(Y_fact(i)-p3_znach(i));
    end
    MAE_p3=MAE_p3/(N-KK);
    p=p+1;
end
fprintf('Параметр: p=%.0f\n',p);
    
figure(5)
plot(data,'--bo',p3,'--ro');
grid on;
legend('Час. ряд', 'прогноз')
title(['AR: p=',num2str(p),', q=0'])

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

clear all;
clc;

% модель часового ряду
%                                           |     
Y=[9.9 9.0 8.8 9.7 10.1 9.1 8.9 9.9 9.7 8.3   8.0 9.3 9.2 7.8 7.3 8.7 8.6 9.9 9.5 9.7]; %20

N=length(Y);% довжина часового ряду, кількість спостережень
t=1:N;
if (mod(N,2)~=0) % якщо ряд непарний
n=ceil(N/2)-1;
else
n=N/2;
end

fprintf('Основні характеристики час. ряду:\n');
Y_avg=mean(Y); % знаходчення МО
fprintf('- МО = %.2f \n',Y_avg);
D=cov(Y); % розрахунок дисперсії
fprintf('- Дисперсія = %.4f \n',D);
COR=xcorr(Y);% повертає послідовність автокореляції
P=((t-mean(t))*(Y-mean(Y))')/sqrt(((t-mean(t))*(t-mean(t))')*((Y-mean(Y))*(Y-mean(Y))')); % Коефіцієнт кореляції Пірсона
fprintf('- Коеф. Пірсона = %.4f \n\n',P);

figure(1)
[acf, lags]=autocorr(Y);
stem(lags,acf)% будує графік функції автокореляції (корелограми)
grid on

% МЕТОД КРАЙНІХ ТОЧОК
fprintf('Параметри методу КРАЙНІХ ТОЧОК:\n');
% коефіцієнти рівняння прямої y=b1*t+b0
b1=(Y(n)-Y(1))/(t(n)-t(1));
fprintf('b1 = %.4f \n',b1);
b0=Y(1)-b1*t(1);
fprintf('b0 = %.4f \n\n',b0);
Y1=b0+b1*t; % реалізація моделі прогнозування

% МЕТОД СЕРЕДНІХ ТОЧОК
fprintf('Параметри методу СЕРЕДНІХ ТОЧОК:\n');
t1=sum(t(1:n))/n;
t2=sum(t((n+1):N))/n;
y1=sum(Y(1:n))/n;
y2=sum(Y((n+1):N))/n;
% коефіцієнти рівняння прямої y=a1*t+a0
a1=(y2-y1)/(t2-t1);
fprintf('a1 = %.4f \n',a1);
a0=y1-a1*t1;
fprintf('a0 = %.4f \n',a0);
Y2=a0+a1*t; % реалізація моделі прогнозування

figure(2)
% plot(t,Y,'-kp',t,Y1,'-.rs'); legend('Y','YmKT')
% plot(t,Y,'-kp',t,Y2,'-b*'); legend('Y','YmST')
plot(t,Y,'-kp',t,Y1,'-.rs',t,Y2,'-b*'); legend('Y','YmKT','YmST')
grid on
xlabel('час');
ylabel('Y');

fprintf('\n\nПОКАЗНИКИ ПОМИЛОК:\n\n');
fprintf('МЕТОД КРАЙНІХ ТОЧОК:\n');
error_rate(Y,Y1)

fprintf('МЕТОД СЕРЕДНІХ ТОЧОК:\n');
error_rate(Y,Y2)

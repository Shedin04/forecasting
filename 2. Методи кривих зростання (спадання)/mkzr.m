clear all;
clc;

% модель часового ряду
%                                           |     
%Y=[21.34 23.41 25.31 24.2 28.56 32.21 35.24   31.43 45.78 43.58 53.76 51.87 68.71 74.25 85.45]; %15
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

if (mod (N,2)==0)
nn=n-1;
t=-nn:2:nn;
else 
nn=ceil(n/2)-1;
t=-nn:1:nn;
end
    
% Лінійна модель %
fprintf('Лінійна модель:\n');
% коефіцієнти рівняння прямої y=a0+a1*t
% a0 %
sum_Y=sum(Y(1:n)); % сума ел. від 1 до n
a0_LM=sum_Y/n;
fprintf('a0 = %.4f \n',a0_LM);
% a1 %
YxT=Y(1:n).*t; % добуток ел. ряду (від 1 до n) на t
sum_YxT=sum(YxT);
t2=t.^2;
sum_t2=sum(t2);
a1_LM=sum_YxT/sum_t2;
fprintf('a1 = %.4f \n',a1_LM);

% Параболічна модель %
fprintf('\nПараболічна модель:\n');
% коефіцієнти рівняння прямої y=a0+a1*t+a2*t^2
% a2 %
YxT2=Y(1:n).*t2;
sum_YxT2=sum(YxT2); % сумма y*t^2
t4=t.^4;
sum_t4=sum(t4); % сума t^4
a2_PM=(n*sum_YxT2-sum_t2*sum_Y)/(n*sum_t4-(sum_t2)^2);
fprintf('a2 = %.4f \n',a2_PM);
a1_PM=(sum_YxT)/sum_t2;
fprintf('a1 = %.4f \n',a1_PM);
a0_PM=(sum_Y/n)-(sum_t2/n)*a2_PM;
fprintf('a0 = %.4f \n',a0_PM);

% Експоненціальна модель %
fprintf('\nЕкспоненціальна модель:\n');
% коефіцієнти рівняння прямої y=a*b^t
A=sum(log(Y(1:n)))/n;
B=sum(log(Y(1:n)).*t)/sum_t2;
a_EXP=exp(A);
fprintf('A = ln a = %.4f \n',A);
fprintf('a = %.4f \n',a_EXP);
b_EXP=exp(B);
fprintf('B = ln b = %.4f \n',B);
fprintf('b = %.4f \n',b_EXP);

% Для побудови прогнозу %

i=0;
if (mod(N,2)==0)
for t_gr=-nn:2:(nn+N)
    i=i+1;
    yLM(i)=a0_LM+a1_LM*t_gr;
    yPM(i)=a0_PM+a1_PM*t_gr+a2_PM*t_gr^2;
    yEXP(i)=a_EXP*b_EXP^t_gr;
end
else
for t_gr=-nn:1:(nn+N-n)
    i=i+1;
    yLM(i)=a0_LM+a1_LM*t_gr;
    yPM(i)=a0_PM+a1_PM*t_gr+a2_PM*t_gr^2;
    yEXP(i)=a_EXP*b_EXP^t_gr;
end
end

figure(2)
% plot(1:N,Y,'ko--',1:N,yLM,'--gs'); legend('Y','yLM')
% plot(1:N,Y,'ko--',1:N,yPM,'-.bs'); legend('Y','yPM')
% plot(1:N,Y,'ko--',1:N,yEXP,'-r*'); legend('Y','yEXP')
plot(1:N,Y,'ko--',1:N,yLM,'--gs',1:N,yPM,'-.bs', 1:N,yEXP,'-r*'); legend('Y','yLM','yPM', 'yEXP')
grid on
xlabel('час');
ylabel('Y');

fprintf('\n\nПОКАЗНИКИ ПОМИЛОК:\n\n');
fprintf('Лінійна модель:\n');
error_rate(Y,yLM)

fprintf('Параболічна модель:\n');
error_rate(Y,yPM)

fprintf('Експоненціальна модель:\n');
error_rate(Y,yEXP)

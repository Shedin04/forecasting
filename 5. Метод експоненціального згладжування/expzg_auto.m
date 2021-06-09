clear all;
clc;

%                                           |
Y=[9.9 9.0 8.8 9.7 10.1 9.1 8.9 9.9 9.7 8.3   8.0 9.3 9.2 7.8 7.3 8.7 8.6 9.9 9.5 9.7];

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

req=input('Введіть допустиме значення MAE: ');

figure(1)
[acf, lags]=autocorr(Y);
stem(lags,acf)% будує графік функції автокореляції (корелограми)
grid on

% Метод експоненціального згладжування
Y_expz=Y;
MAE_expz=req*2;
a=0; % поч. значення коеф.
while (MAE_expz>req && a<=1)
for i=n:N-1
     Y_expz(i+1)=a*Y(i)+(1-a)*Y_expz(i);
    expz_first=Y_expz(n+1);
        % середня абсолютна помилка
    MAE_expz=0; 
    for i=n+1:N
        MAE_expz=MAE_expz+abs(Y(i)-Y_expz(i));
    end
    MAE_expz=MAE_expz/n;
end;
a=a+(req/1000);
end
if (MAE_expz>req)
    error('Введіть інше допустиме значення MAE')
else
    fprintf('Постійна згладжування: %f\n',a)
end

figure(2)
Y_expz=Y_expz(n+1:N);
plot(t,Y,'-kp',(n+1:N),Y_expz,'-b*')
grid on
legend('Y','Yexpzl'); title(['Метод експоненціального згладжування a=',num2str(a)])
xlabel('час');
ylabel('Y');

fprintf('\nПОКАЗНИКИ ПОМИЛОК:\n');
error_rate(Y,Y_expz)

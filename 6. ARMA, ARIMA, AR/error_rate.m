function [  ] = error_rate(Y_half, Y1, n)

%Показники помилок  МЕТОД КРАЙНІХ ТОЧОК%
fprintf('- Прогноз (на 1 час. інтервал вперед) = %.4f;\n',Y1(1));
e_Y1=Y_half(1)-Y1(1);
fprintf('- Помилка прогнозу = %.4f;\n',e_Y1);
delta_Y1=abs(Y_half(1)-Y1(1));
fprintf('- Абсолютна помилка прогнозу = %.4f;\n',delta_Y1);
eps_Y1=abs(Y_half(1)-Y1(1))/Y_half(1);
fprintf('- Відносна помилка прогнозу = %.4f;\n',eps_Y1);

% середня абсолютна помилка
MAE_Y1=0;
for i=1:n
    MAE_Y1=MAE_Y1+abs(Y_half(i)-Y1(i));
end
MAE_Y1=MAE_Y1/(n);
fprintf('- MAE = %.4f;\n',MAE_Y1);

% середня абсолютна відсоткова помилка прогнозу
MAPE_Y1=0;
for i=1:n
    MAPE_Y1=MAPE_Y1+abs(Y_half(i)-Y1(i))/Y_half(i);
end
MAPE_Y1=100*MAPE_Y1/n;
fprintf('- MAPE = %.4f;\n',MAPE_Y1);

% середня відсоткова помилка прогнозу
MPE_Y1=0;
for i=1:n
    MPE_Y1=MPE_Y1+(Y_half(i)-Y1(i))/Y_half(i);
end
MPE_Y1=100*MPE_Y1/n;
fprintf('- MPE = %.4f;\n',MPE_Y1);

%коефіцієнт детермінації
R2_Y1=fitlm(Y_half,Y1);
R2_Y1=R2_Y1.Rsquared.Ordinary;
fprintf('- R2 = %.4f\n\n',R2_Y1);
end


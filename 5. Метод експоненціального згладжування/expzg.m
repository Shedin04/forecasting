clear all;
clc;

%                                           |
Y=[9.9 9.0 8.8 9.7 10.1 9.1 8.9 9.9 9.7 8.3   8.0 9.3 9.2 7.8 7.3 8.7 8.6 9.9 9.5 9.7];

N=length(Y);% ������� �������� ����, ������� ������������
t=1:N;
if (mod(N,2)~=0) % ���� ��� ��������
n=ceil(N/2)-1;
else
n=N/2;
end

fprintf('������� �������������� ���. ����:\n');
Y_avg=mean(Y); % ����������� ��
fprintf('- �� = %.2f \n',Y_avg);
D=cov(Y); % ���������� �������
fprintf('- �������� = %.4f \n',D);
COR=xcorr(Y);% ������� ������������ �������������
P=((t-mean(t))*(Y-mean(Y))')/sqrt(((t-mean(t))*(t-mean(t))')*((Y-mean(Y))*(Y-mean(Y))')); % ���������� ��������� ϳ�����
fprintf('- ����. ϳ����� = %.4f \n\n',P);

a=input('������ ������� ������������, a=');

figure(1)
[acf, lags]=autocorr(Y);
stem(lags,acf)% ���� ������ ������� ������������� (�����������)
grid on

% ����� ����������������� ������������
Y_expz=Y;
for i=n:N-1
     Y_expz(i+1)=a*Y(i)+(1-a)*Y_expz(i);
end;

figure(2)
Y_expz=Y_expz(n+1:N);
plot(t,Y,'-kp',(n+1:N),Y_expz,'-b*')
grid on
legend('Y','Yexpzl'); title(['����� ����������������� ������������ a=',num2str(a)])
xlabel('���');
ylabel('Y');

fprintf('\n��������� �������:\n');
error_rate(Y,Y_expz)
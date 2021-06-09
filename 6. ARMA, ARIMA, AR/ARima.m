clc;
clear all;

N=input('������ ������� �������� ����: N=');% ������� �������� ����, ������� ������������
K=input('�� ������ ����������: K=');
A=input('������ ��������� ��� ���������: \nA='); %
B=input('B=');
C=input('C=');
D=input('D=');
t=1:N;
YY=A*(t.^2)+B*t.*sin(t)+C.*rand(1,N)+D; % ��������� �������� ����

if (mod(N,2)~=0) % ���� ��� ��������
n=ceil(N/2)-1;
else
n=N/2;
end

fprintf('\n������ �������������� ���. ����:\n');
YY_avg=mean(YY); % ����������� ��
fprintf('- �� = %.2f \n',YY_avg);
D=cov(YY); % ���������� �������
fprintf('- �������� = %.4f \n',D);
COR=xcorr(YY);% ������� ����������� �������������
P=((t-mean(t))*(YY-mean(YY))')/sqrt(((t-mean(t))*(t-mean(t))')*((YY-mean(YY))*(YY-mean(YY))')); % ���������� ��������� ϳ�����
fprintf('- ����. ϳ����� = %.4f \n\n',P);

figure(1)
[acf, lags]=autocorr(YY);
stem(lags,acf)% ���� ������ ������� ������������� (�����������)
grid on

KK=N-K;
Y=YY(1:KK);

figure(2)
plot(1:KK+K,YY(1:KK+K),'--ko');
grid on;
legend('���. ���')
title('�������� ���. ���')

% arma
fprintf('- ARMA ������\n')
p=input('������ ���������:\np=');
q=input('q=');
data=iddata(Y',[]);
sys1=armax(data,[p q]);
p1=forecast(sys1,data,K);
p1_znach = p1.OutputData;

figure(3)
plot(data,'--bo',p1,'--ro')
grid on
legend('������� ���','�������')
title(['ARMA: p=',num2str(p),', q=',num2str(q)])

%ARIMA%
fprintf('\n- ARIMA ������\n')
p=input('������ ���������:\np=');
q=input('q=');
sys2=armax(data,[4 5],'IntegrateNoise',1); %arima
p2=forecast(sys2,data,K);
p2_znach = p2.OutputData;

figure(4)
plot(data,'--bo',p2,'--ro');
grid on;
legend('���. ���', '�������')
title(['ARIMA: p=',num2str(p),', d=1, q=',num2str(q)])

%AR%
fprintf('\n- AR ������\n')
p=input('������ ��������: p=');
sys3=armax(data,[p 0]); %ar
p3=forecast(sys3,data,K);
p3_znach = p3.OutputData;

figure(5)
plot(data,'--bo',p3,'--ro');
grid on;
legend('���. ���', '�������')
title(['AR: p=',num2str(p)])

Y_fact=YY(KK+1:N); % �������� ���� ������� ��������
fprintf('\n��������� �������:\n');
fprintf('ARMA:\n');
error_rate(Y_fact,p1_znach, K)

fprintf('ARIMA:\n');
error_rate(Y_fact,p2_znach, K)

fprintf('AR:\n');
error_rate(Y_fact,p3_znach, K)

figure(6)
plot(KK+1:N,YY(KK+1:N),'--ko',KK+1:N,p1_znach,'-r',KK+1:N,p2_znach,'-b',KK+1:N,p3_znach,'-g');
grid on;
legend('���. ���', 'ARMA','ARIMA','AR')
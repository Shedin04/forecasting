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

fprintf('������ �������������� ���. ����:\n');
Y_avg=mean(Y); % ����������� ��
fprintf('- �� = %.2f \n',Y_avg);
D=cov(Y); % ���������� �������
fprintf('- �������� = %.4f \n',D);
COR=xcorr(Y);% ������� ����������� �������������
P=((t-mean(t))*(Y-mean(Y))')/sqrt(((t-mean(t))*(t-mean(t))')*((Y-mean(Y))*(Y-mean(Y))')); % ���������� ��������� ϳ�����
fprintf('- ����. ϳ����� = %.4f \n\n',P);

figure(1)
[acf, lags]=autocorr(Y);
stem(lags,acf)% ���� ������ ������� ������������� (�����������)
grid on

Y_psr=Y;
Y_sksr=Y;

k=input('������ ������� ������������: k=');

for i=n:N-1
Y_psr(i+1)=mean(Y(1:i));% ����� ������ (������� ������� �� 10 ��������� �� 19)
Y_sksr(i+1)=mean(Y(i-k+1:i)); % �������� ������
end;

Y_psr=Y_psr(n+1:N); % �������� ���� ����������
Y_sksr=Y_sksr(n+1:N);

figure(2)
% plot(t,Y,'-kp',(n+1:N),Y_psr,'-r*'); legend('Y','Ypsr'); title('����� ������� �������')
% plot(t,Y,'-kp',(n+1:N),Y_sksr,'-b*'); legend('Y','Ysksr'); title(['����� ��������� �������, k=',num2str(k)])
plot(t,Y,'-kp',(n+1:N),Y_psr,'-r*',(n+1:N),Y_sksr,'-b*'); legend('Y','Ypsr','Ysksr'); title(['������� ������������ k=',num2str(k)])
grid on
xlabel('���');
ylabel('Y');

fprintf('\n��������� �������:\n');
fprintf('����� ������:\n');
error_rate(Y,Y_psr)

fprintf('�������� ������:\n');
error_rate(Y,Y_sksr)

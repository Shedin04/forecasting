clear all;
clc;

% ������ �������� ����
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

% ����� ������ %
for i=(n):N-1
     Y_nm(i+1-n)=Y(i);
     Y_nm2(i+1-n)=Y(i)+(Y(i)-Y(i-1));
     Y_nm3(i+1-n)=Y(i)*(Y(i)/Y(i-1));
end

figure(2)
% plot(t,Y,'-kp',(n+1:N),Y_nm,'-b*'); legend('Y','Ynaiv')
% plot(t,Y,'-kp',(n+1:N),Y_nm2,'-.rs'); legend('Y','Ynaiv(1 mod)')
% plot(t,Y,'-kp',(n+1:N),Y_nm3,'-.gr'); legend('Y','Ynaiv(2 mod)')
plot(t,Y,'-kp',(n+1:N),Y_nm,'-b*',(n+1:N),Y_nm2,'-.rs',(n+1:N),Y_nm3,'-.gr'); legend('Y','Ynaiv', 'Ynaiv(1 mod)', 'Ynaiv(2 mod)')
grid on
xlabel('���');
ylabel('Y');

fprintf('\n��������� �������:\n');
fprintf('����� ������:\n');
error_rate(Y,Y_nm)

fprintf('����� ������ (���. 1):\n');
error_rate(Y,Y_nm2)

fprintf('����� ������ (���. 2):\n');
error_rate(Y,Y_nm3)
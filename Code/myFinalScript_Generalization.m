% This experiment aims to extract Fetal ECG from abdomen1.
clear; clc; close all;
load('fecg.mat')

%Fix some range that we zoom in and take a close look. You can pick other
%ranges you like.
t = 15001:19000;

%% Step1: Pre-process the data! 
%Step1(1) pre-process the abdomen1.

%Calculate the moving-local-average in the neibourghood of 50.
LocAv12 = LocalAverage(abdomen1, 50);
LocAv22 = LocalAverage(abdomen2, 50);
LocAv11 = LocalAverage(abdomen1, 50);
LocAv21 =  LocalAverage(abdomen2, 50);
LocAv31 =  LocalAverage(abdomen3, 35);



%Minus the moving-local-average to erase the baseline drifting. 
%
Y12_1 = abdomen1 - LocAv12;
Y22_1 = abdomen2 - LocAv22;
Y11_1 = abdomen1 - LocAv11;
Y21_1 = abdomen2 - LocAv21;
Y31_1 = abdomen3 - LocAv31;



%Apply low-pass fir filter to erase the high frequency noise.
order12  = 10;
fs12 = 1000;
cutlow12  = 0.2;
[b12,a12]    = fir1(order12,cutlow12/(fs12/2), 'low');
Y12_2   = filter(b12,a12,Y12_1);

order22  = 20;
fs22 = 1000;
cutlow22  = 0.2;
[b22,a22] = fir1(order22,cutlow22/(fs22/2), 'low');
Y22_2   = filter(b22,a22,Y22_1);

order11  = 10;
fs11 = 1000;
cutlow11  = 0.2;
[b11,a11]    = fir1(order11,cutlow11/(fs11/2), 'low');
Y11_2   = filter(b11,a11,Y11_1);

order21  = 20;
fs21 = 1000;
cutlow21  = 0.2;
[b21,a21] = fir1(order21,cutlow21/(fs21/2), 'low');
Y21_2   = filter(b21,a21,Y21_1);

order31  = 10;
fs31 = 1000;
cutlow31  = 0.2;
[b31,a31] = fir1(order31,cutlow31/(fs31/2), 'low');
Y31_2   = filter(b31,a31,Y31_1);

%Step1(2) Pre-process the reference signal thorax2.

%Find the QRS of thorax1.
thres = max(abs(thorax1))/1.148;
QRS = QRS_Extraction(thorax1,thres,80);

%Find the QRS of thorax2.
thres = max(abs(thorax2))/1.148;
QRS = QRS_Extraction(thorax2,thres,80);



%% Step2: Apply the denoise filter!
[approx12,error12] = za_lms(Y12_2,QRS',1e-10,0.9e-9,150);
[approx22,error22] = za_lms(Y22_2,QRS',1e-10,0.9e-9,150);
[approx11,error11] = za_lms(Y11_2,QRS',1e-10,0.9e-9,150);
[approx21,error21] = za_lms(Y21_2,QRS',1e-10,0.9e-9,150);
[approx31,error31] = za_lms(Y31_2,QRS',1e-10,0.9e-9,150);




%% Plot the Figures!


figure
subplot(5,1,1)
plot(t,error12(t),'r',t,abdomen1(t)/7 - 150,'b', t,thorax2(t)/90 - 300,'g')
axis([15001 19000 -400 800])
title('Extract fECG from abdomen1 and thorax2')
legend('Extracted fECG\_12(t)','abdomen1(t)', 'thorax2(t)')


subplot(5,1,2)
plot(t,error22(t),'r',t,abdomen2(t)/7 - 150,'b', t,thorax2(t)/90 - 300,'g');
axis([15001 19000 -400 800])
title('Extract fECG from abdomen2 and thorax2')
legend('Extracted fECG\_22(t)','abdomen2(t)', 'thorax2(t)')


subplot(5,1,3)
plot(t,error11(t),'r',t,abdomen1(t)/7 - 150,'b', t,thorax1(t)/90 - 300,'g');
axis([15001 19000 -400 800])
title('Extract fECG from abdomen1 and thorax1')
legend('Extracted fECG\_11(t)','abdomen1(t)', 'thorax1(t)')


subplot(5,1,4)
plot(t,error21(t),'r',t,abdomen2(t)/7 - 150,'b', t,thorax1(t)/90 - 300,'g');
axis([15001 19000 -400 800])
title('Extract fECG from abdomen2 and thorax1')
legend('Extracted fECG\_21(t)','abdomen2(t)', 'thorax1(t)')


subplot(5,1,5)
plot(t,error31(t),'r',t,abdomen3(t)/7 - 150,'b', t,thorax1(t)/90 - 300,'g');
axis([15001 19000 -400 600])
title('Extract fECG from abdomen3 and thorax1')
legend('Extracted fECG\_31(t)','abdomen3(t)', 'thorax1(t)')


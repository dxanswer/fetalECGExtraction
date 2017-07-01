% This experiment aims to extract Fetal ECG from abdomen3.
clear; clc; close all;
load('fecg.mat')

%Fix some range that we zoom in and take a close look. You can pick other
%ranges you like.
t = 15001:19000;

%% Step1: Pre-process the data! 
%Step1(1) pre-process the abdomen3.

%Calculate the moving-local-average in the neibourghood of 50.
LocAv = LocalAverage(abdomen3, 20);

%Minus the moving-local-average to erase the baseline drifting. 
Y1 = abdomen3 - LocAv;

%Apply low-pass fir filter to erase the high frequency noise.
order1  = 15;
fs1 = 1000;
cutlow1  = 0.2;
[b1,a1]    = fir1(order1,cutlow1/(fs1/2), 'low');
Y2   = filter(b1,a1,Y1);

%Step1(2) Pre-process the reference signal thorax2.

%Find the QRS of thorax2.
thres = max(abs(thorax2))/1.148;
QRS = QRS_Extraction(thorax2,thres,80);


%% Step2: Apply the denoise filter!
[approx,error] = za_lms(Y2,QRS',1e-10,0.9e-9,150);




%% Plot the Figures!


%Plot Fig 1 in report. 
figure 
plot(t,abdomen3(t),'r',t,Y1(t),'-b')
legend('abdomen3(t)','abdomen3\_bc(t)')

%Plot Fig 2 in report. 
figure 
plot(t,abdomen3(t),'r',t,Y2(t),'-b')
legend('abdomen3(t)','pre\_processed\_abdomen3(t)')

%Figure 3 is from the literature [1].

%Plot Fig 4 in the report
figure
plot(t,thorax2(t),'r',t,QRS(t),'--b')
legend('thorax2(t)','QRS\_thorax2(t)')

%Plot Fig 5 in the report
figure
plot(t,approx(t),'b',t,Y2(t),'--g',t,error(t),'r');
legend('learned\_QRS\_thorax2(t)','QRS\_thorax2(t)', 'extracted\_fECG\_32(t)')


%Plot Fig 6 in the report
figure 
plot(t,error(t),'r',t,abdomen3(t)/7 - 150,'b', t,thorax2(t)/90 - 300,'g');
legend('extracted\_fECG\_32(t)','abdomen3(t)', 'thorax2(t)')

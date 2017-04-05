% This program is to demonstrate the phase retrieve Algorithm. 
% The program starts with a nice gray image: OriginPhoto, then CamSignal 
% function takes only the amplitude of its fft2 (absQ) as the input for Algorithm.
% Some noise and conversion of image to uint16 are applied to the image and
% absQ to simulate the real experiment.
% The Algorithm then recovers the original image with only absQ as an input
% The Algorithm will run continuosly with different starting guess until 
% the error is lower than threshold or number of run reaches the target. 
clear all;
close all;
tic
%% Load the photo, caculate its Fourier Amplitude,
OriginPhoto = im2double(imread('R100s.png')); % Original Photo. We use this one to generate the artificial experiment
absQ = CamSignal(OriginPhoto);
% We do need a special treat for the noisy case. The absQ signal need some
% filters as paper mentioned
%% Setup parameters for Algorithm and plot

cond = 'Positive and Real';  % Condition for the image. Please see the Constrain Function
beta = 2;               % For HIO
decrement = 0.04;       % For HIO
nER = 50;               % For ER
Esp = 0.001;             % Threshold for Err that is considered perfect fit. This defines our expectation (0.01 is good enough)
MaxRun = 100;            % Maximum run to find the best. To avoid many runs

%% Run the Algorithm and plot images
toc
loop=0;

minErr=1000;

while not((minErr < Esp)||(loop > MaxRun))
    g = rand(size(absQ));
    [g, ErrHIO] = HIO(g, absQ, beta, decrement, cond);
    [g, ErrER] = ER(g, absQ, nER, cond);
    loop = loop+1;
    if ((loop==1)||(ErrER(end)<minErr))
        BestGuess = g;
        BestErr = [ErrHIO, ErrER];
        minErr = ErrER(end);
    end        
    toc
end;
figure
subplot(1,2, 1); % Possition of the subplot
imshow(mat2gray(centerImg(BestGuess)));
% title(cond);
title(['Error= ', num2str(BestErr(end),'%10.2e')]);  

% Ploting the Error        
subplot(2,2,2); % Position of the subplot
semilogy(BestErr, 'b'); hold on;
semilogy([length(ErrHIO),length(ErrHIO)], [min(BestErr),max(BestErr)], 'r'); 
title(['Error= ', num2str(BestErr(end),'%10.2e')]);  

% Ploting the Error change        
ErrChange = abs(diff(BestErr));   % Just want to see the magnitude of the change
subplot(2,2,4); % Position of the subplot
semilogy(ErrChange, 'b'); hold on;
semilogy([length(ErrHIO),length(ErrHIO)], [min(ErrChange),max(ErrChange)], 'r'); 
title(['Last Error Change = ', num2str(ErrChange(end),'%10.2e')]);  
toc
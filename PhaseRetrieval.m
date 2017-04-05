% This program is to demonstrate the phase retrieve Algorithm. 
% The program starts with a nice gray image: OriginPhoto, then CamSignal 
% function takes only the amplitude of its fft2 (absQ) as the input for Algorithm.
% Some noise and conversion of image to uint16 are applied to the image and
% absQ to simulate the real experiment.
% The Algorithm then recovers the original image with only absQ as an input
% The Algorithm will run serveral time with different starting guess. 
clear all;
close all;
tic
%% Load the photo, caculate its Fourier Amplitude,
OriginPhoto = im2double(imread('fS.png')); % Original Photo. We use this one to generate the artificial experiment
absQ = CamSignal(OriginPhoto);
% We do need a special treat for the noisy case. The absQ signal need some
% filters as paper mentioned
%% Setup parameters for Algorithm and plot

cond = 'Positive and Real';  % Condition for the image. Please see the Constrain Function
beta = 2;               % For HIO
decrement = 0.04;       % For HIO
nER = 50;               % For ER

plotRow = 2;            % #of Row for plot. Use small number for testing
plotCol = 2;            % #of Col for plot. Use small number for testing

%% Run the Algorithm and plot images
imageFig = figure;
ErrFig = figure;
ChangeFig = figure;
toc
for m=1:plotRow
    for k=1:plotCol   

        g = rand(size(absQ));
        [g, ErrHIO] = HIO(g, absQ, beta, decrement, cond);
        [g, ErrER] = ER(g, absQ, nER, cond);
        Err = [ErrHIO, ErrER];
        plotPos=(m-1)*plotCol+k
        
        % Ploting the Error        
        figure(ErrFig);
        subplot(plotRow,plotCol, plotPos); % Position of the subplot
        semilogy(Err, 'b'); hold on;
        semilogy([length(ErrHIO),length(ErrHIO)], [min(Err),max(Err)], 'r'); 
        title(['Error= ', num2str(ErrER(end),'%10.1e')]);      
        
        % Ploting the Change        
        figure(ChangeFig);
        subplot(plotRow,plotCol, plotPos); % Possition of the subplot
        ErrChange = abs(diff(Err));   % Just want to see the magnitude of the change
        semilogy(ErrChange, 'b'); hold on;
        semilogy([length(ErrHIO),length(ErrHIO)], [min(ErrChange),max(ErrChange)], 'r'); 
        title(['Last Change= ', num2str(ErrChange(end),'%10.1e')]);
        
        % Show the recovered image        
        figure(imageFig);       
        subplot(plotRow,plotCol, plotPos); % Position of the subplot
        imshow(mat2gray(centerImg(g)));
        title(['Error= ', num2str(ErrER(end),'%10.1e')]);        
        toc
    end;
end;
toc
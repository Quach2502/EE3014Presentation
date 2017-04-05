function output = CamSignal(input)
% This function simulates the real experiment where the input is the original image and 
% output is the signal from CCD capture the light after passing through scattering media 
% The program will add some noise to the original image. This is actually the background noise
% from room environment and laser. This should be very small
% Then it calculate FFT then add some noise to FFT to simulate the CCD noise

%% Parameters
BgNoise = 0e-3; % Variance of the gaussian noise for background
Bg = 0; % mean of gaussian noise for background
FFTnoise = 0e-10; % Variance of the gaussian noise for CCD
FftBg = 0; % mean of gaussian noise for CCD

CCDbitDepth = 16;

%% IMAGE
NoiseImg = imnoise(input, 'gaussian', Bg, BgNoise);
figure; 
subplot(2,2, 1); imshow(mat2gray(input)); title('Original Image');
subplot(2,2, 3); imshow(mat2gray(NoiseImg)); title(['Noisy Image: Noise = ', num2str(BgNoise)]);

%% FFT Image and CCD measurement
FftImg = fftshift(fft2(NoiseImg));
absQ = abs(FftImg);  % Amplitude of Frourier is the input for Algorithm
PhaseQ = exp(1i*angle(FftImg));

% CCD measure this intensity then do ADC to its bit depth. CCD will introduce some noise
ScaleUp = (2^CCDbitDepth-1)/max(absQ(:));

output = uint16(absQ*ScaleUp); % Convert image to 16 bit gray image as output of high quality CCD. We lose some precision here.

output = imnoise(output, 'gaussian', FftBg, FFTnoise);
output = double(output); % For precise calculation of algorithm

subplot(2,2, 2); imshow(mat2gray(output)); 
title(['Noisy FFT Image, FFTnoise = ', num2str(FFTnoise)]);
subplot(2,2, 4); imshow(mat2gray(abs(ifft2(ifftshift(output.*PhaseQ))))); % Expected recovered if phase is known. Noisy CCD makes it far from ideal 
title(['Ideal Inversed Image, FFTnoise = ', num2str(FFTnoise)]);

%% To calculate how much is the real noise added to the image
% NoiseOnly = output - round(absQ*ScaleUp);
% figure;
% plot(NoiseOnly);
% min(NoiseOnly(:))
% max(NoiseOnly(:))

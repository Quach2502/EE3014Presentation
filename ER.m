function [output, Error] = ER(Guess, Amp, nER, cond);
% This is to implement Error Redution Algorithm.
Error = zeros(1,nER);
normAmp = norm(Amp,'fro'); % to normalize the Error
for count = 1:nER
    G = fftshift(fft2(Guess));
    theta = angle(G);
    G_next = Amp.* exp(1i.*theta);
    g_next = ifft2(ifftshift(G_next));
    
    Sigma = Constrain(g_next,cond); %The position of all the good points, i.e. Positive, Real...
    Guess = Sigma.*real(g_next);
    Error(count) = norm(Amp - abs(G),'fro')/normAmp;
end
output = Guess;
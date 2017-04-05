function [output, Error] = HIO(Guess, Amp, beta, decrement, cond);
% This is to implement Hibrid Input and Output Algorithm.
Error = zeros(1,floor(beta/decrement)); 
count = 1;
normAmp = norm(Amp,'fro'); % to normalize the Error
while (beta >= 0)
    for k = 1:10   
        G = fftshift(fft2(Guess));
        theta = angle(G);
        G_next = Amp .* exp(1i.*theta);
        g_next = ifft2(ifftshift(G_next));
        Sigma = Constrain(g_next,cond); %The position of all the good points, i.e. Positive, Real...
        Guess = Sigma.*real(g_next) + (1-Sigma).*(real(Guess) - beta * real(g_next));
    end
    Error(count) = norm(Amp - abs(G),'fro')/normAmp;
    count = count+1;
    beta = beta - decrement;
end
output = Guess;
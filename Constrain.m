function output = Constrain(input, condition);
% This is to find the position that satisfies the condition from the input matrix.
Esp = 1e-6;
switch condition 
    case 'Positive and Real'
        output = (imag(input)<Esp).*(real(input)>=0);
    case 'Positive Real'
        output = (real(input)>=0);
end;
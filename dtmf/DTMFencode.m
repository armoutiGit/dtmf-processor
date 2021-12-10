function [x, fs] = DTMFencode(key, duration, weight, fs)

% handle optional args
switch nargin
    case 1
        duration = 200 / 1000; % milliseconds to seconds
        weight = [1 1];
        fs = 8000; % Hz
    case 2
        duration = duration / 1000;
        weight = [1 1];
        fs = 8000;
    case 3
        duration = duration / 1000;
        fs = 8000;
    case 4
        duration = duration / 1000;
        if fs < 3000
            fs = 8000; % use default fs for unacceptable fs input
        end
end

keypadCol =  [1209 1336 1477];
keypadRow =  [697 770 852 941];
keypad = ['1' '2' '3'; '4' '5' '6'; '7' '8' '9'; '*' '0' '#'];

if ismember(key, keypad)
    [row, col] = find(keypad == key);
end

t = 0 : (1/fs) : duration;
x =  weight(1) .* sin(2*pi * keypadRow(row) * t) +  weight(2) .* sin(2*pi * keypadCol(col) * t);

plot(t, x);
x = x / max(abs(x));


end
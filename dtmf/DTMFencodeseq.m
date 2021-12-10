function [x, fs] = DTMFencodeseq(key, duration, weight, fs)

x = zeros(1,0);
pause = zeros(1, 2000);
x = horzcat(x, pause);
for i = 1 : length(key)
    thisk = key(i);
    [encode, fs] = DTMFencode(thisk, duration, weight, fs);
    x = horzcat(x, encode, pause);
end

x = x';

end
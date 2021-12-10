function [clean, fs] = DTMFclean(sig, fs)

centerfreqs = [697 770 852 941 1209 1336 1477];

%to clean a signal
f = fs/2*linspace(-1,1,length(sig));
z = fftshift(fft(sig));

L = [107, 104, 98, 95, 66, 62, 59];
%bpfilters = zeros(max(L), length(centerfreqs));
rec = zeros(length(sig) + max(L) - 1, 1);

interval = 0: pi/1000: pi;

for k = 1:length(centerfreqs)
    l = L(k);
    impulse = cos(2*pi*centerfreqs(k)*(0:l-1)/fs);
    ffr = freqz(impulse, 1, interval); % filter frequency response
    beta = 1 / max(abs(ffr));
    bpfilter = beta * impulse;
    
    myconv = conv(sig, bpfilter);
    myconv = vertcat(myconv, zeros(length(rec) - length(myconv), 1));
    rec = rec + myconv;
end
    
clean = rec;

end
function [key, fs] = DTMFdecode(filename)

centerfreqs = [697 770 852 941 1209 1336 1477];
keypad = ['1' '2' '3'; '4' '5' '6'; '7' '8' '9'; '*' '0' '#'];

[x, fs] = audioread(filename);

% convert signal to frequency domain
f = fs/2 * linspace(-1,1,length(x)); %frequency axis
z = abs(fftshift(fft(x))); % for magnitude spectrum
% plot(f,z) to visualize


L = 85; % bandwidth - can change slightly if necessary
bpfilters = zeros(L, length(centerfreqs));

interval = 0: pi/1000: pi;

for k = 1:length(centerfreqs)
    impulse = cos(2*pi*centerfreqs(k)*(0:L-1)/fs);
    ffr = freqz(impulse, 1, interval); % filter frequency response
    %plot(interval, abs(ffr) ./ max(abs(ffr))); % to visualize for
    %bandwidth optimization
    beta = 1 / max(abs(ffr));
    bpfilters(:,k) = beta * impulse;
end
%now we have our bandpass filters. Let's find out which center frequencies
%are present in our input signal!

x_norm = 2 * x / max(abs(x));
score = zeros(1, length(centerfreqs));
for j = 1:length(centerfreqs)
    myconv = conv(x_norm, bpfilters(:,j));
    %plot(myconv);
    score(j) = max(abs(myconv));
end
% disp(score)
%plot(abs(conv(x_norm, bpfilters(:,2))))
[row, r] = max(score(1:4));
[col, c] = max(score(5:7));

key = keypad(r, c);

end


%filtering noisy dtmf signal - scrap work
% f = fs/2 * linspace(-1,1,length(snippet));
% z = abs(fftshift(fft(snippet)))
% 
% indices = z > 5
% zfiltered = indices .* z
% 
% snipfiltered = ifft(ifftshift(zfiltered))
% 
% %snipfiltered = real(snipfiltered)
function [sig, indices] = dtmfcut(clean,fs)

sig = clean;
[up, ~] = envelope(sig, 1000, 'rms');

smooth = smoothdata(up);
smooth = round(smooth, 3); % so that we dont overcount peaks because
% of small changes
smooth = smooth ./ max(abs(smooth));

[pks, locs, ~, prom] = findpeaks(-smooth);
maxprom = max(abs(prom));

scal = 0.02 * maxprom;
if isempty(maxprom) % extreme edge case for no peaks
    scal = 0;
end
[~,indices]= findpeaks([-Inf; -smooth; -Inf],"MinPeakProminence", scal);

indices = indices - 1; % avoid index out of range

% n = (1 : length(sig)) / fs;
% plot(n, sig);
% hold on;
% plot(n , -smooth);
% figure;
% f = fs/2*linspace(-1,1,length(sig));
% plot(f, abs(fftshift(fft(sig))));
% figure;
%disp(indices);

end
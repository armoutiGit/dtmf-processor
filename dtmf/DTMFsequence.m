function [seq, fs] = DTMFsequence(filename)

[x, fs] = audioread(filename);
[x, fs] = DTMFclean(x, fs);

[sig, indices] = dtmfcut(x, fs);

seq = '';

for i = 1:length(indices) - 1
    keypress = x(indices(i): indices(i + 1));
    keypress = keypress ./ max(abs(keypress)); % just to avoid data
    % clipping when writing file
    audiowrite('file.wav', keypress, fs);
    key = DTMFdecode('file.wav');
    seq = strcat(seq, key);
end


end

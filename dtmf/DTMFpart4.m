function [error, err] = DTMFpart4(noisefile, cell)

keypad = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'};

%[sig, fs] = DTMFsequence(sigfile);

[n, nfs] = audioread(noisefile);
n = n ./ max(abs(n));
n = vertcat(n,n,n);


error = zeros(1, 50);
err = zeros(1, 31);
for i = 0 : 0.1 : 3
    %disp(i)
    for j = 1 : 50
        c = cell(j);
        seq = cell2mat(c);
        seq = char(seq);
        %disp(seq)

        tone_duration = randi([50 600], 1, 1);
        w1 = randi([1 10], 1, 1);
        w2 = randi([1 10], 1, 1);
      
        fs = randi([3000 15000], 1, 1);
        [sig, fs] = DTMFencodeseq(seq, tone_duration, [w1 w2], fs);
        
        noise = n(1 : length(sig));
        
        y = sig + (i * noise);
        y = y ./ max(abs(y)); % avoid data clipping when writing file
        audiowrite('y.wav', y, fs);
        [check, yfs] = DTMFsequence('y.wav');

        %now check error
        
        numdig = length(seq);
        
        numcorrect = 0;
     
        dist = editDistance(seq, check); % levenshtein distance
        
        if dist > numdig
            error(1,j) = 1;
        else
            error(1,j) = dist / numdig;
        end
        
    end
    %disp(i)
    err(floor((i*10) + 1)) = mean(error);
end


end
function [error, err] = DTMFpart5(cell)

keypad = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'};

%[sig, fs] = DTMFsequence(sigfile);
%[noise, nfs] = DTMFsequence(noisefile);

error = zeros(1, 50);
err = zeros(1, 31);
for i = 0 : 0.1 : 3
    disp(i)
    for j = 1 : 50
        c = cell(j);
        seq = cell2mat(c);
        seq = char(seq);
        
%         indexes = randi(length(keypad), 1, 15);
%         seq = cell2mat(keypad(indexes));
        
        tone_duration = randi([50 600], 1, 1);
        w1 = randi([1 10], 1, 1);
        w2 = randi([1 10], 1, 1);
        fs = randi([3000 15000], 1, 1);
        [sig, fs] = DTMFencodeseq(seq, tone_duration, [w1 w2], fs);
        
        [y,h,Fs] = addreverb(sig,fs, i);
        
        y = y ./max(abs(y)); % avoid data clipping when writing file
        audiowrite('y.wav', y, Fs);
        [check, yfs] = DTMFsequence('y.wav');

        %now check error
        
        numdig = length(seq);
        
%         numcorrect = 0;
%      
%         if length(seq) ~= length(check)
%             numcorrect = 0;
%         else
%             for k = 1 : length(seq)
%                 if strcmp(seq(k), check(k))
%                     numcorrect = numcorrect + 1;
%                 end
%             end
%         end
%         error( 1, j) = (numdig - numcorrect) / numdig;
        dist = editDistance(seq, check);
        
        if dist > numdig
            error(1,j) = 1;
        else
            error(1,j) = dist / numdig;
        end
        
    end
    err(floor((i*10) + 1)) = mean(error);
end

%err = mean(error, 1);

end
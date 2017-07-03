function [answers] = GetAnswer(output, thresholdH, thresholdD,thresholdA)
    nrTests = size(output,2);
    answers = zeros(1,nrTests);
    for i = 1:nrTests
        if output(3,i) > thresholdA
            answers(i) = 3;
        elseif output (1,i) > thresholdH
            answers(i) = 1;
        else
            answers(i) = 2;
        end
    end
end


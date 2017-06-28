function [answers, output] = Test(net, tests, thresholdW, thresholdD,thresholdA)
    output = sim(net,tests);
    nrTests = size(tests,2);
    answers = zeros(1,nrTests);
    x = thresholdD;
    for i = 1:nrTests
        if output(3,i) > thresholdA
            answers(i) = 3;
        elseif output (1,i) > thresholdW
            answers(i) = 1;
        else
            answers(i) = 2;
        end
    end

end


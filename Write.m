answers = GetAnswer(output, thresholds(1), thresholds(2),thresholds(3));
answers1 = GetAnswer1(output, thresholds(1), thresholds(2),thresholds(3));
final = zeros(size(output,2),2);
final(:,1) = 1:size(final,1);
final(:,2) = answers;

csvwrite(outputFile,final);

final(:,2) = answers1;
csvwrite(outputFile1,final);

csvwrite(strcat('./tests/',outputFile),final);
partition = [numel(find(answers==1)) numel(find(answers==2)) numel(find(answers==3))];
partition1 = [numel(find(answers1==1)) numel(find(answers1==2)) numel(find(answers1==3))];

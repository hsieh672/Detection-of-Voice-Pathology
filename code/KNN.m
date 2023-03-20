correct=0;
predict_label=trainedModel3.predictFcn(Data_test(:,2:27));

for k=1:length(predict_label)
        if predict_label(k,1)==Data_test(k,1)
            correct=correct+1;
        end
end

accuracy_frame=(correct/length(predict_label))*100;

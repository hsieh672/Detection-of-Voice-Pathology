correct_frame=0;
correct=0;
i=1;
number_person=cat(1,number_person3,number_person4);

for m=1:20
    correct_frame=0; 
    for n=i:i+number_person(m,1)-1
        if predict_label(n,1)==Data_test(n,1)
            correct_frame=correct_frame+1;
        end
        i=i+1;
    end
    if (correct_frame/number_person(m,1))>0.5
       correct=correct+1;
    end
end   

accuracy_person=(correct/20)*100;




# Detection-of-voice-pathology
KNN (K-Nearest Neighbors) algorithm can be used for vocal cord disorders by analyzing the acoustic properties of voice signals.
## MFCC feature extraction
The MFCC feature extraction technique basically includes windowing the signal, applying the DFT, taking the log of the magnitude, and then warping the frequencies on a Mel scale, followed by applying the inverse DCT.  
![MFCC](https://www.mathworks.com/help/examples/audio_wavelet/win64/SpeakerIdentificationUsingPitchAndMFCCExample_01.png)  

In this project, we need to use mfcc_v2.m to produce 13-dimensional MFCC, set cep_size = 12 means the dimension = 13.  
```sh
% set constants begin %
sample_rate=36000;%16000
% sample_rate=36000;
frame_time=30;                                             %ms
frame_move_time=15;                                         %ms
frame_size=floor(sample_rate*frame_time*10^(-3));          %pts
frame_move=floor(sample_rate*frame_move_time*10^(-3));     %pts
fft_number=2^(ceil(log2(frame_size)));
fft_vec_size=floor(fft_number/2);

mel_filter_number=23;       %一個frame的點要超過mel_filter_number,否則會有-inf和NaN
ceplifter=22;
cep_size=12;  %12表示是取13維
static_feature_size=cep_size+1;%c1-c12 plus c0%
```
## Linking and labeling training and teating data
Here I used label_person.m to divide the data into with disease or without disease (normal), with disease labeled as 1 and normal labeled as 0.  
```sh
file_path='C:/Users/Chen Alex/Documents/DSP/PPT/109_1/2020 DSP_Project_II/Dataset/Output/';
%------------------train data path--------------
% can data converse to Nor data,the label is 0
train_nor_path=[file_path '/train/nor'];
% uncan data converse to Nor data,the label is 1
train_sick_path=[file_path '/train/sick']; 
%-----------------test data path----------------
% can data converse to Nor data,the label is 0
test_nor_path=[file_path '/test/nor'];
% uncan data converse to Nor data,the label is 1
test_sick_path=[file_path '/test/sick']; 
```
![label](https://github.com/hsieh672/Detection-of-voice-pathology/blob/main/imag/label.png)  

## Classification using K-Nearest Neighbor (KNN) algorithm 
#### The KNN working can be explained on the basis of the below algorithm:  
1. Select the number K of the neighbors  
2. Calculate the Euclidean distance of K number of neighbors  
3. Take the K nearest neighbors as per the calculated Euclidean distance.  
4. Among these k neighbors, count the number of the data points in each category.  
5. Assign the new data points to that category for which the number of the neighbor is maximum.  
6. Our model is ready.  
![KNN](https://miro.medium.com/v2/resize:fit:1182/format:webp/0*elaSSkBa3Gi9H1-x.png)  

In real-life medical research, doctors do not study isolated sound frames because it is difficult to determine which individuals are healthy or sick within these frames. Therefore, it is necessary to know the actual number of individuals in order to identify which ones are special sound cases (with results consistently opposite to the test) or general sound cases, and discuss these special cases accordingly. Thus, a conversion of individuals is needed. Firstly, set the threshold value for sound frames to be 0.5, and determine the predicted status of an individual as healthy or sick. Within the normal testing range, when the predicted label is greater than 0.5, it is considered normal (0), and when it is less than 0.5, it is considered sick (1). Within the sick testing range, when the predicted label is greater than 0.5, it is considered sick (1), and when it is less than 0.5, it is considered normal (0). Therefore, there are four possible scenarios:

1. When a test individual is known to be normal (0), and the predicted result is above the threshold of 0.5, it is predicted as normal (0).  
2. When a test individual is known to be normal (0), and the predicted result is below the threshold of 0.5, it is predicted as sick (1).  
3. When a test individual is known to be sick (1), and the predicted result is above the threshold of 0.5, it is predicted as sick (1).  
4. When a test individual is known to be sick (1), and the predicted result is below the threshold of 0.5, it is predicted as normal (0).  
#### Predict by frame
```sh
correct=0;
predict_label=trainedModel3.predictFcn(Data_test(:,2:27));

for k=1:length(predict_label)
        if predict_label(k,1)==Data_test(k,1)
            correct=correct+1;
        end
end

accuracy_frame=(correct/length(predict_label))*100;
```
#### Predict by person
```sh
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
```
|                  | K=1   | K=3   | K=5   | K=7   |
|------------------|-------|-------|-------|-------|
| Accuracy(R=0.3)  | 78.9% | 79.2% | 79.5% | 79.8% |
| Accuracy(person) | 80%   | 80%   | 80%   | 80%   |

## Simulation result
| .wav     | Length(frame) | Result |
|----------|---------------|--------|
| 006604-2 | 913           | 0      |
| 134066-2 | 1327          | 1      |
| 154833-2 | 2296          | 0      |
| 421634-2 | 1196          | 0      |
| U44346-2 | 868           | 1      |
| U99176-2 | 1070          | 0      |
| W05597-2 | 527           | 1      |
| W12303-2 | 935           | 1      |

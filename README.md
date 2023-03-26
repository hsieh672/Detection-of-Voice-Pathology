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
![KNN](https://static.javatpoint.com/tutorial/machine-learning/images/k-nearest-neighbor-algorithm-for-machine-learning2.png)

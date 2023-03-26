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
Here I used label_person.m to divide the data into with disease or without the disease (normal), with disease labeled as 1 and normal labeled as 0.  

path = 'C:\Users\�¨Χ�\Desktop\DSP�M�D�G\mfcc\mfcc_nor_train\';% ��Jmfc�ɸ��|��Ƨ�
 cd(path)                                 % �i�J�������Ƨ�
 file=dir([path '\*.mfc']);
 Data= [];
for i = 1:length(file)
     cep_data = load(file(i).name);            % Ū�J�C��mfc��
     number_person1(i,:) = length(cep_data(:,1));  % �C��mfc�ɪ�����
 	Data= [Data;cep_data];                 % �P�W��mfc�ɶi����p
 end
 lable=zeros(length(Data),1)
 Data_normal_train=[lable Data]
 
 
 path = 'C:\Users\�¨Χ�\Desktop\DSP�M�D�G\mfcc\mfcc_im_train\';% ��Jmfc�ɸ��|��Ƨ�
 cd(path)                                 % �i�J�������Ƨ�
 file=dir([path '\*.mfc']);
 Data= [];
 for i = 1:length(file)
     cep_data = load(file(i).name);            % Ū�J�C��mfc��
     number_person2(i,:) = length(cep_data(:,1));  % �C��mfc�ɪ�����
 	Data= [Data;cep_data];                 % �P�W��mfc�ɶi����p
 end
 lable=ones(length(Data),1)
 Data_im_train=[lable Data]
 
 Data_train=[Data_normal_train;Data_im_train]
  
 path = 'C:\Users\�¨Χ�\Desktop\DSP�M�D�G\mfcc\mfcc_nor_test\';% ��Jmfc�ɸ��|��Ƨ�
 cd(path)                                 % �i�J�������Ƨ�
 file=dir([path '\*.mfc']);
 Data= [];
 for i = 1:length(file)
     cep_data = load(file(i).name);            % Ū�J�C��mfc��
     number_person3(i,:) = length(cep_data(:,1));  % �C��mfc�ɪ�����
 	Data= [Data;cep_data];                 % �P�W��mfc�ɶi����p
 end
 lable=zeros(length(Data),1)
 Data_normal_test=[lable Data]
 
 
 path = 'C:\Users\�¨Χ�\Desktop\DSP�M�D�G\mfcc\mfcc_im_test\';% ��Jmfc�ɸ��|��Ƨ�
 cd(path)                                 % �i�J�������Ƨ�
 file=dir([path '\*.mfc']);
 Data= [];
 for i = 1:length(file)
     cep_data = load(file(i).name);            % Ū�J�C��mfc��
     number_person4(i,:) = length(cep_data(:,1));  % �C��mfc�ɪ�����
 	Data= [Data;cep_data];                 % �P�W��mfc�ɶi����p
 end
 lable=ones(length(Data),1)
 Data_im_test=[lable Data]
 
 Data_test=[Data_normal_test;Data_im_test]


